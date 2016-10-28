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
@interface NSMainCooperationViewController ()<UIScrollViewDelegate>
{
    NSTipView *tipView;
    UIView *maskView;
}
@property (nonatomic, strong) UIButton * cooperationBtn;
@property (nonatomic, strong) UIButton * myCooperation;
@property (nonatomic, strong) UIButton * collectionBtn;
@property (nonatomic, strong) UIView   * lineView;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@end

@implementation NSMainCooperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMainCooperationViewController];
}
- (void)setupMainCooperationViewController {
        
    self.view.backgroundColor = KBackgroundColor;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(testClick)];
    
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    navigationView.backgroundColor = [UIColor clearColor];
    self.cooperationBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.cooperationBtn setTitle:@"合作" forState:UIControlStateNormal];
    [self.cooperationBtn addTarget:self action:@selector(cooperationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:self.cooperationBtn];
    
    self.myCooperation = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.myCooperation setTitle:@"我的" forState:UIControlStateNormal];
    [self.myCooperation addTarget:self action:@selector(myCooperationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:self.myCooperation];
    self.navigationItem.titleView = navigationView;
    
    self.collectionBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.collectionBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [self.collectionBtn addTarget:self action:@selector(collectionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:self.collectionBtn];
    
    [self.cooperationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.myCooperation.mas_left).offset(0);
        make.bottom.equalTo(navigationView.mas_bottom).offset(-3);
        make.size.mas_equalTo(CGSizeMake(60, 41));
    }];
    
    [self.myCooperation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(navigationView.mas_bottom).offset(-3);
        make.centerX.equalTo(navigationView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(60, 41));
    }];
    
    [self.collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.myCooperation.mas_right).offset(0);
        make.bottom.equalTo(navigationView.mas_bottom).offset(-3);
        make.size.mas_equalTo(CGSizeMake(60, 41));
    }];
    
    _lineView = [[UIView alloc] init];
    
    _lineView.backgroundColor = [UIColor hexColorFloat:@"ffd705"];
    
    [navigationView addSubview:_lineView];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.cooperationBtn).offset(0);
        make.bottom.equalTo(navigationView.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(60, 3));
    }];
    
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.height - 64)];
    
    self.contentScrollView.contentSize = CGSizeMake(ScreenWidth * 3, 0);
    
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    
    self.contentScrollView.scrollEnabled = NO;
    
    self.contentScrollView.pagingEnabled = YES;
    
    self.contentScrollView.delegate = self;
    
    [self.view addSubview:self.contentScrollView];
    
    [self setupContentViewControllers];
    
    UIButton *addCooperation = [UIButton buttonWithType:UIButtonTypeCustom configure:^(UIButton *btn) {
        
        [btn setImage:[UIImage imageNamed:@"2.3_addCooperation"] forState:UIControlStateNormal];
        
        [btn sizeToFit];
        
    } action:^(UIButton *btn) {
        
        NSPublicLyricCooperationViewController *publicLyricCooperationVC = [[NSPublicLyricCooperationViewController alloc] init];
        [self.navigationController pushViewController:publicLyricCooperationVC animated:YES];
    }];
    [self.view addSubview:addCooperation];
    
    [addCooperation mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self.view.mas_centerX);
        
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}
- (void)setupContentViewControllers {
    //活动
    NSCooperationViewController *cooperationVC = [[NSCooperationViewController alloc] init];
    
    cooperationVC.view.frame = CGRectMake(0, 0, ScreenWidth, self.contentScrollView.height);
    
    [self addChildViewController:cooperationVC];
    
    [self.contentScrollView  addSubview:cooperationVC.view];
    
    //我的
    NSMyCooperationViewController *myCooperationVC = [[NSMyCooperationViewController alloc] init];
    
    myCooperationVC.view.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, self.contentScrollView.height);
    
    [self addChildViewController:myCooperationVC];
    
    [self.contentScrollView addSubview:myCooperationVC.view];
    
    //收藏
    
    NSCollectionCooperationViewController *collectionCooperationVC = [[NSCollectionCooperationViewController alloc] init];
    
    collectionCooperationVC.view.frame = CGRectMake(ScreenWidth * 2, 0, ScreenWidth, self.contentScrollView.height);
    
    [self addChildViewController:collectionCooperationVC];
    
    [self.contentScrollView addSubview:collectionCooperationVC.view];
    
}
#pragma mark - 合作、我的、收藏
- (void)cooperationBtnClick:(UIButton *)sender {
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
}
- (void)collectionBtnClick:(UIButton *)sender {
    [self.contentScrollView setContentOffset:CGPointMake(ScreenWidth * 2, 0) animated:YES];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _lineView.x = sender.x;
    }];
}
#pragma mark - UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    
//    _lineView.x = _cooperationBtn.x + scrollView.contentOffset.x / ScreenWidth * _lineView.width;
//    
//}
- (void)testClick {
    
    NSInvitationListViewController *invitationVC = [[ NSInvitationListViewController alloc] init];
    [self.navigationController pushViewController:invitationVC animated:YES];
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
