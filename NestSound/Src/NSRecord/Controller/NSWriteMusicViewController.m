//
//  NSWriteMusicViewController.m
//  NestSound
//
//  Created by Apple on 16/5/30.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSWriteMusicViewController.h"

@interface NSWriteMusicViewController ()

@end

@implementation NSWriteMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick:)];
    
    
    
    
}

- (void)rightClick:(UIBarButtonItem *)right {
    
    NSLog(@"点击了下一步");
}

@end
