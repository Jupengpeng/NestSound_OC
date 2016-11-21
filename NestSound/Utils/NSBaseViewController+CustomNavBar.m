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
#import "NSMessageViewController.h"
#import "NSSelectLyricsViewController.h"
#import "NSUserViewController.h"
#import "NSMusicSayDetailController.h"
#import "NSPreserveApplyController.h"
#include <sys/sysctl.h>
void swizzled_Method(Class class,SEL originalSelector,SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzeldMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didSwizzle = class_addMethod(class, originalSelector, method_getImplementation(swizzeldMethod), method_getTypeEncoding(swizzeldMethod));
    
    if (didSwizzle) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzeldMethod);
    }
}
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
    
    if ([self isKindOfClass:[NSPlayMusicViewController class]] ||[self isKindOfClass:[NSSelectLyricsViewController class]]) {
        self.navigationController.navigationBar.hidden = YES;
        self.edgesForExtendedLayout = UIRectEdgeTop;
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithRenderColor:[UIColor clearColor] renderSize:CGSizeMake(1, 0.5)] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage imageWithRenderColor:[UIColor clearColor] renderSize:CGSizeMake(1, 0.5) ]];
        
    }
    if ([self isKindOfClass:[NSUserPageViewController class]]) {
        //去除导航条变空后导航条留下的黑线
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.modalPresentationCapturesStatusBarAppearance = YES;
        self.edgesForExtendedLayout = UIRectEdgeTop;
        self.automaticallyAdjustsScrollViewInsets = NO;
//        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    }
    if ([self isKindOfClass:[NSLyricViewController class]]) {
        
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithRenderColor:[UIColor whiteColor] renderSize:CGSizeMake(1, 0.5)] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage imageWithRenderColor:[UIColor whiteColor] renderSize:CGSizeMake(1, 0.5)]];
    }
    
    if ([self isKindOfClass:[NSHomeViewController class]] || [self isKindOfClass:[NSDiscoverViewController class]] || [self isKindOfClass:[NSMessageViewController class]] || [self isKindOfClass:[NSUserViewController class]]) {
        
        self.navigationController.navigationBar.barTintColor = [UIColor hexColorFloat:@"ffd705"];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithRenderColor:[UIColor hexColorFloat:@"ffd705"] renderSize:CGSizeMake(1, 0.5)] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage imageWithRenderColor:[UIColor hexColorFloat:@"ffd705"] renderSize:CGSizeMake(1, 0.5)]];
    }
    
    
    if ([self isKindOfClass:[NSAccompanyListViewController class]] || [self isKindOfClass:[NSWriteMusicViewController class]] || [self isKindOfClass:[NSWriteLyricViewController class]] || [self isKindOfClass:[NSInspirationRecordViewController class]] || [self isKindOfClass:[NSH5ViewController class]]) {
        self.navigationController.navigationBar.hidden = NO;
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithRenderColor:[UIColor whiteColor] renderSize:CGSizeMake(1, 0.5)] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage imageWithRenderColor:[UIColor whiteColor] renderSize:CGSizeMake(1, 0.5)]];
    }
    if ([self isKindOfClass:[NSMusicSayDetailController class]]||
        [self isKindOfClass:[NSPreserveApplyController class]]) {
        self.navigationController.navigationBar.hidden = NO;
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage createImageWithColor:[UIColor hexColorFloat:@"dddfdf"]] ];
    }
    
}

#pragma mark - resetNavBar
- (void)reSetNavBar:(BOOL)animated {
    [self reSetNavBar:animated];
    
    if ([self isKindOfClass:[NSPlayMusicViewController class]]) {
        
        if (self.navigationController.childViewControllers.count <= 1) {
            self.navigationController.navigationBar.barTintColor = [UIColor hexColorFloat:@"ffd705"];
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithRenderColor:[UIColor hexColorFloat:@"ffd705"] renderSize:CGSizeMake(1, 0.5)] forBarMetrics:UIBarMetricsDefault];
            [self.navigationController.navigationBar setShadowImage:[UIImage imageWithRenderColor:[UIColor hexColorFloat:@"ffd705"] renderSize:CGSizeMake(1, 0.5)]];
        } else {
            self.navigationController.navigationBar.hidden = NO;
             self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithRenderColor:[UIColor whiteColor] renderSize:CGSizeMake(1, 0.5)] forBarMetrics:UIBarMetricsDefault];
            [self.navigationController.navigationBar setShadowImage:[UIImage imageWithRenderColor:[UIColor whiteColor] renderSize:CGSizeMake(1, 0.5)]];
        }
        
    }
}





@end









