//
//  EventsTableViewController.m
//  
//
//  Created by Cole on 7/5/15.
//
//

#import "EventsTableViewController.h"

@interface EventsTableViewController ()

-(void)getEvents;
@property (strong, nonatomic) NSMutableArray *events;
@property (strong, nonatomic) NSString *username;

@end

@implementation EventsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //username
    PFQuery *query = [PFQuery queryWithClassName:@"UserName"];
    [query fromLocalDatastore];
    self.username = NULL;
    self.username = [query getFirstObject][@"name"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)update:(UIBarButtonItem *)sender
{
    //update events
    NSLog(@"Update events");
    [self getEvents];
}

//update events
-(void)getEvents
{
    //calendar stuff
    EKEventStore *store = [[EKEventStore alloc] init];
    
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        // handle access here
        if(error)
        {
            //allert the user that they have to allow access
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Access To Events"
                                                            message:@"Please give access in the settings app"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            NSLog(@"Access to calendars granted");
            //if the user chose to allow access
            // Get the appropriate calendar
            NSCalendar *calendar = [NSCalendar currentCalendar];
            
            // Create the start date components
            NSDateComponents *todayComponents = [[NSDateComponents alloc] init];
            todayComponents.day = 0;
            NSDate *today = [calendar dateByAddingComponents:todayComponents
                                                          toDate:[NSDate date]
                                                         options:0];
            
            // Create the end date components
            NSDateComponents *oneYearFromNowComponents = [[NSDateComponents alloc] init];
            oneYearFromNowComponents.year = 1;
            NSDate *oneYearFromNow = [calendar dateByAddingComponents:oneYearFromNowComponents
                                                               toDate:[NSDate date]
                                                              options:0];
            
            // Create the predicate from the event store's instance method
            NSPredicate *predicate = [store predicateForEventsWithStartDate:today
                                                                    endDate:oneYearFromNow
                                                                  calendars:nil];
            
            // Fetch all events that match the predicate
            NSArray *events = [store eventsMatchingPredicate:predicate];
            
            //loop over events
            for(EKEvent *eventItem in events)
            {
                NSString *title = eventItem.title;
                NSString *description = eventItem.description;
                NSString *combined = [NSString stringWithFormat:@"%@ %@", title, description];
                
                //if the event contains sports words add the event to the array
                if([combined containsString:@"game"] || [combined containsString:@"tournament"] || [combined containsString:@"match"] || [combined containsString:@"sport"] || [combined containsString:@"championship"])
                {
                    //check if the object title is taken
                    PFQuery *query = [PFQuery queryWithClassName:@"LocalEvent"];
                    [query fromLocalDatastore];
                    [query whereKey:@"title" equalTo:title];
                    
                    PFObject *firstObject = [query getFirstObject];
                    
                    if(firstObject == nil)
                    {
                        NSLog(@"No events with that title");
                        //save an event with that title
                        PFObject *event = [PFObject objectWithClassName:@"LocalEvent"];
                        event[@"title"] = title;
                        event[@"description"] = description;
                        event[@"date"] = eventItem.endDate;
                        [event pinInBackground];
                        
                        //schedule a notification for this event
                        NSTimeInterval secondsInOneHour = 60 * 60;
                        NSDate *notificationDate = [eventItem.endDate dateByAddingTimeInterval:secondsInOneHour];
                        
                        UILocalNotification* notification = [[UILocalNotification alloc] init];
                        notification.fireDate = notificationDate;
                        notification.alertTitle = title;
                        NSString *body = [NSString stringWithFormat:@"tweet about %@?", title];
                        notification.alertBody = body;
                        event[@"notificationDate"] = notificationDate;
                        [event pinInBackground];
                        
                        //schedule
                        //first, get the settings
                        PFQuery *settingsQuery = [PFQuery queryWithClassName:@"Settings"];
                        [settingsQuery fromLocalDatastore];
                        PFObject *settings = [settingsQuery getFirstObject];
                        NSString *eventTweetReminders = settings[@"eventTweetReminders"];
                        
                        if([eventTweetReminders isEqualToString:@"true"])
                        {
                            [[UIApplication sharedApplication] scheduleLocalNotification: notification];
                            NSLog(@"Scheduled notification");
                        }
                        else
                        {
                            NSLog(@"Tried to schedule, but notifications were disabled");
                        }
                    }
                }
            }
            
        }
    }];
}

//Parse table stuff
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        
    }
    return self;
}

- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:@"LocalEvent"];
    [query fromLocalDatastore];
    
    // If no objects are loaded in memory, we look to the cache
    // first to fill the table and then subsequently do a query
    // against the network.
    /*
     if ([self.objects count] == 0) {
     query.cachePolicy = kPFCachePolicyCacheThenNetwork;
     }
     */
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
    static NSString *CellIdentifier = @"rankCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = object[@"title"];
    
    //date
    NSDate *date = object[@"notificationDate"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"MM-dd HH:mm"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    cell.detailTextLabel.text = stringFromDate;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PFObject *event = [self.objects objectAtIndex:indexPath.row];
    NSString *text = event[@"title"];
    
    TWTRComposer *composer = [[TWTRComposer alloc] init];
    
    [composer setText:text];
    
    // Called from a UIViewController
    [composer showFromViewController:self completion:^(TWTRComposerResult result) {
        if (result == TWTRComposerResultCancelled) {
            NSLog(@"Tweet composition cancelled");
        }
        else
        {
            NSLog(@"Sending Tweet!");
            
            //this is where we add another tweet sent
            PFQuery *query = [PFQuery queryWithClassName:@"User"];
            [query whereKey:@"name" equalTo:self.username];
            
            //query
            PFObject *tweetCount = [query getFirstObject];
            
            //if there is an object for that player
            if(tweetCount != nil)
            {
                //get previous count and add one
                int newCount = [[tweetCount objectForKey:@"tweetCount"] intValue] + 1;
                NSLog(@"User tweets: %d", newCount);
                [tweetCount setObject:[NSNumber numberWithInt:newCount] forKey:@"tweetCount"];
                
                //save
                [tweetCount saveInBackground];
            }
            else
            {
                //create first count
                PFObject *tweetCount = [PFObject objectWithClassName:@"User"];
                [tweetCount setObject:[NSNumber numberWithInt:1] forKey:@"tweetCount"];
                tweetCount[@"name"] = self.username;
                tweetCount[@"rankMe"] = @"true";
                [tweetCount saveInBackground];
                NSLog(@"Created new user count object");
            }
            
        }
    }];
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
