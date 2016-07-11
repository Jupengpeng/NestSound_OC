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
#import "NSLoginViewController.h"
#import "NSH5ViewController.h"
#define textPlaceholderColor [UIColor colorWithRed:193 / 255.0 green:193 / 255.0 blue:193 / 255.0 alpha:1]

@interface NSRegisterViewController () {
    
    UIScrollView *scrollView;
    
    UITextField *userNameText;
    
    UITextField *phoneText;
    
    UITextField *passwordText;
    
    UITextField *repasswordText;
    
    UITextField *captchaText;
    NSString * url;
    
    NSTimer *timer;
    
    UIButton *captchaBtn;
    
    int num;
}

@end

@implementation NSRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"2.0_login_backgroundImage"]];
    
    num = 60;
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark -override actionFetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if (!parserObject.success) {
        if ([operation.urlTag isEqualToString:url]) {
        
            [[NSToastManager manager] showtoast:@"验证码已发送，请注意查收"];
        }else if ([operation.urlTag isEqualToString:registerURL]){
            [[NSToastManager manager] showtoast:@"注册成功，请您登陆"];
           [self.navigationController popToRootViewControllerAnimated:YES];
        }
    
            
        
    }else{
        [[NSToastManager manager ] showtoast:@"亲，您网络飞出去玩了"];

    }


}



