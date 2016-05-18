//
//  AppDelegate+configureUIAppearance.m
//  NestSound
//
//  Created by yandi on 16/4/24.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSHomeViewController.h"
#import "NSRecordViewController.h"
#import "NSMessageViewController.h"
#import "NSUserPageViewController.h"
#import "NSDiscoverViewController.h"
#import "AppDelegate+configureUIAppearance.h"
#import "NSBaseTabBarViewController.h"


@implementation AppDelegate (configureUIAppearance)

- (void)setupUIAppearance {
    
    // window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyWindow];
    
    // statusBarStyle
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
#pragma clang diagnostic pop
    
    // tabBar Appearance
    [[UITabBar appearance] setShadowImage:[UIImage imageWithRenderColor:[UIColor clearColor] renderSize:CGSizeMake(1, 0.5)]];
    [[UITabBar appearance] setBackgroundImage:[UIImage imageWithRenderColor:[UIColor clearColor] renderSize:CGSizeMake(1, 0.5)]];
    
    // separatorColor
    [[UITableView appearance] setBackgroundColor:[UIColor whiteColor]];
    [[UITableView appearance] setSeparatorColor:[UIColor hexColorFloat:@"e6e6e6"]];
    
    // tabBar Colors
    UIColor *normalColor = [UIColor hexColorFloat:@"808080"];
    UIColor *selectColor = [UIColor hexColorFloat:@"429ce8"];
    
    // tabBarItem Appearance
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:normalColor} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:selectColor} forState:UIControlStateSelected];
    
    // navigationBar Appearance
    [[UINavigationBar appearance] setOpaque:YES];
//    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:18.],NSFontAttributeName,
                                                          [UIColor blackColor],NSForegroundColorAttributeName,nil]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithRenderColor:[UIColor hexColorFloat:@"ffffff"]
                                                                        renderSize:CGSizeMake(1,1)]
                                       forBarMetrics:UIBarMetricsDefault];
    
    /*
     [[UINavigationBar appearance] setShadowImage:[UIImage imageWithRenderColor:[UIColor hexColorFloat:@"429ce8"]
     renderSize:CGSizeMake(1, 1)]];
     */
        
    NSBaseTabBarViewController *tabController = [[NSBaseTabBarViewController alloc] init];
    
    self.window.rootViewController = tabController;
    
    [self.window makeKeyAndVisible];
}

@end
