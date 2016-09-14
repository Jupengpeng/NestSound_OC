//
//  NSLoginViewController.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/30.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSLoginViewController.h"
#import "UIScrollView+NSKeyboardAutoAdapt.h"
#import "NSForgetPassWordViewController.h"
#import "NSRegisterViewController.h"
#import "NSUserModel.h"
#import "NSLoginView.h"
#import "NSRegisterView.h"
#import "NSH5ViewController.h"
#define KColor_Background [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1]
@interface NSLoginViewController () {
    
    UIScrollView *scrollView;
    
    UITextField *phoneText;
    
    UITextField *passwordText;
    
    UIImageView *leftImgView;
    
    UIImageView *rightImgView;
    
    NSLoginView *loginView;
    
    NSRegisterView *registerView;
    
    UIButton *loginButton;
    
    UIButton *registerButton;
    
    UIView *protocolView;
    
    NSTimer *timer;
    
    NSString * url;
    
    int num;
}

@end

@implementation     NSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    num = 60;
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"2.0_login_backgroundImage"]];
    self.isHidden = YES;
   [self setupNewUI];
  //  [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

//登录
-(void)loagin
{
    [[NSToastManager manager] showprogress];
    if (loginView.phoneTF.text.length == 0 || loginView.PwdTF.text.length == 0) {
        [[NSToastManager manager] showtoast:@"账号和密码不能为空"];
    }else if ([NSTool isStringEmpty:loginView.phoneTF.text]) {
        
        [[NSToastManager manager] showtoast:@"请输入正确的手机号"];
        
    } else {
        
        self.requestType = NO;
        self.requestParams = @{@"mobile":loginView.phoneTF.text,
                               @"password":[loginView.PwdTF.text stringToMD5]};
        self.requestURL = loginURl;
        
    }
    
}
//注册
-(void)registerNumber
{
    self.requestType = NO;
    if (registerView.userNameTF.text.length == 0) {
        
        [[NSToastManager manager] showtoast:@"昵称不能为空"];
    } else if (registerView.passwordTF.text.length == 0 || registerView.phoneTF.text.length == 0) {
        
        [[NSToastManager manager] showtoast:@"账号和密码不能为空"];
    } else if (registerView.phoneTF.text.length != 11) {
        
        [[NSToastManager manager] showtoast:@"请输入正确的手机号"];
        
    } else if (registerView.codeTF.text.length == 0) {
        
        [[NSToastManager manager] showtoast:@"请输入验证码"];
    } else if (![registerView.passwordTF.text isEqualToString:registerView.repasswordTF.text]) {
        
        [[NSToastManager manager] showtoast:@"亲，两次输入密码不一致哦"];
        
    }else{
        
        NSString * password = [registerView.passwordTF.text stringToMD5];
        NSString * rePassword = [registerView.repasswordTF.text stringToMD5];
        self.requestParams = @{@"name":registerView.userNameTF.text,
                               @"phone":registerView.phoneTF.text,
                               @"password":password,
                               @"repassword":rePassword,
                               @"code":registerView.codeTF.text,
                               kIsLoadingMore:@(NO),@"type":@(NO)};
        self.requestURL = registerURL;
        
    }
    
}
#pragma  mark - override actionFetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        
    } else {
        if (!parserObject.success) {
            if ([operation.urlTag isEqualToString:loginURl]) {
                NSUserModel * userModels = (NSUserModel *)parserObject;
                userModel * user = userModels.userDetail;
                if (user.userName.length ==0) {
                    
                } else {
                    NSDictionary * userDic = @{@"userName":user.userName,
                                               @"userID":[NSString stringWithFormat:@"%ld",user.userID],
                                               @"userIcon":user.headerURL,
                                               @"userLoginToken":user.loginToken,
                                               @"birthday":user.birthday,
                                               @"male":[NSNumber numberWithInt:user.male],
                                               @"desc":user.desc,
                                               };
                    [[NSUserDefaults standardUserDefaults] setObject:userDic forKey:@"user"];
                    [[NSUserDefaults standardUserDefaults] setObject:user.bgPic forKey:@"bgPic"];
                    [JPUSHService setAlias:[NSString stringWithFormat:@"%ld",user.userID] callbackSelector:nil object:nil];
                    [MobClick profileSignInWithPUID:[NSString stringWithFormat:@"%ld",user.userID]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUserPageNotific" object:nil];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            } else if ([operation.urlTag isEqualToString:url]) {
                if (parserObject.code == 200) {
                    registerView.codeBtn.enabled = NO;;
                    
                    [self addTimer];
                } else {
                    
                    [[NSToastManager manager] showtoast:parserObject.message];
                    
                }
                
            }else if ([operation.urlTag isEqualToString:registerURL]){
                
                
                if (parserObject.code == 200) {
                    self.requestType = NO;
                    self.requestParams = @{@"mobile":registerView.phoneTF.text,
                                           @"password":[registerView.passwordTF.text stringToMD5]};
                    self.requestURL = loginURl;
                } else {
                    [[NSToastManager manager] showtoast:parserObject.message];
                }
                
//                [self loginEvent:nil];
                
            }
            
        }else{
            [[NSToastManager manager] showtoast:requestErr.description];
            
        }
    }
}


#pragma mark - setupUI
- (void)setupNewUI {
    
    WS(wSelf);
    
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    if ([[NSTool getMachine] isEqualToString:IPHONE4] || [[NSTool getMachine] isEqualToString:IPHONE4S]) {
        scrollView.contentSize = CGSizeMake(self.view.width, self.view.height + 50);
    }else{
        scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight);
    }
    scrollView.autoAdaptKeyboard = YES;
    scrollView.alwaysBounceVertical = YES;
    
    [self.view addSubview:scrollView];
    
    //返回按钮
    UIButton *dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setImage:[UIImage imageNamed:@"2.0_cancel_btn"] forState:UIControlStateNormal];
        
        btn.x = 15;
        
        btn.y = 32;
        
        [btn sizeToFit];
        
    } action:^(UIButton *btn) {
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        
        [wSelf dismissViewControllerAnimated:YES completion:nil];
        
        self.isHidden = NO;
    }];
    
    [self.view addSubview:dismissBtn];
    
    //轻拍手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
    
    //登录背景图片
    UIImageView *backImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.0_login_topbackImg"]];
    
    backImgView.y = 20 ;
    
    backImgView.centerX = self.view.centerX;
    
    [scrollView addSubview:backImgView];
    
    //logo
    UIImageView *logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LOGO"]];
    
    logoImage.y = 80;
    
    logoImage.centerX = scrollView.centerX;
    
    [scrollView addSubview:logoImage];
    
    //登录
    UIButton *loginBnt = [UIButton buttonWithType:UIButtonTypeSystem];
    
    loginBnt.frame = CGRectMake(ScreenWidth/4-30, CGRectGetMaxY(backImgView.frame) + 10, 60, 30);
    
    [loginBnt setTitle:@"登录" forState:UIControlStateNormal];
    
    [loginBnt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [loginBnt addTarget:self action:@selector(loginEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    [scrollView addSubview:loginBnt];
    
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, ScreenHeight - 130, ScreenWidth/2 - 90, 0.5)];
        leftLabel.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:leftLabel];
        UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2 + 70, ScreenHeight - 130, ScreenWidth/2 - 90, 0.5)];
        rightLabel.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:rightLabel];
    
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2 - 60, ScreenHeight - 140, 120, 20)];
        textLabel.text = @"使用第三方快速登录";
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = [UIFont systemFontOfSize:13];
        textLabel.textColor = [UIColor lightGrayColor];
        [self.view addSubview:textLabel];
    
        NSArray *images = @[[UIImage imageNamed:@"2.0_weChat"], [UIImage imageNamed:@"2.0_sina"], [UIImage imageNamed:@"2.0_qq"]];
        for (int i = 0; i < 3; i++) {
            UIButton *otherButton = [UIButton buttonWithType:UIButtonTypeCustom];
            otherButton.frame = CGRectMake(ScreenWidth / 2 - 100 + 80 * i, ScreenHeight - 100, 40, 40);
            [otherButton setBackgroundImage:images[i] forState:UIControlStateNormal];
            otherButton.tag = 110 + i;
            [otherButton addTarget:self action:@selector(handleThirdLog:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:otherButton];
        }
    
    leftImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.0_triangle_icon"]];
    
    leftImgView.y = CGRectGetMaxY(loginBnt.frame);
    
    leftImgView.centerX = loginBnt.centerX;
    
    [scrollView addSubview:leftImgView];
    
    loginView = [[NSLoginView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(leftImgView.frame)-0.5, ScreenWidth, 80)];
    
    [loginView.forgetBtn addTarget:self action:@selector(forgetPassword:) forControlEvents:UIControlEventTouchUpInside];
    
    [scrollView addSubview:loginView];
    
    loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    loginButton.frame = CGRectMake(40, CGRectGetMaxY(loginView.frame) + 30, ScreenWidth - 80, 40);
    
    loginButton.layer.cornerRadius = 20;
    
    loginButton.layer.masksToBounds = YES;
    
    loginButton.backgroundColor = KColor_Background;
    
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    
    [loginButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [loginButton addTarget:self action:@selector(loagin) forControlEvents:UIControlEventTouchUpInside];
    
    [scrollView addSubview:loginButton];
    
    //注册
    UIButton *registerBnt = [UIButton buttonWithType:UIButtonTypeSystem];
    
    registerBnt.frame = CGRectMake(3*ScreenWidth/4-30, CGRectGetMaxY(backImgView.frame) + 10, 60, 30);
    
    [registerBnt setTitle:@"注册" forState:UIControlStateNormal];
    
    [registerBnt setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [registerBnt addTarget:self action:@selector(registerEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    [scrollView addSubview:registerBnt];
    
    rightImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.0_triangle_icon"]];
    
    rightImgView.y = CGRectGetMaxY(registerBnt.frame);
    
    rightImgView.centerX = registerBnt.centerX;
    
    registerView = [[NSRegisterView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(rightImgView.frame)-0.5, ScreenWidth, 200)];
    
    [registerView.codeBtn addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
    
    //协议
    protocolView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(registerView.frame) + 10, ScreenWidth, 20)];
    
    UIImageView *protocolImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.0_yes_icon"]];
    
    [protocolView addSubview:protocolImage];
    
    [protocolImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(protocolView.mas_left).offset(15);
        
        make.centerY.equalTo(protocolView.mas_centerY);
    }];
    
    UILabel *protocolLabel = [[UILabel alloc] init];
    
    protocolLabel.textColor = [UIColor darkGrayColor];
    
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
        
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
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
    
    registerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    registerButton.frame = CGRectMake(40, CGRectGetMaxY(protocolView.frame) + 30, ScreenWidth - 80, 40);
    
    registerButton.layer.cornerRadius = 20;
    
    registerButton.layer.masksToBounds = YES;
    
    registerButton.backgroundColor = KColor_Background;
    
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    
    [registerButton addTarget:self action:@selector(registerNumber) forControlEvents:UIControlEventTouchUpInside];
    
    [registerButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
}
- (void)loginEvent:(UIButton *)sender {
    [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [rightImgView removeFromSuperview];
    
    [leftImgView removeFromSuperview];
    
    [registerView removeFromSuperview];
    
    [protocolView removeFromSuperview];
    
    [registerButton removeFromSuperview];
    
    [scrollView addSubview:leftImgView];
    
    [scrollView addSubview:loginView];
    
    [scrollView addSubview:loginButton];
}
- (void)registerEvent:(UIButton *)sender {
    
    [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [loginButton removeFromSuperview];
    
    [leftImgView removeFromSuperview];
    
    [rightImgView removeFromSuperview];
    
    [scrollView addSubview:rightImgView];
    
    [scrollView addSubview:registerView];
    
    [scrollView addSubview:protocolView];
    
    [scrollView addSubview:registerButton];
}
- (void)setupUI {
    
    WS(wSelf);
    
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    if ([[NSTool getMachine] isEqualToString:IPHONE4] || [[NSTool getMachine] isEqualToString:IPHONE4S]) {
         scrollView.contentSize = CGSizeMake(self.view.width, self.view.height + 50);
    }else{
    scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight);
    }
   
    scrollView.autoAdaptKeyboard = YES;
    scrollView.alwaysBounceVertical = YES;
    
    [self.view addSubview:scrollView];
    
    UIButton *dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setImage:[UIImage imageNamed:@"2.0_dismiss_btn"] forState:UIControlStateNormal];
        
        btn.x = 15;
        
        btn.y = 32;
        
        [btn sizeToFit];
        
    } action:^(UIButton *btn) {
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        self.isHidden = NO;
    }];
    
    [self.view addSubview:dismissBtn];
   
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
    
    UIImageView *logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LOGO"]];
    
    logoImage.y = 90;
    
    logoImage.centerX = scrollView.centerX;
    
    [scrollView addSubview:logoImage];
    
    
    //手机号
    UIView *phoneView = [[UIView alloc] initWithFrame:CGRectMake(75, CGRectGetMaxY(logoImage.frame) + 45, ScreenWidth - 150, 44)];
    
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
    
    //密码
    UIView *passwordView = [[UIView alloc] initWithFrame:CGRectMake(75, CGRectGetMaxY(phoneView.frame) + 20, ScreenWidth - 150, 44)];
    
    [scrollView addSubview:passwordView];
    
    UIImageView *passwordImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.0_password"]];
    
    [passwordView addSubview:passwordImage];
    
    [passwordImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(passwordView.mas_left).offset(10);
        
        make.centerY.equalTo(passwordView.mas_centerY);
    }];
    
    passwordText = [[UITextField alloc] init];
    
    passwordText.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordText.textColor = [UIColor hexColorFloat:@"c1c1c1"];
    passwordText.leftViewMode = UITextFieldViewModeAlways;
    passwordText.secureTextEntry = YES;
    passwordText.placeholder = @"密码";
    [passwordText setValue:[UIColor hexColorFloat:@"c1c1c1"] forKeyPath:@"_placeholderLabel.textColor"];
    
    [passwordView addSubview:passwordText];
    
    [passwordText mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(passwordView.mas_left).offset(30);
        
        make.right.equalTo(passwordView.mas_right);
        
        make.centerY.equalTo(passwordView.mas_centerY);
    }];
    

    //忘记密码
    UIButton *forgetPasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setTitle:@"忘记密码?" forState:UIControlStateNormal];
        
        [btn setTitleColor:[UIColor hexColorFloat:@"c1c1c1"] forState:UIControlStateNormal];
        
        btn.x = 75;
        
        btn.y = CGRectGetMaxY(passwordView.frame) + 20;
        
        [btn sizeToFit];
        
    } action:^(UIButton *btn) {
        NSForgetPassWordViewController *forgetPassword = [[NSForgetPassWordViewController alloc] init];
        
        [wSelf.navigationController pushViewController:forgetPassword animated:YES];
        
    }];
    
    [scrollView addSubview:forgetPasswordBtn];
    
    UIView *lineView1 = [[UIView alloc] init];
    lineView1.backgroundColor = [UIColor hexColorFloat:@"c1c1c1"];
    [passwordView addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(passwordView);
        make.height.mas_equalTo(1);
    }];

    
   
    //登录
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setTitle:@"登录" forState:UIControlStateNormal];
        
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        btn.backgroundColor = [UIColor hexColorFloat:@"c1c1c1"];
        
        btn.x = 50;
        
        btn.y = CGRectGetMaxY(forgetPasswordBtn.frame) + 50;
        
        btn.width = ScreenWidth - 100;
        
        btn.height = 44;
        
    } action:^(UIButton *btn) {
        
        [wSelf loagin];
        
    }];
    
    [scrollView addSubview:loginBtn];
    
    
    //注册
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setTitle:@"没有账号? 点击注册" forState:UIControlStateNormal];
        
        btn.y = CGRectGetMaxY(loginBtn.frame) + 20;
        
        [btn sizeToFit];
        
    } action:^(UIButton *btn) {
        
//        NSRegisterViewController *registerView = [[NSRegisterViewController alloc] init];
//        
//        [wSelf.navigationController pushViewController:registerView animated:YES];
        
    }];
    [registerBtn addTarget:self action:@selector(registerUser:) forControlEvents:UIControlEventTouchUpInside];
    
    registerBtn.centerX = loginBtn.centerX;
    
    [scrollView addSubview:registerBtn];

    
}
//第三方登录
- (void)handleThirdLog:(UIButton *)sender {
    switch (sender.tag) {
        case 110:
        {
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
            
            snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                
                if (response.responseCode == UMSResponseCodeSuccess) {
                    
                    NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
                    UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
                    NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
                    
                }
                
            });
        }
            break;
        case 111:
        {
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
            
            snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                
                //          获取微博用户名、uid、token等
                
                if (response.responseCode == UMSResponseCodeSuccess) {
                    
                    NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
                    UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
                    NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
                    
                }});
        }
            break;
        case 112:
        {
            UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
            
            snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                
                //          获取微博用户名、uid、token等
                
                if (response.responseCode == UMSResponseCodeSuccess) {
                    
                    NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
                    UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
                    NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
                    
                }});
        }
            break;
        default:
            break;
    }
