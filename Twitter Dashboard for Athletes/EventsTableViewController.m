//
//  EventsTableViewController.m
//  
//
//  Created by Cole on 7/5/15.
//
//

#import "EventsTableViewController.h"

@interface EventsTableViewController ()

-(void)updateEvents;
@property (strong, nonatomic) NSMutableArray *events;

@end

@implementation EventsTableViewController

- (void)viewDidLoad
{
    [self updateEvents];
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
    //update the events and then set the number of rows to events.count
    [self updateEvents];
    NSLog(@"%d", self.events.count);
    return self.events.count;
}

- (IBAction)update:(UIBarButtonItem *)sender
{
    //update events
    NSLog(@"Update events");
    [self updateEvents];
}

//update events
-(void)updateEvents
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
            NSDateComponents *oneDayAgoComponents = [[NSDateComponents alloc] init];
            oneDayAgoComponents.day = 0;
            NSDate *oneDayAgo = [calendar dateByAddingComponents:oneDayAgoComponents
                                                          toDate:[NSDate date]
                                                         options:0];
            
            // Create the end date components
            NSDateComponents *oneYearFromNowComponents = [[NSDateComponents alloc] init];
            oneYearFromNowComponents.year = 1;
            NSDate *oneYearFromNow = [calendar dateByAddingComponents:oneYearFromNowComponents
                                                               toDate:[NSDate date]
                                                              options:0];
            
            // Create the predicate from the event store's instance method
            NSPredicate *predicate = [store predicateForEventsWithStartDate:oneDayAgo
                                                                    endDate:oneYearFromNow
                                                                  calendars:nil];
            
            // Fetch all events that match the predicate
            NSArray *events = [store eventsMatchingPredicate:predicate];
            
            //loop over events
            NSMutableArray *calendarItems = [[NSMutableArray alloc] init];
            for(EKCalendarItem *eventItem in events)
            {
                NSString *title = eventItem.title;
                NSString *description = eventItem.description;
                NSString *combined = [NSString stringWithFormat:@"%@ %@", title, description];
                
                //if the event contains sports words add the event to the array
                [calendarItems addObject:eventItem];
                /*
                if([combined containsString:@"game"] || [combined containsString:@"tournament"] || [combined containsString:@"match"] || [combined containsString:@"sport"])
                {
                    [calendarItems addObject:eventItem];
                }
                 */
            }
            
            self.events = calendarItems;
            [self.tableView reloadData];
        }
    }];
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"prototype" forIndexPath:indexPath];
    
    EKCalendarItem *item = [self.events objectAtIndex:indexPath.row];
    NSString *title = item.title;
    cell.textLabel.text = title;
    
    return cell;
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