#pragma mark -setupUI
- (void)setupUI {
    
    WS(wSelf);
    
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.autoAdaptKeyboard = YES;
    if ([[NSTool getMachine] isEqualToString:IPHONE4] || [[NSTool getMachine] isEqualToString:IPHONE4S]) {
        scrollView.contentSize = CGSizeMake(self.view.width, self.view.height + 100);
    }else{
        scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight);
    }

    [self.view addSubview:scrollView];
    
    CGFloat logoY = 90;
    CGFloat phoneY = 40;
    CGFloat allY = 20;
    if (ScreenHeight < 667) {
        
        logoY = 50;
        phoneY = 25;
        allY = 10;
    }
    
    UIButton *dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setImage:[UIImage imageNamed:@"2.0_playSongs_pop"] forState:UIControlStateNormal];
        
        btn.x = 15;
        
        btn.y = 32;
        
        [btn sizeToFit];
        
    } action:^(UIButton *btn) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
    [self.view addSubview:dismissBtn];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
    
    UIImageView *logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LOGO"]];
    
    logoImage.y = logoY;
    
    logoImage.centerX = scrollView.centerX;
    
    [scrollView addSubview:logoImage];
    
    
    //用户名
    UIView *userNameView = [[UIView alloc] initWithFrame:CGRectMake(75, CGRectGetMaxY(logoImage.frame) + phoneY, ScreenWidth - 150, 44)];
    
    [scrollView addSubview:userNameView];
    
    UIImageView *userNameImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.0_userName"]];
    
    [userNameView addSubview:userNameImage];
    
    [userNameImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(userNameView.mas_left).offset(10);
        
        make.centerY.equalTo(userNameView.mas_centerY);

    }];
    
    userNameText = [[UITextField alloc] init];
    
    userNameText.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    userNameText.leftViewMode = UITextFieldViewModeAlways;
    
    userNameText.placeholder = @"用户名";
    
    [userNameText setValue:[UIColor hexColorFloat:@"c1c1c1"] forKeyPath:@"_placeholderLabel.textColor"];
    
    userNameText.textColor = [UIColor hexColorFloat:@"c1c1c1"];
    
    [userNameView addSubview:userNameText];
    
    [userNameText mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(userNameView.mas_left).offset(30);
        
        make.right.equalTo(userNameView.mas_right);
        
        make.centerY.equalTo(userNameView.mas_centerY);
    }];
    
    
    UIView *lineView4 = [[UIView alloc] init];
    lineView4.backgroundColor = [UIColor hexColorFloat:@"c1c1c1"];
    [userNameView addSubview:lineView4];
    [lineView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(userNameView);
        make.height.mas_equalTo(1);
    }];

    
    //手机号
    UIView *phoneView = [[UIView alloc] initWithFrame:CGRectMake(75, CGRectGetMaxY(userNameView.frame) + allY, ScreenWidth - 150, 44)];
    
    [scrollView addSubview:phoneView];
    
    UIImageView *phoneImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.0_phone_icon"]];
    
    [phoneView addSubview:phoneImage];
    
    [phoneImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(phoneView.mas_left).offset(10);
        
        make.centerY.equalTo(phoneView.mas_centerY);
    }];
    
    phoneText = [[UITextField alloc] init];
    
    phoneText.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    phoneText.leftViewMode = UITextFieldViewModeAlways;
    
    phoneText.placeholder = @"手机号";
    
    [phoneText setValue:[UIColor hexColorFloat:@"c1c1c1"] forKeyPath:@"_placeholderLabel.textColor"];
    
    phoneText.textColor = [UIColor hexColorFloat:@"c1c1c1"];
    
    phoneText.keyboardType = UIKeyboardTypeNumberPad;
    
    [phoneView addSubview:phoneText];
    
    [phoneText mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(phoneView.mas_left).offset(30);
        
        make.right.equalTo(phoneView.mas_right);
        
        make.centerY.equalTo(phoneView.mas_centerY);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor hexColorFloat:@"c1c1c1"];
    [phoneView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(phoneView);
        make.height.mas_equalTo(1);
    }];
    
    //验证码
    UIView *captchaView = [[UIView alloc] initWithFrame:CGRectMake(75, CGRectGetMaxY(phoneView.frame) + allY, ScreenWidth - 150, 44)];
    
    [scrollView addSubview:captchaView];
    
    UIImageView *captchaImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.0_phone_icon"]];
    
    [captchaView addSubview:captchaImage];
    
    [captchaImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(captchaView.mas_left).offset(10);
        
        make.centerY.equalTo(captchaView.mas_centerY);
    }];
    
    captchaBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
    } action:^(UIButton *btn) {
        
        if ([NSTool isValidateMobile:phoneText.text]) {
           
            wSelf.requestType = YES;
            NSDictionary * dic = @{@"mobile":phoneText.text,@"type":@"1"};
            
            NSString * str = [NSTool encrytWithDic:dic];
            
            wSelf.requestURL = [sendCodeURL stringByAppendingString:str];
            url = wSelf.requestURL;
            
            btn.enabled = NO;;
            
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            
            [btn setTitle:@"(60s)重新获取" forState:UIControlStateDisabled];
            
            [wSelf addTimer];
            
        }else{
            [[NSToastManager manager] showtoast:@"请输入正确的手机号"];
        }
        
    }];
    
    [captchaView addSubview:captchaBtn];
    
    [captchaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(captchaView.mas_right);
        
        make.centerY.equalTo(captchaView.mas_centerY);
        
        make.width.mas_equalTo(80);
    }];
    
    
    captchaText = [[UITextField alloc] init];
    
    captchaText.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    captchaText.leftViewMode = UITextFieldViewModeAlways;
    
    captchaText.placeholder = @"验证码";
    
    [captchaText setValue:[UIColor hexColorFloat:@"c1c1c1"] forKeyPath:@"_placeholderLabel.textColor"];
    
    captchaText.textColor = [UIColor hexColorFloat:@"c1c1c1"];
    
    captchaText.keyboardType = UIKeyboardTypeNumberPad;
    
    [captchaView addSubview:captchaText];
    
    [captchaText mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(captchaView.mas_left).offset(30);
        
        make.right.equalTo(captchaBtn.mas_left);
        
        make.centerY.equalTo(captchaView.mas_centerY);
    }];
    
    UIView *lineView3 = [[UIView alloc] init];
    lineView3.backgroundColor = [UIColor hexColorFloat:@"c1c1c1"];
    [captchaView addSubview:lineView3];
    [lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(captchaView);
        make.height.mas_equalTo(1);
    }];
    
    
    //密码
    UIView *passwordView = [[UIView alloc] initWithFrame:CGRectMake(75, CGRectGetMaxY(captchaView.frame) + allY, ScreenWidth - 150, 44)];
    
    [scrollView addSubview:passwordView];
    
    UIImageView *passwordImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.0_password"]];
    
    [passwordView addSubview:passwordImage];
    
    [passwordImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(passwordView.mas_left).offset(10);
        
        make.centerY.equalTo(passwordView.mas_centerY);
    }];
    
    passwordText = [[UITextField alloc] init];
    
    passwordText.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    passwordText.leftViewMode = UITextFieldViewModeAlways;
    
    passwordText.textColor = [UIColor hexColorFloat:@"c1c1c1"];
    
    passwordText.placeholder = @"输入密码";
    
    [passwordText setValue:[UIColor hexColorFloat:@"c1c1c1"] forKeyPath:@"_placeholderLabel.textColor"];
    
    passwordText.secureTextEntry = YES;
    
    [passwordView addSubview:passwordText];
    
    [passwordText mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(passwordView.mas_left).offset(30);
        
        make.right.equalTo(passwordView.mas_right);
        
        make.centerY.equalTo(passwordView.mas_centerY);
    }];
    
    
    UIView *lineView1 = [[UIView alloc] init];
    lineView1.backgroundColor = [UIColor hexColorFloat:@"c1c1c1"];
    [passwordView addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(passwordView);
        make.height.mas_equalTo(1);
    }];
    
    //重写输入密码
    UIView *repasswordView = [[UIView alloc] initWithFrame:CGRectMake(75, CGRectGetMaxY(passwordView.frame) + allY, ScreenWidth - 150, 44)];
    
    [scrollView addSubview:repasswordView];
    
    UIImageView *repasswordImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.0_repassword"]];
    
    [repasswordView addSubview:repasswordImage];
    
    [repasswordImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(repasswordView.mas_left).offset(10);
        
        make.centerY.equalTo(repasswordView.mas_centerY);
    }];
    
    repasswordText = [[UITextField alloc] init];
    
    repasswordText.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    repasswordText.leftViewMode = UITextFieldViewModeAlways;
    
    repasswordText.textColor = [UIColor hexColorFloat:@"c1c1c1"];
    
    repasswordText.placeholder = @"重新输入密码";
    
    [repasswordText setValue:[UIColor hexColorFloat:@"c1c1c1"] forKeyPath:@"_placeholderLabel.textColor"];
    
    repasswordText.secureTextEntry = YES;
    
    [repasswordView addSubview:repasswordText];
    
    [repasswordText mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(repasswordView.mas_left).offset(30);
        
        make.right.equalTo(repasswordView.mas_right);
        
        make.centerY.equalTo(repasswordView.mas_centerY);
    }];
    
    
    UIView *lineView2 = [[UIView alloc] init];
    lineView2.backgroundColor = [UIColor hexColorFloat:@"c1c1c1"];
    [repasswordView addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(repasswordView);
        make.height.mas_equalTo(1);
    }];
    
    
    //协议
    UIView *protocolView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(repasswordView.frame) + 10, ScreenWidth, 20)];

    CGFloat offset = 85;
    
    if (ScreenHeight < 667) {
        
        offset = 40;
    } else if(ScreenHeight >= 667 && ScreenHeight < 736) {
        
        offset = 67;
    }
    
    [scrollView addSubview:protocolView];
    
    UIImageView *protocolImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.0_cuntermark"]];
    
    [protocolView addSubview:protocolImage];
    
    [protocolImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(protocolView.mas_left).offset(offset);
        
        make.centerY.equalTo(protocolView.mas_centerY);
    }];
    
    UILabel *protocolLabel = [[UILabel alloc] init];
    
    protocolLabel.textColor = [UIColor whiteColor];
    
    protocolLabel.text = @"我已阅读并同意";
    
    protocolLabel.font = [UIFont systemFontOfSize:12];
    
    [protocolView addSubview:protocolLabel];
    
    [protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(protocolImage.mas_right).offset(10);
        
        make.centerY.equalTo(protocolView.mas_centerY);
    }];
    
    UIButton *protocolBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setTitle:@"《音巢APP用户使用协议》" forState:UIControlStateNormal];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        
        [btn setTitleColor:[UIColor hexColorFloat:@"ffeb97"] forState:UIControlStateNormal];
        
    } action:^(UIButton *btn) {
        
        NSH5ViewController * protocolVC =[[NSH5ViewController alloc] init];
        
        protocolVC.h5Url = @"http://www.yinchao.cn/html/xieyi.html";
        
        [self.navigationController pushViewController:protocolVC animated:YES];
        
        
    }];
    
    [protocolView addSubview:protocolBtn];
    
    [protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(protocolLabel.mas_right);
        
        make.centerY.equalTo(protocolView.mas_centerY);
    }];
    
    
    //登录
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        btn.backgroundColor = [UIColor hexColorFloat:@"c1c1c1"];
        
        btn.x = 50;
        
        btn.y = CGRectGetMaxY(repasswordView.frame) + 50;
        
        btn.width = ScreenWidth - 100;
        
        btn.height = 44;
        
    } action:^(UIButton *btn) {
        
        [self registerNumber];
    
    }];
    
    [scrollView addSubview:loginBtn];
    
    
    //注册
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setTitle:@"已有账号? 点击登录" forState:UIControlStateNormal];
        
        btn.y = CGRectGetMaxY(loginBtn.frame) + 20;
        
        [btn sizeToFit];
        
    } action:^(UIButton *btn) {
        
        [wSelf.navigationController popToRootViewControllerAnimated:YES];
        
    }];
    
    
    [loginBtn addTarget:self action:@selector(registerNumber) forControlEvents:UIControlEventTouchUpInside];
    registerBtn.centerX = loginBtn.centerX;
    
    [scrollView addSubview:registerBtn];
    
}

