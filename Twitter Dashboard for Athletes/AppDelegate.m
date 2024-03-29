//
//  AppDelegate.m
//  Twitter Dashboard for Athletes
//
//  Created by Cole on 7/1/15.
//  Copyright (c) 2015 Cole Hudson. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //fabric and crashylitics
    [Fabric with:@[TwitterKit, CrashlyticsKit]];
    
    //parse local datastore
    [Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@"UCo8g81v8B6XvGpwYV0sNBuPVX5u740nPDphMR4U"
                  clientKey:@"sdshQEd0q97lIcp715mrKjnZlLGAVHjnC36ZtzYi"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    //notification permission
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    //create settings
    PFQuery *settingsQuery = [PFQuery queryWithClassName:@"Settings"];
    [settingsQuery fromLocalDatastore];
    PFObject *settings = [settingsQuery getFirstObject];
    if(settings == nil)
    {
        //create standard settings
        PFObject *newSettings = [PFObject objectWithClassName:@"Settings"];
        newSettings[@"sentimentAnalysis"] = @"false";
        newSettings[@"positiveTweets"] = @"true";
        newSettings[@"negativeTweets"] = @"true";
        newSettings[@"eventReminders"] = @"true";
        [newSettings pinInBackground];
    }
    
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
