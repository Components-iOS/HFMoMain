//
//  HFAppDelegate.m
//  HFMoMain
//
//  Created by liuhongfei on 04/14/2021.
//  Copyright (c) 2021 liuhongfei. All rights reserved.
//

#import "HFAppDelegate.h"
#import "HFViewController.h"

#import <HFRouter/MGJRouter.h>

@implementation HFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIViewController *rootVC = [MGJRouter objectForURL:@"xmg://getRootVC"];
    
    
    [MGJRouter openURL:@"xmg://addChildVC" withUserInfo:@{
                                                          @"vc": [HFViewController new],
                                                          @"title": @"首页",
                                                          @"nImg": @"tabbar_icon_home_normal",
                                                          @"sImg": @"tabbar_icon_home_selected",
                                                          @"isR": @(YES)
                                                          } completion:^(id result) {
                                                              NSLog(@"%@", result);
                                                          }];
    
    [MGJRouter openURL:@"xmg://addChildVC" withUserInfo:@{
                                                          @"vc": [UIViewController new],
                                                          @"title": @"直播",
                                                          @"nImg": @"tabbar_icon_live_normal",
                                                          @"sImg": @"tabbar_icon_live_selected",
                                                          @"isR": @(YES)
                                                          } completion:^(id result) {
                                                              NSLog(@"%@", result);
                                                          }];
    
    [MGJRouter openURL:@"xmg://addChildVC" withUserInfo:@{
                                                          @"vc": [UIViewController new],
                                                          @"title": @"发现",
                                                          @"nImg": @"tabbar_icon_findings_normal",
                                                          @"sImg": @"tabbar_icon_findings_selected",
                                                          @"isR": @(YES)
                                                          } completion:^(id result) {
                                                              NSLog(@"%@", result);
                                                          }];

    [MGJRouter openURL:@"xmg://addChildVC" withUserInfo:@{
                                                          @"vc": [UIViewController new],
                                                          @"title": @"我的",
                                                          @"nImg": @"tabbar_icon_mine_normal",
                                                          @"sImg": @"tabbar_icon_mine_selected",
                                                          @"isR": @(YES)
                                                          } completion:^(id result) {
                                                              NSLog(@"%@", result);
                                                          }];
    
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
    
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