- (void)tap:(UIGestureRecognizer *)tap {
    
    [userNameText resignFirstResponder];
    
    [phoneText resignFirstResponder];
    
    [passwordText resignFirstResponder];
    
    [repasswordText resignFirstResponder];
    
    [captchaText resignFirstResponder];
}

-(void)registerNumber
{
    self.requestType = NO;
    if (userNameText.text.length == 0) {
        
        [[NSToastManager manager] showtoast:@"昵称不能为空"];
    } else if (passwordText.text.length == 0 || phoneText.text.length == 0) {
        
        [[NSToastManager manager] showtoast:@"账号和密码不能为空"];
    } else if (![NSTool isValidateMobile:phoneText.text]) {
        
        [[NSToastManager manager] showtoast:@"请输入正确的手机号"];
        
    } else if (captchaText.text.length == 0) {
        
        [[NSToastManager manager] showtoast:@"请输入验证码"];
    } else if (![passwordText.text isEqualToString:repasswordText.text]) {
        
        [[NSToastManager manager] showtoast:@"亲，两次输入密码不一致哦"];
    }else{
        NSString * password = [passwordText.text stringToMD5];
        NSString * rePassword = [repasswordText.text stringToMD5];
        self.requestParams = @{@"name":userNameText.text,
                               @"phone":phoneText.text,
                               @"password":password,
                               @"repassword":rePassword,
                               @"code":captchaText.text,
                               kIsLoadingMore:@(NO),@"type":@(NO)};
        self.requestURL = registerURL;
    
    }
    
}

- (void)addTimer {
    
    timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer {
    
    [timer invalidate];
    
    timer = nil;
}

- (void)timerAction {
    
    num--;
    
    [captchaBtn setTitle:[NSString stringWithFormat:@"(%ds)重新获取",num] forState:UIControlStateDisabled];
    
    if (num == 0) {
        
        captchaBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        num = 60;
        
        captchaBtn.enabled = YES;
        
        [self removeTimer];
    }
}

- (void)dealloc {
    
    [self removeTimer];
}

@end




