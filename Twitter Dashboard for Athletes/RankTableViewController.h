//
//  RankTableViewController.h
//  
//
//  Created by Cole on 7/5/15.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <Bolts/Bolts.h>
#import <ParseUI/ParseUI.h>
#import <TwitterKit/TwitterKit.h>
#import <Fabric/Fabric.h>

@interface RankTableViewController : PFQueryTableViewController
@property (strong, nonatomic) NSString *username;
@end
