//
//  NSForgetPassWordViewController.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/30.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSForgetPassWordViewController.h"
#import "NSRegisterViewController.h"
#import "NSTextField.h"
#define KColor_Background [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1]
@interface NSForgetPassWordViewController ()<UITextFieldDelegate> {
    
    UIScrollView *scrollView;
    
    UITextField *phoneText;
    
    UITextField *passwordText;
    
    UITextField *repasswordText;
    
    UITextField *captchaText;
    NSString * url;
    NSTimer * timer;
    int num;
    UIButton *captchaBtn;
    NSTextField *phoneTF;
    NSTextField *codeTF;
    NSTextField *newPwdTF;
    NSTextField *ensurePwdTF;
    UIButton *ensureBtn;
    UIButton *codeBtn;
}

@end

@implementation NSForgetPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.userInteractionEnabled = YES;
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"2.0_login_backgroundImage"]];
    num = 60;
    [self setupNewUI];
//    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}
- (void)setupNewUI {
    self.title = @"修改密码";
    //手机号
    UIImage *phoneImg = [UIImage imageNamed:@"2.0_phonenumber_icon"];
    UIImageView *phoneImgView = [[UIImageView alloc] initWithImage:phoneImg];
    phoneImgView.frame = CGRectMake(0, 0, 12, 20);
    phoneTF = [[NSTextField alloc] initWithFrame:CGRectMake(15, 20, ScreenWidth -30, 40) drawingLeft:phoneImgView];
    phoneTF.delegate = self;
    phoneTF.layer.borderColor = [[UIColor hexColorFloat:@"ffd00b"] CGColor];
    phoneTF.font = [UIFont systemFontOfSize:15];
    phoneTF.placeholder = @" 输入手机号码";
//    [phoneTF addTarget:self action:@selector(textFieldContentChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:phoneTF];
    //验证码
    UIImage *codeImg = [UIImage imageNamed:@"2.0_checkCode"];
    UIImageView *codeImgView = [[UIImageView alloc] initWithImage:codeImg];
    codeImgView.frame = CGRectMake(0, 0, 12, 15);
    codeTF = [[NSTextField alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(phoneTF.frame)+10, ScreenWidth -30, 40) drawingLeft:codeImgView];
    codeTF.delegate = self;
    codeTF.layer.borderColor = [[UIColor hexColorFloat:@"ffd00b"] CGColor];
    codeTF.font = [UIFont systemFontOfSize:15];
    codeTF.placeholder = @" 验证码";
//    [codeTF addTarget:self action:@selector(textFieldContentChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:codeTF];
    UIView *yellowView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth - 110, CGRectGetMinY(codeTF.frame) + 10, 2, 20)];
    
    yellowView.backgroundColor = [UIColor hexColorFloat:@"ffd00b"];
    
    [self.view addSubview:yellowView];
    //获取验证码
    codeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    codeBtn.frame = CGRectMake(ScreenWidth - 108 , CGRectGetMaxY(phoneTF.frame) + 10, 90, 40);
    [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [codeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [codeBtn addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:codeBtn];
    
    //密码
    UIImage *newPwdImg = [UIImage imageNamed:@"2.0_password_gray"];
    UIImageView *newPwdImgView = [[UIImageView alloc] initWithImage:newPwdImg];
    newPwdImgView.frame = CGRectMake(0, 0, 12, 15);
    newPwdTF = [[NSTextField alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(codeTF.frame) + 10, ScreenWidth - 30, 40) drawingLeft:newPwdImgView];
    newPwdTF.delegate = self;
    newPwdTF.secureTextEntry = YES;
    newPwdTF.layer.borderColor = [[UIColor hexColorFloat:@"ffd00b"] CGColor];
    newPwdTF.font = [UIFont systemFontOfSize:15];
    newPwdTF.placeholder = @" 输入密码";
//    [newPwdTF addTarget:self action:@selector(textFieldContentChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:newPwdTF];
    
    //确认密码
    UIImage *ensurePwdImg = [UIImage imageNamed:@"2.0_repassword_gray"];
    UIImageView *ensurePwdImgView = [[UIImageView alloc] initWithImage:ensurePwdImg];
    ensurePwdImgView.frame = CGRectMake(0, 0, 12, 15);
    ensurePwdTF = [[NSTextField alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(newPwdTF.frame) + 10, ScreenWidth - 30, 40) drawingLeft:ensurePwdImgView];
    ensurePwdTF.delegate = self;
    ensurePwdTF.secureTextEntry = YES;
    ensurePwdTF.layer.borderColor = [[UIColor hexColorFloat:@"ffd00b"] CGColor];
    ensurePwdTF.font = [UIFont systemFontOfSize:15];
    ensurePwdTF.placeholder = @" 再次输入密码";
//    [ensurePwdTF addTarget:self action:@selector(textFieldContentChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:ensurePwdTF];
    
    ensureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    ensureBtn.frame = CGRectMake(30, CGRectGetMaxY(ensurePwdTF.frame) + 30, ScreenWidth - 60, 40);
    ensureBtn.layer.cornerRadius = 20;
    ensureBtn.backgroundColor = KColor_Background;
    [ensureBtn setTitle:@"确定重置密码" forState:UIControlStateNormal];
    [ensureBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [ensureBtn addTarget:self action:@selector(resetPassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ensureBtn];
}
- (void)setupUI {
    
    WS(wSelf);
    
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.autoAdaptKeyboard = YES;
    scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight);
    [self.view addSubview:scrollView];
    
    CGFloat logoY = 90;
    CGFloat phoneY = 45;
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
    
    
    //手机号
    UIView *phoneView = [[UIView alloc] initWithFrame:CGRectMake(75, CGRectGetMaxY(logoImage.frame) + phoneY, ScreenWidth - 150, 44)];
    
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
    phoneText.textColor = [UIColor hexColorFloat:@"c1c1c1"];
    phoneText.placeholder = @"手机号";
    
    [phoneText setValue:[UIColor hexColorFloat:@"c1c1c1"] forKeyPath:@"_placeholderLabel.textColor"];
    
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
        
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        
    } action:^(UIButton *btn) {
        
        if ([NSTool isValidateMobile:phoneText.text]) {
            
            wSelf.requestType = YES;
            NSDictionary * dic = @{@"mobile":phoneText.text,@"type":@"2"};
            
            NSString * str = [NSTool encrytWithDic:dic];
            
            wSelf.requestURL = [sendCodeURL stringByAppendingString:str];
            url = wSelf.requestURL;
            
            btn.enabled = NO;;
            
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            
            [btn setTitle:@"60s后重新获取" forState:UIControlStateDisabled];
            
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
    captchaText.textColor = [UIColor hexColorFloat:@"c1c1c1"];
    captchaText.placeholder = @"验证码";
    
    [captchaText setValue:[UIColor hexColorFloat:@"c1c1c1"] forKeyPath:@"_placeholderLabel.textColor"];
    
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
    
    passwordText.secureTextEntry = YES;
    
    passwordText.leftViewMode = UITextFieldViewModeAlways;
    passwordText.textColor = [UIColor hexColorFloat:@"c1c1c1"];
    passwordText.placeholder = @"输入密码";
    
    [passwordText setValue:[UIColor hexColorFloat:@"c1c1c1"] forKeyPath:@"_placeholderLabel.textColor"];
    
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
    
    repasswordText.secureTextEntry = YES;
    
    repasswordText.leftViewMode = UITextFieldViewModeAlways;
    
    repasswordText.placeholder = @"重新输入密码";
    repasswordText.textColor = [UIColor hexColorFloat:@"c1c1c1"];
    [repasswordText setValue:[UIColor hexColorFloat:@"c1c1c1"] forKeyPath:@"_placeholderLabel.textColor"];
    
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
        
        [wSelf resetPassword];
        
    }];
    
    [scrollView addSubview:loginBtn];
    
    
    //注册
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setTitle:@"不想重置? 重新注册" forState:UIControlStateNormal];
        
        btn.y = CGRectGetMaxY(loginBtn.frame) + 20;
        
        [btn sizeToFit];
        
    } action:^(UIButton *btn) {
        NSRegisterViewController *registerView = [[NSRegisterViewController alloc] init];
        
        [wSelf.navigationController pushViewController:registerView animated:YES];
        
        
    }];
    
    registerBtn.centerX = loginBtn.centerX;
    
    [scrollView addSubview:registerBtn];
    
    
    
}

