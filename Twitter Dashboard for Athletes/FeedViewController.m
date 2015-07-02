//
//  FeedViewController.m
//  
//
//  Created by Cole on 7/1/15.
//
//

#import "FeedViewController.h"

@interface FeedViewController ()
@property (strong, nonatomic) IBOutlet UITabBarItem *barButton;

@end

@implementation FeedViewController

- (void)viewDidLoad
{
    //deal with edge weirdness
    [self.navigationController.view setBackgroundColor:[UIColor whiteColor]];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        [self.navigationController.view setBackgroundColor:[UIColor whiteColor]];
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //get the user name
    PFQuery *query = [PFQuery queryWithClassName:@"UserName"];
    [query fromLocalDatastore];
    NSString *username = NULL;
    username = [query getFirstObject][@"name"];
    
    //construct the search query string
    NSString *searchTerm = [NSString stringWithFormat:@"to:%@", username];
    NSLog(@"%@", username);
    
    [[Twitter sharedInstance] logInGuestWithCompletion:^(TWTRGuestSession *guestSession, NSError *error) {
        if (guestSession) {
            TWTRAPIClient *APIClient = [[Twitter sharedInstance] APIClient];
            TWTRSearchTimelineDataSource *searchTimelineDataSource = [[TWTRSearchTimelineDataSource alloc] initWithSearchQuery:searchTerm APIClient:APIClient];
            
            self.dataSource = searchTimelineDataSource;
        } else {
            NSLog(@"error: %@", [error localizedDescription]);
        }
    }];
    
    //weirdness
    [self.navigationController.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
