//
//  AppDelegate+configureUIAppearance.m
//  NestSound
//
//  Created by yandi on 16/4/24.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSHomeViewController.h"
#import "NSUserViewController.h"
#import "NSRecordViewController.h"
#import "NSUserPageViewController.h"
#import "NSDiscoverViewController.h"
#import "AppDelegate+configureUIAppearance.h"


@implementation AppDelegate (configureUIAppearance)

- (void)setupUIAppearance {
    
    // window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyWindow];
    
    // statusBarStyle
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
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
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:18.],NSFontAttributeName,
                                                          [UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithRenderColor:[UIColor hexColorFloat:@"429ce8"]
                                                                        renderSize:CGSizeMake(1,1)]
                                       forBarMetrics:UIBarMetricsDefault];
    /*
     [[UINavigationBar appearance] setShadowImage:[UIImage imageWithRenderColor:[UIColor hexColorFloat:@"429ce8"]
     renderSize:CGSizeMake(1, 1)]];
     */
    
    UIImage *selectedImage = [UIImage imageNamed:@"tab_rank_hlt"];
    UIImage *unSelectedImage = [UIImage imageNamed:@"tab_rank_nrl"];
    // homeVc
    NSHomeViewController *homeVc = [[NSHomeViewController alloc] init];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeVc];
    homeVc.tabBarItem = [[UITabBarItem alloc] initWithTitle:LocalizedStr(@"")
                                                      image:[unSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                              selectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    selectedImage = [UIImage imageNamed:@""];
    unSelectedImage = [UIImage imageNamed:@""];
    // recommendVc
    NSDiscoverViewController *recommendVc = [[NSDiscoverViewController alloc] init];
    UINavigationController *recommendNav = [[UINavigationController alloc] initWithRootViewController:recommendVc];
    recommendVc.tabBarItem = [[UITabBarItem alloc] initWithTitle:LocalizedStr(@"")
                                                           image:[unSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                   selectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    selectedImage = [UIImage imageNamed:@""];
    unSelectedImage = [UIImage imageNamed:@""];
    // recordVc
    NSRecordViewController *recordVc = [[NSRecordViewController alloc] init];
    UINavigationController *recordNav = [[UINavigationController alloc] initWithRootViewController:recordVc];
    recordVc.tabBarItem = [[UITabBarItem alloc] initWithTitle:LocalizedStr(@"")
                                                        image:[unSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                selectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    selectedImage = [UIImage imageNamed:@""];
    unSelectedImage = [UIImage imageNamed:@""];
    // userPageVc
    NSUserPageViewController *userPageVc = [[NSUserPageViewController alloc] init];
    UINavigationController *userPageNav = [[UINavigationController alloc] initWithRootViewController:userPageVc];
    userPageVc.tabBarItem = [[UITabBarItem alloc] initWithTitle:LocalizedStr(@"")
                                                          image:[unSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                  selectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    selectedImage = [UIImage imageNamed:@""];
    unSelectedImage = [UIImage imageNamed:@""];
    //userVc
    NSUserViewController *userVc = [[NSUserViewController alloc] init];
    UINavigationController *userNav = [[UINavigationController alloc] initWithRootViewController:userVc];
    userVc.tabBarItem = [[UITabBarItem alloc] initWithTitle:LocalizedStr(@"")
                                                      image:[unSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                              selectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    // root
    UITabBarController *tabController = [[UITabBarController alloc] init];
    tabController.tabBar.backgroundImage = [UIImage imageWithRenderColor:[UIColor hexColorFloat:@"f1f4f5"] renderSize:CGSizeMake(1, 1)];
    tabController.viewControllers = @[homeNav,recommendNav,recordNav,userPageNav,userNav];
    self.window.rootViewController = tabController;
    
   
}

@end
