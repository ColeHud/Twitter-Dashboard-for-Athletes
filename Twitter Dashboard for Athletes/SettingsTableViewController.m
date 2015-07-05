//
//  SettingsTableViewController.m
//  
//
//  Created by Cole on 7/3/15.
//
//

#import "SettingsTableViewController.h"

@interface SettingsTableViewController ()
//feed
@property (strong, nonatomic) IBOutlet UISwitch *sentimentAnalysisSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *positiveTweetsSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *negativeTweetsSwitch;

//rank
@property (strong, nonatomic) IBOutlet UISwitch *rankMeSwitch;

//events
@property (strong, nonatomic) IBOutlet UISwitch *eventTweetRemindersSwitch;


@end

@implementation SettingsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //navbar color
    UIColor *yellow = [UIColor colorWithRed:238.0/255.0 green:215.0/255.0 blue:85.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = yellow;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//update back-end settings
-(void)updateSettings
{
    //boolean values
    BOOL sentimentAnalysis = self.sentimentAnalysisSwitch.isEnabled;
    BOOL positiveTweets = self.positiveTweetsSwitch.isEnabled;
    BOOL negativeTweets = self.negativeTweetsSwitch.isEnabled;
    BOOL rankMe = self.rankMeSwitch.isEnabled;
    BOOL eventTweetReminders = self.eventTweetRemindersSwitch.isEnabled;
    
    //Calendar search terms
    
    //notification frequency
}

//DATA
/*
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}
 */

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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