//
//  NSRhymeViewController.m
//  NestSound
//
//  Created by yinchao on 16/8/11.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSRhymeViewController.h"

@interface NSRhymeViewController ()

@end

@implementation NSRhymeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupRhymeViewUI];
    
}
- (void)setupRhymeViewUI {
    
    self.title = @"韵脚";
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
