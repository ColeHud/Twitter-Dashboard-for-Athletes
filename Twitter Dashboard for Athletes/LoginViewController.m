//
//  LoginViewController.m
//  
//
//  Created by Cole on 7/1/15.
//
//

#import "LoginViewController.h"
#import <TwitterKit/TwitterKit.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //login button
    TWTRLogInButton *loginButton = [TWTRLogInButton buttonWithLogInCompletion:^(TWTRSession *session, NSError *error) {
        // play with Twitter session
        NSLog(@"Name: %@", session.userName);
        
        //segue to the main app
        [self performSegueWithIdentifier:@"login" sender:self];
    }];
    
    //place the button
    loginButton.center = self.view.center;
    [self.view addSubview:loginButton];
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
