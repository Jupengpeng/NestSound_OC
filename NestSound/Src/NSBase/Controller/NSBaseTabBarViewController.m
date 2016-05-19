//
//  NSBaseTabBarViewController.m
//  NestSound
//
//  Created by Apple on 16/5/18.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseTabBarViewController.h"
#import "NSHomeViewController.h"
#import "NSMessageViewController.h"
#import "NSDiscoverViewController.h"
#import "NSRecordViewController.h"
#import "NSUserPageViewController.h"
#import "NSPlusTabBar.h"

@interface NSBaseTabBarViewController () <NSPlusTabBarDelegate>

@end

@implementation NSBaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupUI];
    
}


- (void)setupUI {
    
    NSPlusTabBar *tabBar = [[NSPlusTabBar alloc] init];
    
    tabBar.delegate = self;
    
    [self setValue:tabBar forKeyPath:@"tabBar"];
    
    
    NSHomeViewController *homeVc = [[NSHomeViewController alloc] init];
    
    [self addChildViewController:homeVc imageName:@"2.0_home_normal" selectedImageName:@"2.0_home_selected" title:@"首页"];
    
    NSDiscoverViewController *recommendVc = [[NSDiscoverViewController alloc] init];
    
    [self addChildViewController:recommendVc imageName:@"2.0_discovery_normal" selectedImageName:@"2.0_discovery_selected" title:@"发现"];
    
    NSMessageViewController *messageVc = [[NSMessageViewController alloc] init];
    
    [self addChildViewController:messageVc imageName:@"2.0_inspiration_normal" selectedImageName:@"2.0_inspiration_selected" title:@"消息"];
    
    NSUserPageViewController *userPageVc = [[NSUserPageViewController alloc] init];
    
    [self addChildViewController:userPageVc imageName:@"2.0_my_normal" selectedImageName:@"2.0_my_selected" title:@"我的"];
    
}

- (void)plusTabBar:(NSPlusTabBar *)tabBar didSelectedPlusBtn:(UIButton *)plusBtn {
    
    plusBtn.selected = !plusBtn.selected;
    
    NSLog(@"点击了加号");
}

- (void)addChildViewController:(UIViewController *)childCtrl imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName title:(NSString *)title{
 
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    
    UIImage *unSelectedImage = [UIImage imageNamed:imageName];
    
    childCtrl.title = title;
    
    childCtrl.tabBarItem = [[UITabBarItem alloc] initWithTitle:LocalizedStr(@"")
                                                      image:[unSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                              selectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    childCtrl.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childCtrl];
    
    [self addChildViewController:nav];
}



@end





