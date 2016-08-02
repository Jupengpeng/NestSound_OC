//
//  NSModifyPwdViewController.m
//  NestSound
//
//  Created by 李龙飞 on 16/8/2.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSModifyPwdViewController.h"

@interface NSModifyPwdViewController ()

@end

@implementation NSModifyPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUIAppearance];
}
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if (requestErr) {
        
    } else {
        if (!parserObject.success) {
//            if ([operation.urlTag isEqualToString:url]) {
//            }
        }
    }
}
- (void)configureUIAppearance {
    self.title = @"修改密码";
    
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
