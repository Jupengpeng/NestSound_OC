//
//  NSBaseViewController+CustomNavBar.m
//  NestSound
//
//  Created by Apple on 16/5/14.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSUserPageViewController.h"
#import "NSBaseViewController+CustomNavBar.h"
#import "NSPlayMusicViewController.h"
#import "NSH5ViewController.h"
#import "NSLyricViewController.h"
#import "NSHomeViewController.h"
#import "NSDiscoverViewController.h"
#import "NSWriteMusicViewController.h"
#import "NSWriteLyricViewController.h"
#import "NSInspirationRecordViewController.h"
#import "NSAccompanyListViewController.h"

@implementation NSBaseViewController (CustomNavBar)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzled_Method([self class],@selector(viewWillAppear:),@selector(setNavBar:));
        swizzled_Method([self class],@selector(viewWillDisappear:), @selector(reSetNavBar:));
    });
}

#pragma mark - setNavBar
- (void)setNavBar:(BOOL)animated {
    [self setNavBar:animated];
    
    if ([self isKindOfClass:[NSPlayMusicViewController class]]) {
        self.navigationController.navigationBar.hidden = YES;
        self.edgesForExtendedLayout = UIRectEdgeTop;
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithRenderColor:[UIColor clearColor] renderSize:CGSizeMake(1, 0.5)] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage imageWithRenderColor:[UIColor clearColor] renderSize:CGSizeMake(1, 0.5) ]];
        
    }
    
    if ([self isKindOfClass:[NSLyricViewController class]]) {
        
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithRenderColor:[UIColor whiteColor] renderSize:CGSizeMake(1, 0.5)] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage imageWithRenderColor:[UIColor whiteColor] renderSize:CGSizeMake(1, 0.5)]];
    }
    
    if ([self isKindOfClass:[NSHomeViewController class]] || [self isKindOfClass:[NSDiscoverViewController class]]) {
        
        self.navigationController.navigationBar.barTintColor = [UIColor hexColorFloat:@"ffd705"];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithRenderColor:[UIColor hexColorFloat:@"ffd705"] renderSize:CGSizeMake(1, 0.5)] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage imageWithRenderColor:[UIColor hexColorFloat:@"ffd705"] renderSize:CGSizeMake(1, 0.5)]];
    }
    
    
    if ([self isKindOfClass:[NSAccompanyListViewController class]] || [self isKindOfClass:[NSWriteMusicViewController class]] || [self isKindOfClass:[NSWriteLyricViewController class]] || [self isKindOfClass:[NSInspirationRecordViewController class]] || [self isKindOfClass:[NSH5ViewController class]]) {
        
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithRenderColor:[UIColor whiteColor] renderSize:CGSizeMake(1, 0.5)] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage imageWithRenderColor:[UIColor whiteColor] renderSize:CGSizeMake(1, 0.5)]];
    }
        
}

#pragma mark - resetNavBar
- (void)reSetNavBar:(BOOL)animated {
    [self reSetNavBar:animated];
    self.navigationController.navigationBar.hidden = NO;
    if ([self isKindOfClass:[NSPlayMusicViewController class]]) {
        if (self.navigationController.childViewControllers.count <= 1) {
            self.navigationController.navigationBar.barTintColor = [UIColor hexColorFloat:@"ffd705"];
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithRenderColor:[UIColor hexColorFloat:@"ffd705"] renderSize:CGSizeMake(1, 0.5)] forBarMetrics:UIBarMetricsDefault];
            [self.navigationController.navigationBar setShadowImage:[UIImage imageWithRenderColor:[UIColor hexColorFloat:@"ffd705"] renderSize:CGSizeMake(1, 0.5)]];
        } else {
             self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithRenderColor:[UIColor whiteColor] renderSize:CGSizeMake(1, 0.5)] forBarMetrics:UIBarMetricsDefault];
            [self.navigationController.navigationBar setShadowImage:[UIImage imageWithRenderColor:[UIColor whiteColor] renderSize:CGSizeMake(1, 0.5)]];
        }
        
    }
}





@end









