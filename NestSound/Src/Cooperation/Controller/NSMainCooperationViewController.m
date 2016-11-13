//
//  NSMainCooperationViewController.m
//  NestSound
//
//  Created by yinchao on 16/10/25.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSMainCooperationViewController.h"
#import "NSCooperationViewController.h"
#import "NSMyCooperationViewController.h"
#import "NSCollectionCooperationViewController.h"
#import "NSPublicLyricCooperationViewController.h"
#import "NSInvitationListViewController.h"
#import "NSCooperationMessageViewController.h"
#import "NSLoginViewController.h"
@interface NSMainCooperationViewController ()<UIScrollViewDelegate>
{
    
    UIView * _lineView;
    NSMyCooperationViewController *myCooperationVC;
    NSCollectionCooperationViewController *collectionCooperationVC;
}
@property (nonatomic, strong) UIButton * cooperationBtn;
@property (nonatomic, strong) UIButton * myCooperation;
@property (nonatomic, strong) UIButton * collectionBtn;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIImageView *noLoginImg;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@end

@implementation NSMainCooperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMainCooperationViewController];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupContentViewControllers) name:@"setupCooperation" object:nil];
    if (JUserID) {
        [self setupContentViewControllers];
        
    }
}

- (void)setupMainCooperationViewController {
        
    self.view.backgroundColor = KBackgroundColor;
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(testClick)];
    
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/2-90, 0, 180, 44)];
    navigationView.backgroundColor = [UIColor clearColor];
    self.cooperationBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.cooperationBtn.frame = CGRectMake(0, 0, 60, 41);
    [self.cooperationBtn setTitle:@"合作" forState:UIControlStateNormal];
    [self.cooperationBtn addTarget:self action:@selector(cooperationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:self.cooperationBtn];
    
    self.myCooperation = [UIButton buttonWithType:UIButtonTypeSystem];
    _myCooperation.frame = CGRectMake(60, 0, 60, 41);
    [self.myCooperation setTitle:@"我的" forState:UIControlStateNormal];
    [self.myCooperation addTarget:self action:@selector(myCooperationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:self.myCooperation];
    self.navigationItem.titleView = navigationView;
    
    self.collectionBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _collectionBtn.frame = CGRectMake(120, 0, 60, 41);
    [self.collectionBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [self.collectionBtn addTarget:self action:@selector(collectionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:self.collectionBtn];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 41, 60, 3)];
    
    _lineView.backgroundColor = [UIColor hexColorFloat:@"ffd705"];
    
    [navigationView addSubview:_lineView];
    
    
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.height - 64)];
    
    self.contentScrollView.contentSize = CGSizeMake(ScreenWidth * 3, 0);
    
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    
    self.contentScrollView.scrollEnabled = NO;
    
    self.contentScrollView.pagingEnabled = YES;
    
    self.contentScrollView.delegate = self;
    
    [self.view addSubview:self.contentScrollView];
    
    //合作
    NSCooperationViewController *cooperationVC = [[NSCooperationViewController alloc] init];
    
    cooperationVC.view.frame = CGRectMake(0, 0, ScreenWidth, self.contentScrollView.height);
    
    [self addChildViewController:cooperationVC];
    
    [self.contentScrollView  addSubview:cooperationVC.view];
    
    UIButton *addCooperation = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setImage:[UIImage imageNamed:@"2.3_addCooperation"] forState:UIControlStateNormal];
        
        [btn sizeToFit];
        
    } action:^(UIButton *btn) {
        if (JUserID) {
            NSPublicLyricCooperationViewController *publicLyricCooperationVC = [[NSPublicLyricCooperationViewController alloc] init];
            [self.navigationController pushViewController:publicLyricCooperationVC animated:YES];
        } else {
            [self userLogin];
        }
        
    }];
    [self.view addSubview:addCooperation];
    
    [addCooperation mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self.view.mas_centerX);
        
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}
- (void)setupContentViewControllers {
    
    //我的
    myCooperationVC = [[NSMyCooperationViewController alloc] init];
    
    myCooperationVC.view.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, self.contentScrollView.height);
    
    [self addChildViewController:myCooperationVC];
    
    [self.contentScrollView addSubview:myCooperationVC.view];
    
    //收藏
    
    collectionCooperationVC = [[NSCollectionCooperationViewController alloc] init];
    
    collectionCooperationVC.view.frame = CGRectMake(ScreenWidth * 2, 0, ScreenWidth, self.contentScrollView.height);
    
    [self addChildViewController:collectionCooperationVC];
    
    [self.contentScrollView addSubview:collectionCooperationVC.view];
    
}
#pragma mark - 合作、我的、收藏
- (void)cooperationBtnClick:(UIButton *)sender {
    
    [self.loginBtn removeFromSuperview];
    
    [self.contentScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _lineView.x = sender.x;
    }];
}
- (void)myCooperationBtnClick:(UIButton *)sender {
    [self.contentScrollView setContentOffset:CGPointMake(ScreenWidth, 0) animated:YES];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _lineView.x = sender.x;
    }];
    if (!JUserID) {
        self.noLoginImg.frame = CGRectMake(3*ScreenWidth/2 - 105, 60, 210, 140);
        
        [self.contentScrollView addSubview:self.noLoginImg];
        
        self.loginBtn.frame = CGRectMake(3*ScreenWidth/2-30, 220, 60, 30);
        [self.contentScrollView addSubview:self.loginBtn];
    }

}
- (void)collectionBtnClick:(UIButton *)sender {
    [self.contentScrollView setContentOffset:CGPointMake(ScreenWidth * 2, 0) animated:YES];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _lineView.x = sender.x;
    }];
    if (!JUserID) {
        self.noLoginImg.frame = CGRectMake(5*ScreenWidth/2 - 105, 60, 210, 140);
        
        [self.contentScrollView addSubview:self.noLoginImg];
        
        self.loginBtn.frame = CGRectMake(5*ScreenWidth/2-30, 220, 60, 30);
        [self.contentScrollView addSubview:self.loginBtn];
        
    }
}
- (void)userLogin {
    NSLoginViewController *login = [[NSLoginViewController alloc] init];
    login.lonigBlock = ^(BOOL isReset) {
        [self.loginBtn removeFromSuperview];
        [self.noLoginImg removeFromSuperview];
        [self setupContentViewControllers];
    };
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
    nav.navigationBar.hidden = YES;
    [self presentViewController:nav animated:YES completion:nil];
}
#pragma mark - UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    
//    _lineView.x = _cooperationBtn.x + scrollView.contentOffset.x / ScreenWidth * _lineView.width;
//    
//}
- (void)testClick {
//    NSCooperationMessageViewController *cooperationMessageVC = [[NSCooperationMessageViewController alloc] init];
//    [self.navigationController pushViewController:cooperationMessageVC animated:YES];
//    NSInvitationListViewController *invitationVC = [[ NSInvitationListViewController alloc] init];
//    [self.navigationController pushViewController:invitationVC animated:YES];
}
- (UIButton *)loginBtn {
    if (!_loginBtn) {
        self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.backgroundColor = [UIColor hexColorFloat:@"ffd705"];
        _loginBtn.clipsToBounds = YES;
        _loginBtn.layer.cornerRadius = 5;
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginBtn addTarget:self action:@selector(userLogin) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _loginBtn;
}
- (UIImageView *)noLoginImg {
    if (!_noLoginImg) {
        self.noLoginImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.3_noLogin_placeholder" ]];
        
    }
    return _noLoginImg;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
