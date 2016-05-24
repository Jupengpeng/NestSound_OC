//
//  NSWriteLyricViewController.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/11.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSWriteLyricViewController.h"
#import "NSLyricView.h"
@interface NSWriteLyricViewController ()<
    UITextFieldDelegate
>
{

    NSLyricView * lyricView;
    UITextField * titleTextFiled;
    UIButton * importLyricBtn;
    UIButton * LyricesBtn;
    UIButton * cocachBtn;
}

@end



@implementation NSWriteLyricViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self configureUIAppearance];
    
}

#pragma mark -configureUIAppearance
-(void)configureUIAppearance
{
    //nav
    self.showBackBtn = YES;
    
    //titleTextFiled
    titleTextFiled = [[UITextField alloc] init];
    titleTextFiled.textAlignment = NSTextAlignmentCenter;
    titleTextFiled.font = [UIFont systemFontOfSize:15];
    titleTextFiled.placeholder = LocalizedStr(@"promot_title");
    titleTextFiled.borderStyle = UITextBorderStyleNone;
    titleTextFiled.delegate = self;
    [self.view addSubview:titleTextFiled];
    
    //lyricView
    lyricView = [[NSLyricView alloc] init];
    [self.view addSubview:lyricView];
    
    importLyricBtn = [UIButton buttonWithType:UIButtonTypeCustom
                                    configure:^(UIButton *btn) {
                                    
                                }      action:^(UIButton *btn) {
                                    
                                }];
    
    LyricesBtn = [UIButton buttonWithType:UIButtonTypeCustom
                                configure:^(UIButton *btn) {
        
                                        }
                                   action:^(UIButton *btn) {
        
    }];
    
    cocachBtn = [UIButton buttonWithType:UIButtonTypeCustom
                               configure:^(UIButton *btn) {
        
                                   }
                                  action:^(UIButton *btn) {
        
                                      
    }];
    
    
    //constraints
    [titleTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(19);
        make.right.equalTo(self.view.mas_right).with.offset(-58);
        make.left.equalTo(self.view.mas_left).with.offset(58);
    }];
    
    [lyricView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleTextFiled.mas_bottom).with.offset(12);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(importLyricBtn.mas_top);
    }];
    
    [importLyricBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.height.mas_equalTo(52);
        make.width.mas_equalTo(ScreenWidth/3);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [LyricesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(importLyricBtn.mas_right);
        make.height.mas_equalTo(52);
        make.width.mas_equalTo(ScreenWidth/3);
    }];
    
    [cocachBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(LyricesBtn.mas_right);
        make.height.mas_equalTo(52);
        make.width.mas_equalTo(ScreenWidth/3);
        
    }];
    
   
}






@end
