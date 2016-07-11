//
//  AppDelegate+configureUIAppearance.m
//  NestSound
//
//  Created by yandi on 16/4/24.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSHomeViewController.h"
#import "NSMessageViewController.h"
#import "NSUserPageViewController.h"
#import "NSDiscoverViewController.h"
#import "AppDelegate+configureUIAppearance.h"
#import "NSBaseTabBarViewController.h"


@implementation AppDelegate (configureUIAppearance)

- (void)setupUIAppearance {


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
    //    [[UINavigationBar appearance] setTranslucent:YES];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:18.],NSFontAttributeName,
                                                          [UIColor blackColor],NSForegroundColorAttributeName,nil]];
   
}

@end
