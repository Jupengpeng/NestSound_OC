//
//  NSRecordViewController.m
//  NestSound
//
//  Created by yandi on 16/4/24.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSRecordViewController.h"
#import "NSLyricView.h"
#import "NSRecordToolView.h"
@interface NSRecordViewController ()
{
    UITextField * titleTextFiled;
    NSLyricView * lyricView;
    NSRecordToolView * recordToolView;
}
@end

@implementation NSRecordViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self configureUIAppearance];
}


#pragma mark -
-(void)configureUIAppearance
{
    //nav
    
    //titleTextFiled
    titleTextFiled = [[UITextField alloc] init];
    titleTextFiled.font = [UIFont systemFontOfSize:18];
    titleTextFiled.textColor = [UIColor hexColorFloat:@"181818"];
    titleTextFiled.textAlignment = NSTextAlignmentCenter;
    titleTextFiled.borderStyle = UITextBorderStyleNone;
    [self.view addSubview:titleTextFiled];
    
    //lyricView
    lyricView = [[NSLyricView alloc] init];
    [self.view addSubview:lyricView];
    
    recordToolView = [[NSRecordToolView alloc] init];
    [self.view addSubview:recordToolView];
    
    
    //constraints
    [titleTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(15);
        make.right.equalTo(self.view.mas_right).with.offset(-15);
        make.top.equalTo(self.view.mas_top).with.offset(16);
    }];
    
    [recordToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [lyricView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleTextFiled.mas_bottom).with.offset(20);
        make.left.equalTo(self.view.mas_left).with.offset(15);
        make.right.equalTo(self.view.mas_right).with.offset(15);
    }];
    
    

}
@end
