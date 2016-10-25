//
//  NSPublicLyricCooperationViewController.m
//  NestSound
//
//  Created by yinchao on 16/10/25.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSPublicLyricCooperationViewController.h"

@interface NSPublicLyricCooperationViewController ()

@end

@implementation NSPublicLyricCooperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupPublicLyricCooperationView];
}
- (void)setupPublicLyricCooperationView {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(publicClick)];
}
- (void)publicClick {
    
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
