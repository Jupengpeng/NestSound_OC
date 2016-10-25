//
//  NSCooperationViewController.m
//  NestSound
//
//  Created by yinchao on 16/10/24.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSCooperationViewController.h"

@interface NSCooperationViewController ()<NSTipViewDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSTipView *tipView;
    UIView *maskView;
    UIImageView *emptyOneImage;
    UIImageView *emptyTwoImage;
    UIImageView *emptyThreeImage;
    UITableView *cooperationTab;
    UITableView *myCooperationTab;
    UITableView *collectionTab;
}
@property (nonatomic, strong) UIButton * cooperationBtn;
@property (nonatomic, strong) UIButton * myCooperation;
@property (nonatomic, strong) UIButton * collectionBtn;
@property (nonatomic, strong) UIView   * lineView;
@property (nonatomic, strong) UIScrollView *contentScrollView;

@end

@implementation NSCooperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureCooperationViewUI];
}
- (void)configureCooperationViewUI {
    
    self.view.backgroundColor = KBackgroundColor;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(testClick)];
    
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    navigationView.backgroundColor = [UIColor clearColor];
    self.cooperationBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.cooperationBtn setTitle:@"合作" forState:UIControlStateNormal];
//    [self.cooperationBtn addTarget:self action:@selector(handleProductBtn:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:self.cooperationBtn];
    
    self.myCooperation = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.myCooperation setTitle:@"我的" forState:UIControlStateNormal];
//    [self.myCooperation addTarget:self action:@selector(handleGemstoneBtn:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:self.myCooperation];
    self.navigationItem.titleView = navigationView;

    self.collectionBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.collectionBtn setTitle:@"收藏" forState:UIControlStateNormal];
//    [self.collectionBtn addTarget:self action:@selector(handleGemstoneBtn:) forControlEvents:UIControlEventTouchUpInside];
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
    
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, self.view.height - 64)];
    
    self.contentScrollView.contentSize = CGSizeMake(ScreenWidth * 3, 0);
    
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    
    self.contentScrollView.pagingEnabled = YES;
    
    self.contentScrollView.delegate = self;
    
    [self.view addSubview:self.contentScrollView];
    
    //合作
    cooperationTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(self.contentScrollView.frame)) style:UITableViewStylePlain];
    
//    cooperationTab.delegate = self;
//    
//    cooperationTab.dataSource = self;
    
    cooperationTab.rowHeight = 80;
    
    cooperationTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    cooperationTab.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    
//    [musicTableView registerClass:[NSNewMusicTableViewCell class] forCellReuseIdentifier:musicCellIdentify];
    
    [self.contentScrollView addSubview:cooperationTab];
    
    emptyOneImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.0_noMyData"]];
    
//    emptyOneImage.hidden = YES;
    
    emptyOneImage.centerX = ScreenWidth/2;
    
    emptyOneImage.y = 100;
    
    [self.contentScrollView addSubview:emptyOneImage];
    
    WS(Wself);
    //refresh
    [cooperationTab addDDPullToRefreshWithActionHandler:^{
        if (!Wself) {
            return ;
        }else{
//            [Wself fetchDataWithType:1 andIsLoadingMore:NO];
        }
    }];
    //loadingMore
    [cooperationTab addDDInfiniteScrollingWithActionHandler:^{
        if (!Wself) {
            return ;
        }
//        [Wself fetchDataWithType:1 andIsLoadingMore:YES];
    }];
    //我的
    myCooperationTab = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, CGRectGetHeight(self.contentScrollView.frame)) style:UITableViewStylePlain];
    
//    myCooperationTab.delegate = self;
//    
//    myCooperationTab.dataSource= self;
    
    myCooperationTab.rowHeight = 80;
    
    myCooperationTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    myCooperationTab.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    
//    [lyricTableView registerClass:[NSNewMusicTableViewCell class] forCellReuseIdentifier:lyricCellIdentify];
    
    [self.contentScrollView addSubview:myCooperationTab];
    
    emptyTwoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.0_noMyData"]];
    
