//
//  NSBaseNavigationController.m
//  NestSound
//
//  Created by Apple on 16/5/18.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseNavigationController.h"
#import "NSPlayMusicViewController.h"

@interface NSBaseNavigationController ()

@end

@implementation NSBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    


}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.childViewControllers.count >= 1) {
        
        self.navigationBar.barTintColor = [UIColor whiteColor];
        
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"2.0_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick:)];
        
        viewController.hidesBottomBarWhenPushed = YES;
        
        
    }
    
    
    [super pushViewController:viewController animated:animated];
}
    
- (void)backClick:(UITabBarItem *)back {
    
    if (self.childViewControllers.count <= 2) {
        
        self.navigationBar.barTintColor = [UIColor hexColorFloat:@"ffd705"];
    }
    
    [self popViewControllerAnimated:YES];
}

@end
