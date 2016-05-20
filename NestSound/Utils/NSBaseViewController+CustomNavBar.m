//
//  NSBaseViewController+CustomNavBar.m
//  NestSound
//
//  Created by Apple on 16/5/14.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSUserPageViewController.h"
#import "NSBaseViewController+CustomNavBar.h"

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
    
//    if ([self isKindOfClass:[NSUserPageViewController class]]) {
//        
//        self.edgesForExtendedLayout = UIRectEdgeTop;
//        self.automaticallyAdjustsScrollViewInsets = NO;
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithRenderColor:[UIColor clearColor] renderSize:CGSizeMake(1, 0.5)] forBarMetrics:UIBarMetricsDefault];
//        [self.navigationController.navigationBar setShadowImage:[UIImage imageWithRenderColor:[UIColor clearColor] renderSize:CGSizeMake(1, 0.5) ]];
//    }
}

#pragma mark - resetNavBar
- (void)reSetNavBar:(BOOL)animated {
    [self reSetNavBar:animated];
    
//    if ([self isKindOfClass:[NSUserPageViewController class]]) {
//        
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithRenderColor:[UIColor whiteColor] renderSize:CGSizeMake(1, 0.5)] forBarMetrics:UIBarMetricsDefault];
//        [self.navigationController.navigationBar setShadowImage:[UIImage imageWithRenderColor:[UIColor whiteColor] renderSize:CGSizeMake(1, 0.5)]];
//        
//    }
}






@end









