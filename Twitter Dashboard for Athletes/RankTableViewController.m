//
//  RankTableViewController.m
//  
//
//  Created by Cole on 7/5/15.
//
//

#import "RankTableViewController.h"

@implementation RankTableViewController

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

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        
    }
    return self;
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    [query whereKey:@"rankMe" equalTo:@"true"];
    
    // If no objects are loaded in memory, we look to the cache
    // first to fill the table and then subsequently do a query
    // against the network.
    /*
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
     */
    
    [query orderByAscending:@"tweetCount"];
    
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
    
    // Configure the cell to show todo item with a priority at the bottom
    int number = indexPath.row + 1;
    NSString *label = [NSString stringWithFormat:@"%d. @%@", number, [object objectForKey:@"name"]];
    cell.textLabel.text = label;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PFObject *user = [self.objects objectAtIndex:indexPath.row];
    NSString *text = [NSString stringWithFormat:@"@%@", user[@"name"]];
    
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


@end
