//
//  NSLyricModelViewController.m
//  NestSound
//
//  Created by yinchao on 16/8/11.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSLyricModelViewController.h"

@interface NSLyricModelViewController ()

@end

@implementation NSLyricModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLyricModelUI];
}
- (void)setupLyricModelUI {
    
    self.title = @"模版";
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
