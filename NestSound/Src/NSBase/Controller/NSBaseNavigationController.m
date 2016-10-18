//
//  NSBaseNavigationController.m
//  NestSound
//
//  Created by Apple on 16/5/18.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseNavigationController.h"
#import "NSPlayMusicViewController.h"
#import "NSUserPageViewController.h"

@interface NSBaseNavigationController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

{
    UIImageView * playStatus;
    BOOL _isSwitching;
}
@end

@implementation NSBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
}


#pragma -mark -stopPlayAnimation
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (animated) {
        if (_isSwitching == YES) {
            return;
        }
        _isSwitching = YES;
    }
        if (self.childViewControllers.count >= 1) {
        
        self.navigationBar.barTintColor = [UIColor whiteColor];
        
        [self.navigationBar setBackgroundImage:[UIImage imageWithRenderColor:[UIColor whiteColor] renderSize:CGSizeMake(1, 0.5)] forBarMetrics:UIBarMetricsDefault];
        
        [self.navigationBar setShadowImage:[UIImage imageWithRenderColor:[UIColor whiteColor] renderSize:CGSizeMake(1, 0.5)]];
        if ([viewController isKindOfClass:[NSUserPageViewController class]]) {
            viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"2.0_playSongs_pop"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick:)];
            [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        } else {
        [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
            viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"2.0_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick:)];
        }
        viewController.hidesBottomBarWhenPushed = YES;
        
    }
    
    [super pushViewController:viewController animated:animated];
    
}

#pragma mark - UINavigationControllerDelegate


- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    _isSwitching = NO; // 3. 还原状态
}

- (void)backClick:(UIBarButtonItem *)back {
    
    if (self.childViewControllers.count <= 2) {
        
        self.navigationBar.barTintColor = [UIColor hexColorFloat:@"ffd705"];
        
        [self.navigationBar setBackgroundImage:[UIImage imageWithRenderColor:[UIColor hexColorFloat:@"ffd705"] renderSize:CGSizeMake(1, 0.5)] forBarMetrics:UIBarMetricsDefault];
        
        [self.navigationBar setShadowImage:[UIImage imageWithRenderColor:[UIColor hexColorFloat:@"ffd705"] renderSize:CGSizeMake(1, 0.5)]];
        
    }
    
    [self popViewControllerAnimated:YES];
}



@end