- (void)tap:(UIGestureRecognizer *)tap {
    
    [phoneText resignFirstResponder];
    
    [passwordText resignFirstResponder];
    
    [repasswordText resignFirstResponder];
    
    [captchaText resignFirstResponder];
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
    
    codeBtn.titleLabel.text = [NSString stringWithFormat:@"%ds后重新获取",num];
    
    [codeBtn setTitle:[NSString stringWithFormat:@"%ds后重新获取",num] forState:UIControlStateDisabled];
    
    if (num == 0) {
        
        [codeBtn setTitle:@"重新获取" forState:UIControlStateDisabled];
        
        codeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        num = 60;
        
        codeBtn.enabled = YES;
        
        [self removeTimer];
    }
}

- (void)dealloc {
    
    [self removeTimer];
}
- (void)getCode {
    if ([NSTool isValidateMobile:phoneTF.text]) {
        
        self.requestType = YES;
        NSDictionary * dic = @{@"mobile":phoneTF.text,@"type":@"2"};
        
        NSString * str = [NSTool encrytWithDic:dic];
        
        self.requestURL = [sendCodeURL stringByAppendingString:str];
        
        url = self.requestURL;
        
        codeBtn.enabled = NO;;
        
        codeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        
        [codeBtn setTitle:@"60s后重新获取" forState:UIControlStateDisabled];
        
        [self addTimer];
        
    }else{
        [[NSToastManager manager] showtoast:@"请输入正确的手机号"];
    }
}
#pragma mark -resetPassWord
-(void)resetPassword
{
    if (phoneTF.text.length!=0) {
        if ([NSTool isValidateMobile:phoneTF.text]) {
            if (newPwdTF.text.length!=0) {
                if (codeTF.text.length!=0) {
                    if (newPwdTF.text.length!=0 || ensurePwdTF.text.length != 0) {
                        if ([newPwdTF.text isEqualToString:ensurePwdTF.text]) {
                            self.requestType = NO;
                            self.requestParams = @{@"mobile":phoneTF.text,@"code":codeTF.text,@"password":[newPwdTF.text stringToMD5] };
                            self.requestURL = reSetPasswordURL;
                            
                        }else{
                            [[NSToastManager manager] showtoast:@"两次输入密码不一致"];
                        }
                        
                    }else{
                        [[NSToastManager manager] showtoast:@"新密码不能为空"];
                    }
                    
                }else{
                    [[NSToastManager manager] showtoast:@"请输入验证码"];
                }
                
            }else{
                [[NSToastManager manager] showtoast:@"密码不能为空"];
            }
            
        }else{
            [[NSToastManager manager] showtoast:@"手机号不正确"];
        }
        
    }else{
        [[NSToastManager manager] showtoast:@"手机号码不能为空"];
    }
}

-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if (requestErr) {
        
    } else {
        if (!parserObject.success) {
            if ([operation.urlTag isEqualToString:url]) {
                [[NSToastManager manager] showtoast:@"验证码已发送，请注意查收"];
            }else if ([operation.urlTag isEqualToString:reSetPasswordURL]){
                [[NSToastManager manager ] showtoast:@"密码重置成功，请重新登录"];
                [self.navigationController popToRootViewControllerAnimated:YES  ];
                
            }
        }
    }
}

@end








