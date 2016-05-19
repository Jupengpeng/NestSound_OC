//
//  AppDelegate.m
//  NestSound
//
//  Created by yandi on 4/16/16.
//  Copyright © 2016 yinchao. All rights reserved.
//


#import <WXApi.h>
#import "MobClick.h"
#import "AppDelegate.h"
#import "AppDelegate+configureUIAppearance.h"
#import "NSLyricViewController.h"
#import "NSHomeViewController.h"
#import "NSDiscoverViewController.h"
#import "NSInspirationRecordViewController.h"
#import "NSUserPageViewController.h"
#import "NSUserProfileViewController.h"
#import "NSUserViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Override point for customization after application launch.
//    [self setupUIAppearance];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
//    NSHomeViewController *vc = [[NSHomeViewController alloc] init];
//    NSLyricViewController *vc = [[NSLyricViewController alloc] init];
//    NSDiscoverViewController *vc = [[NSDiscoverViewController alloc] init];
//    NSInspirationRecordViewController *vc = [[NSInspirationRecordViewController alloc] init];
//    NSUserPageViewController *vc = [[NSUserPageViewController alloc] init];
//    NSUserProfileViewController  *vc = [[NSUserProfileViewController alloc] init];
    NSUserViewController  *vc = [[NSUserViewController alloc] init];
  //  vc.who = Myself;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];

    
    [self setupUIAppearance];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
