//
//  NotificationFrequencyDetailViewController.m
//  
//
//  Created by Cole on 7/3/15.
//
//

#import "NotificationFrequencyDetailViewController.h"

@interface NotificationFrequencyDetailViewController ()
@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UILabel *frequencyLabel;

@end

@implementation NotificationFrequencyDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//slid slider
- (IBAction)slidSlider:(UISlider *)sender
{
    int frequency = sender.value;
    NSString *labelText = [NSString stringWithFormat:@"%d time(s) a week", frequency];
    self.frequencyLabel.text = labelText;
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
