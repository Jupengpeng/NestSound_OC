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
#import "NSUserPageViewController.h"
#import "NSPlusTabBar.h"
#import "NSBaseNavigationController.h"
#import "NSComposeView.h"
#import "NSInspirationRecordViewController.h"
#import "NSWriteLyricViewController.h"
#import "NSBaseViewController.h"
#import "NSPlayMusicViewController.h"
#import "NSAccompanyListViewController.h"
#import "NSWriteMusicViewController.h"
#import "NSLoginViewController.h"
#import "NSUserViewController.h"
@interface NSBaseTabBarViewController () <NSPlusTabBarDelegate, NSComposeViewDelegate>
{
    UIView *redDotView;
}
@end

@implementation NSBaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenTabBarTipView:) name:kHiddenTabBarTipViewNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)hiddenTabBarTipView:(NSNotification *)noti {
    if ([noti.object intValue]) {
        redDotView.hidden = YES;
    } else {
        redDotView.hidden = NO;
    }
    
}
- (void)setupUI {
    
    NSPlusTabBar *tabBar = [[NSPlusTabBar alloc] init];
    
    tabBar.delegate = self;
    
    [self setValue:tabBar forKeyPath:@"tabBar"];
    
    //首页
    NSHomeViewController *homeVc = [[NSHomeViewController alloc] init];
    
    [self addChildViewController:homeVc imageName:@"2.0_home_normal" selectedImageName:@"2.0_home_selected" title:@"首页"];
    
    
    
    //发现
    NSDiscoverViewController *recommendVc = [[NSDiscoverViewController alloc] init];
    
    [self addChildViewController:recommendVc imageName:@"2.0_discovery_normal" selectedImageName:@"2.0_discovery_selected" title:@"发现"];;
    
    
    //消息
    NSMessageViewController *messageVc = [[NSMessageViewController alloc] init];
    
    [self addChildViewController:messageVc imageName:@"2.0_inspiration_normal" selectedImageName:@"2.0_inspiration_selected" title:@"消息"];
    
    
    //我的
    NSUserViewController *userVc = [[NSUserViewController alloc] init];
//    NSUserPageViewController *userPageVc = [[NSUserPageViewController alloc] init];
//    userPageVc.who = Myself;
    [self addChildViewController:userVc imageName:@"2.0_my_normal" selectedImageName:@"2.0_my_selected" title:@"我的"];
    
    redDotView = [[UIView alloc] init];
    redDotView.backgroundColor = [UIColor redColor];
    redDotView.layer.cornerRadius = 4;
    redDotView.hidden = YES;
    CGRect tabFrame = self.tabBar.frame;
    CGFloat x = ceilf(0.72 * tabFrame.size.width);
    CGFloat y = ceilf(0.12 * tabFrame.size.height);
    redDotView.frame = CGRectMake(x, y, 8, 8);
    [self.tabBar addSubview:redDotView];
}


- (void)addChildViewController:(UIViewController *)childCtrl imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName title:(NSString *)title{
    
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    
    UIImage *unSelectedImage = [UIImage imageNamed:imageName];
    
    childCtrl.title = title;
    
    childCtrl.tabBarItem = [[UITabBarItem alloc] initWithTitle:title
                                                      image:[unSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                              selectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [childCtrl.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor hexColorFloat:@"ffd00b"]} forState:UIControlStateSelected];
    childCtrl.tabBarItem.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
//    childCtrl.tabBarItem.badgeValue
     
    NSBaseNavigationController *nav = [[NSBaseNavigationController alloc] initWithRootViewController:childCtrl];
    
    nav.navigationBar.barTintColor = [UIColor hexColorFloat:@"ffd705"];
    
    [self addChildViewController:nav];
}


- (void)plusTabBar:(NSPlusTabBar *)tabBar didSelectedPlusBtn:(UIButton *)plusBtn {
    
    NSComposeView *composeView = [[NSComposeView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    composeView.delegate = self;
    
    [[UIApplication sharedApplication].keyWindow addSubview:composeView];
    
    [composeView startAnimation];
    

}

- (void)composeView:(NSComposeView *)composeView withComposeButton:(UIButton *)composeBtn {
    
     [composeView removeFromSuperview];
    NSLoginViewController *loginVC = [[NSLoginViewController alloc] init];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    
    if (composeBtn.tag == 0) {
        
        if (JUserID) {
        
            NSWriteLyricViewController * writeLyricVC = [[NSWriteLyricViewController alloc] init];
            [[self.childViewControllers objectAtIndex:self.selectedIndex] pushViewController:writeLyricVC animated:YES];

        } else {
            
           
            [self presentViewController:nav animated:YES completion:nil];
        }
        

    } else if (composeBtn.tag == 1) {
        
        if (JUserID) {
        
            NSAccompanyListViewController *accompanyList = [[NSAccompanyListViewController alloc] init];
            [[self.childViewControllers objectAtIndex:self.selectedIndex] pushViewController:accompanyList animated:YES];

        } else {
            
            [self presentViewController:nav animated:YES completion:nil];
        }
        
    } else {
        
        if (JUserID) {
            
            NSInspirationRecordViewController *inspirationRecord = [[NSInspirationRecordViewController alloc] initWithItemId:0 andType:YES];
            
            [[self.childViewControllers objectAtIndex:self.selectedIndex] pushViewController:inspirationRecord animated:YES];
            

        } else {
            
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end





