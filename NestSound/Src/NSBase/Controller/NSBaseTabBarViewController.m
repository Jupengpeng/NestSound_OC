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

@interface NSBaseTabBarViewController () <NSPlusTabBarDelegate, NSComposeViewDelegate>

@property (nonatomic, strong)  NSPlayMusicViewController *playSongsVC;

@end

@implementation NSBaseTabBarViewController

- (NSPlayMusicViewController *)playSongsVC {
    
    if (!_playSongsVC) {
        
        _playSongsVC = [[NSPlayMusicViewController alloc] init];
        
    }
    
    return _playSongsVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupUI];
    
}


- (void)setupUI {
    
    NSPlusTabBar *tabBar = [[NSPlusTabBar alloc] init];
    
    tabBar.delegate = self;
    
    [self setValue:tabBar forKeyPath:@"tabBar"];
    
    //首页
    NSHomeViewController *homeVc = [[NSHomeViewController alloc] init];
    
    [self addChildViewController:homeVc imageName:@"2.0_home_normal" selectedImageName:@"2.0_home_selected" title:@"音巢音乐"];
    
    homeVc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"2.0_musicNote"] style:UIBarButtonItemStylePlain target:self action:@selector(musicPaly:)];
    
    
    //发现
    NSDiscoverViewController *recommendVc = [[NSDiscoverViewController alloc] init];
    
    [self addChildViewController:recommendVc imageName:@"2.0_discovery_normal" selectedImageName:@"2.0_discovery_selected" title:nil];
    
     recommendVc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"2.0_musicNote"] style:UIBarButtonItemStylePlain target:self action:@selector(musicPaly:)];
    
    
    //消息
    NSMessageViewController *messageVc = [[NSMessageViewController alloc] init];
    
    [self addChildViewController:messageVc imageName:@"2.0_inspiration_normal" selectedImageName:@"2.0_inspiration_selected" title:@"消息"];
    
    
    //我的
    NSUserPageViewController *userPageVc = [[NSUserPageViewController alloc] init];
    
    [self addChildViewController:userPageVc imageName:@"2.0_my_normal" selectedImageName:@"2.0_my_selected" title:@"我的"];
    
    
    
}


- (void)addChildViewController:(UIViewController *)childCtrl imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName title:(NSString *)title{
    
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    
    UIImage *unSelectedImage = [UIImage imageNamed:imageName];
    
    childCtrl.title = title;
    
    childCtrl.tabBarItem = [[UITabBarItem alloc] initWithTitle:LocalizedStr(@"")
                                                      image:[unSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                              selectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    childCtrl.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    NSBaseNavigationController *nav = [[NSBaseNavigationController alloc] initWithRootViewController:childCtrl];
    
    nav.navigationBar.barTintColor = [UIColor hexColorFloat:@"ffd705"];
    
    [self addChildViewController:nav];
}


- (void)plusTabBar:(NSPlusTabBar *)tabBar didSelectedPlusBtn:(UIButton *)plusBtn {
    
    NSComposeView *composeView = [[NSComposeView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    composeView.delegate = self;
    
    [[UIApplication sharedApplication].keyWindow addSubview:composeView];
    
    [composeView startAnimation];
    
    NSLog(@"点击了加号");
}

- (void)composeView:(NSComposeView *)composeView withComposeButton:(UIButton *)composeBtn {
    

     [composeView removeFromSuperview];
    if (composeBtn.tag == 0) {
        NSWriteLyricViewController * writeLyricVC = [[NSWriteLyricViewController alloc] init];
       [[self.childViewControllers objectAtIndex:self.selectedIndex] pushViewController:writeLyricVC animated:YES];
        NSLog(@"点击了创作歌词");

    } else if (composeBtn.tag == 1) {
        
        NSLog(@"点击了创作歌曲");
    } else {

        
        NSInspirationRecordViewController *inspirationRecord = [[NSInspirationRecordViewController alloc] init];
        
        [[self.childViewControllers objectAtIndex:self.selectedIndex] pushViewController:inspirationRecord animated:YES];
       
        NSLog(@"点击了创作灵感记录");
    }
    
}

- (void)musicPaly:(UIBarButtonItem *)palyItem {
    
    
    [self.playSongsVC showPlayMusic];
}


@end





