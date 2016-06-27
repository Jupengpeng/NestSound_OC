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
@interface NSLoginViewController () {
    
    UIScrollView *scrollView;
    
    UITextField *phoneText;
    
    UITextField *passwordText;
}

@end

@implementation     NSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"2.0_login_backgroundImage"]];
    self.isHidden = YES;
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}


#pragma  mark - override actionFetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if (!parserObject.success) {
        if ([operation.urlTag isEqualToString:loginURl]) {
            NSUserModel * userModels = (NSUserModel *)parserObject;
            userModel * user = userModels.userDetail;
        
            if (user.userName.length ==0) {
                
            }else{
            
            NSDictionary * userDic = @{@"userName":user.userName,
                                    @"userID":[NSString stringWithFormat:@"%ld",user.userID],
                                    @"userIcon":user.headerURL,
                                    @"userLoginToken":user.loginToken,
                                    @"birthday":user.birthday,
                                    @"male":[NSNumber numberWithInt:user.male],
                                       @"desc":user.desc
                                       };
            [[NSUserDefaults standardUserDefaults] setObject:userDic forKey:@"user"];
            [MobClick profileSignInWithPUID:[NSString stringWithFormat:@"%ld",user.userID]];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
        
    }else{
        [[NSToastManager manager] showtoast:requestErr.description];
        
    }
    
}


#pragma mark - setupUI
- (void)setupUI {
    
    WS(wSelf);
    
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.autoAdaptKeyboard = YES;
    scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight);
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
        
        NSRegisterViewController *registerView = [[NSRegisterViewController alloc] init];
        
        [wSelf.navigationController pushViewController:registerView animated:YES];
        
    }];
    
    registerBtn.centerX = loginBtn.centerX;
    
    [scrollView addSubview:registerBtn];

    
    
}

-(void)loagin
{
        
    if (passwordText.text.length == 0 || phoneText.text.length == 0) {
        [[NSToastManager manager] showtoast:@"账号和密码不能为空"];
    }else if ([NSTool isStringEmpty:phoneText.text]) {
     
        [[NSToastManager manager] showtoast:@"请输入正确的手机号"];
        
    } else {
        
        self.requestType = NO;
        self.requestParams = @{@"mobile":phoneText.text,
                               @"password":[passwordText.text stringToMD5]};
        self.requestURL = loginURl;
        
    }
    
}

- (void)tap:(UIGestureRecognizer *)tap {
    
    [phoneText resignFirstResponder];
    
    [passwordText resignFirstResponder];
}

@end






