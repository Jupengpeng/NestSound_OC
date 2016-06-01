//
//  NSRegisterViewController.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/30.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSRegisterViewController.h"
#import "UIScrollView+NSKeyboardAutoAdapt.h"
#import "NSDrawGrayLine.h"
#define textPlaceholderColor [UIColor colorWithRed:193 / 255.0 green:193 / 255.0 blue:193 / 255.0 alpha:1]

@interface NSRegisterViewController ()
<
    UIScrollViewDelegate,UITextFieldDelegate
>
{

    UIScrollView * scroll;
    UIImageView *  iconImageView;
    UIImageView * userImage;
    UITextField * nickName;
    UIImageView * mobileImage;
    UITextField * mobole;
    UIImageView * checkCodeImage;
    UITextField * chekcCode;
    UIImageView * passWordImage;
    UITextField * passWord;
    UIImageView * rePassWord;
    UITextField * rePassWordText;
    UIButton * sendCheckCodeBtn;
    UIButton * protocelBtn;
    UIButton * registBtn;
    UIButton * loginBtn;
    
}


@end

@implementation NSRegisterViewController

-(void)viewDidLoad
{
    [self configureUIAppearance];
}

#pragma mark -configureUIAppearance
-(void)configureUIAppearance
{
    //scroll;
    scroll = [[UIScrollView alloc] init];
    scroll.delegate = self;
    scroll.autoAdaptKeyboard = YES;
    [self.view addSubview:scroll];
    
//  iconImageView;
    iconImageView = [[UIImageView alloc] init];
    [scroll addSubview:iconImageView];
    
    //userImage;
    userImage = [[UIImageView alloc] init];
    [scroll addSubview:userImage];
    
    //nickName;
    nickName = [[UITextField alloc] init];
    nickName.font = [UIFont systemFontOfSize:15];
    [nickName setValue:textPlaceholderColor forKey:@"_placeholderLabel.textColor"];
    nickName.delegate = self;
    [scroll addSubview:nickName];
    
    NSDrawGrayLine * line1 = [[NSDrawGrayLine alloc] init];
    [scroll addSubview:line1];
    
//   mobileImage;
    mobileImage = [[UIImageView alloc] init];
    [scroll addSubview:mobileImage];
    
//    mobole;
    mobole = [[UITextField alloc] init];
    mobole.font = [UIFont systemFontOfSize:15];
    [mobole setValue:textPlaceholderColor forKey:@"_placeholderLabel.textColor"];
    mobole.delegate = self;
    [scroll addSubview:mobole];
    NSDrawGrayLine * line2 = [[NSDrawGrayLine alloc] init];
    [scroll addSubview:line2];
    
//   checkCodeImage;
    checkCodeImage = [[UIImageView alloc] init];
    [scroll addSubview:checkCodeImage];
    
//   chekcCode;
    chekcCode = [[UITextField alloc] init];
    chekcCode.font = [UIFont systemFontOfSize:15];
    [chekcCode setValue:textPlaceholderColor forKey:@"_placeholderLabel.textColor"];
    chekcCode.delegate = self;
    [scroll addSubview:chekcCode];
    NSDrawGrayLine * line3 = [[NSDrawGrayLine alloc] init];
    [scroll addSubview:line3];
    
//  passWordImage;
    passWordImage = [[UIImageView alloc] init];
    [scroll addSubview:passWordImage];
    
//   passWord;
    passWord = [[UITextField alloc] init];
    passWord.font = [UIFont systemFontOfSize:15];
    [passWord setValue:textPlaceholderColor forKey:@"_placeholderLabel.textColor"];
    passWord.delegate = self;
    [scroll addSubview:passWord];
    NSDrawGrayLine * line4 = [[NSDrawGrayLine alloc] init];
    [scroll addSubview:line4];
    
//   rePassWord;
    rePassWord = [[UIImageView alloc] init];
    [scroll addSubview:rePassWord];
    
//   rePassWordText;
    rePassWordText = [[UITextField alloc] init];
    rePassWordText.font = [UIFont systemFontOfSize:15];
    [rePassWordText setValue:textPlaceholderColor forKey:@"_placeholderLabel.textColor"];
    rePassWordText.delegate = self;
    [scroll addSubview:rePassWordText];
    NSDrawGrayLine * line5 = [[NSDrawGrayLine alloc] init];
    [scroll addSubview:line5];
    
    //sendCheckCodeBtn
    sendCheckCodeBtn = [[UIButton alloc] init];
    [sendCheckCodeBtn addTarget:sendCheckCodeBtn action:@selector(sendCheckCode) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:sendCheckCodeBtn];
    
//  protocelBtn;
    protocelBtn = [[UIButton alloc] init];
    [scroll addSubview:protocelBtn];
    
//   registBtn;
    registBtn = [[UIButton alloc] init];
    [registBtn setBackgroundColor:[UIColor hexColorFloat:@"a6a6a5"]];
    registBtn.layer.cornerRadius = 10;
    [registBtn addTarget:self action:@selector(registe) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:registBtn];
    
//   loginBtn;
    loginBtn = [[UIButton alloc] init];
    [scroll addSubview:loginBtn];
    
    //constraints
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).with.offset(63);
        make.height.mas_equalTo(80);
        make.width.mas_equalTo(80);
    }];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
}

//send checkCode
-(void)sendCheckCode
{
    self.requestType = YES;
//    self.requestParams = ;
//    self.requestURL = ;
    
}
#pragma mark -override actionFetchRequest
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    
}

-(void)registe
{
    self.requestType = NO;
//    self.requestParams = ;
//    self.requestURL = ;
    
}


#pragma mark -textFiled Delegate
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == nickName) {
        
    }else if (textField == mobole){
        
    }else if (textField == chekcCode){
    
    }else if (textField == passWord){
    
    }else if (textField == rePassWordText){
    
    }
}
@end