//    emptyTwoImage.hidden = YES;
    
    emptyTwoImage.centerX = 3*ScreenWidth/2;
    
    emptyTwoImage.y = 100;
    
    [self.contentScrollView addSubview:emptyTwoImage];
    
    //refresh
    [myCooperationTab addDDPullToRefreshWithActionHandler:^{
        if (!Wself) {
            return ;
        }else{
//            [Wself fetchDataWithType:2 andIsLoadingMore:NO];
        }
    }];
    //loadingMore
    [myCooperationTab addDDInfiniteScrollingWithActionHandler:^{
        if (!Wself) {
            return ;
        }
//        [Wself fetchDataWithType:2 andIsLoadingMore:YES];
    }];
    //收藏
    
    collectionTab = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, CGRectGetHeight(self.contentScrollView.frame)) style:UITableViewStylePlain];
    
//    collectionTab.dataSource = self;
//    
//    collectionTab.delegate = self;
    
    collectionTab.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    
//    [collectionTab registerClass:[NSSearchUserCollectionViewCell class] forCellWithReuseIdentifier:userCellIdentify];
    
    [self.contentScrollView addSubview:collectionTab];
    
    //refresh
    [collectionTab addDDPullToRefreshWithActionHandler:^{
        if (!Wself) {
            return ;
        }else{
//            [Wself fetchDataWithType:3 andIsLoadingMore:NO];
        }
    }];
    //loadingMore
    [collectionTab addDDInfiniteScrollingWithActionHandler:^{
        if (!Wself) {
            return ;
        }
//        [Wself fetchDataWithType:3 andIsLoadingMore:YES];
    }];
    //    [self setupContent];
    emptyThreeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.0_noMyData"]];
    
//    emptyThreeImage.hidden = YES;
    
    emptyThreeImage.centerX = 5*ScreenWidth/2;
    
    emptyThreeImage.y = 100;
    
    [self.contentScrollView addSubview:emptyThreeImage];
}
//#pragma mark - UITableViewDataSource
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (tableView == cooperationTab) {
//        return 1;
//    } else if (tableView == myCooperationTab) {
//        return 2;
//    } else {
//        return 3;
//    }
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (tableView == cooperationTab) {
//        
//        return nil;
//    } else  if (tableView == myCooperationTab){
//        
//        return nil;
//    } else {
//        return nil;
//    }
//    
//}
- (void)testClick {
    
    maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    
    maskView.backgroundColor = [UIColor lightGrayColor];
    
    maskView.alpha = 0.5;
    
    [self.navigationController.view addSubview:maskView];
    
    tipView = [[NSTipView alloc] init];
    tipView.delegate = self;
    tipView.imgName = @"2.0_backgroundImage";
    tipView.tipText = @"采纳后，您的合作需求将会结束并标示为“成功”，不再接受其他人的合作";
    [self.navigationController.view addSubview:tipView];
    
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view.mas_top).offset(80);
        make.left.equalTo(self.view.mas_left).offset(60);
        make.right.equalTo(self.view.mas_right).offset(-60);
        make.height.mas_equalTo(338);
        
    }];
    CAKeyframeAnimation *keyFrame = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    keyFrame.values = @[@(0.2), @(0.4), @(0.6), @(0.8), @(1.0), @(1.2), @(1.0)];
    keyFrame.duration = 0.4;
    keyFrame.removedOnCompletion = NO;
    [tipView.layer addAnimation:keyFrame forKey:nil];
    
}
#pragma mark - NSTipViewDelegate
- (void)cancelBtnClick {
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        tipView.transform = CGAffineTransformScale(tipView.transform, 0.1, 0.1);
        
    } completion:^(BOOL finished) {
        
        [maskView removeFromSuperview];
        
        [tipView removeFromSuperview];
    }];
}
- (void)ensureBtnClick {
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        tipView.transform = CGAffineTransformScale(tipView.transform, 0.1, 0.1);
        
    } completion:^(BOOL finished) {
        
        [maskView removeFromSuperview];
        
        [tipView removeFromSuperview];
    }];
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