//    []
}
//忘记密码
- (void)forgetPassword:(UIButton *)sender {
    NSForgetPassWordViewController *forgetPassword = [[NSForgetPassWordViewController alloc] init];
    
    [self.navigationController pushViewController:forgetPassword animated:YES];
}
-(void)registerUser:(UIButton *)btn
{
    NSRegisterViewController * registerVC = [[NSRegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}
//获取验证码
- (void)getCode {
    if ([NSTool isValidateMobile:registerView.phoneTF.text]) {
        
        self.requestType = YES;
        NSDictionary * dic = @{@"mobile":registerView.phoneTF.text,@"type":@"1"};
        
        NSString * str = [NSTool encrytWithDic:dic];
        
        self.requestURL = [sendCodeURL stringByAppendingString:str];
        
        url = self.requestURL;
        
    }else{
        [[NSToastManager manager] showtoast:@"请输入正确的手机号"];
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
    
    registerView.codeBtn.titleLabel.text = [NSString stringWithFormat:@"%ds后重新获取",num];
    
//    registerView.codeBtn.titleLabel.font = [UIFont systemFontOfSize:12];

    [registerView.codeBtn setTitle:[NSString stringWithFormat:@"%ds后重新获取",num] forState:UIControlStateDisabled];
    
    if (num == 0) {
        
        [registerView.codeBtn setTitle:@"重新获取" forState:UIControlStateDisabled];
        
//        registerView.codeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        num = 60;
        
        registerView.codeBtn.enabled = YES;
        
        [self removeTimer];
    }
}

- (void)dealloc {
    
    [self removeTimer];
}
- (void)tap:(UIGestureRecognizer *)tap {
    
    [phoneText resignFirstResponder];
    
    [passwordText resignFirstResponder];
}

@end






