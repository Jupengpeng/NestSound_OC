//
//  NSMyCooperationViewController.m
//  NestSound
//
//  Created by yinchao on 16/10/25.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSMyCooperationViewController.h"
#import "NSMyCooperationTableViewCell.h"
#import "NSMyCooperationListModel.h"
#import "NSLoginViewController.h"
@interface NSMyCooperationViewController ()<UITableViewDataSource,UITableViewDelegate,NSTipViewDelegate>
{
    UITableView *myCooperationTab;
    UIImageView *emptyImage;
    NSTipView *tipView;
    UIView *maskView;
    NSIndexPath *index;
    int currentPage;
}
@property (nonatomic,strong) NSMutableArray *myCooperationArr;
@end

@implementation NSMyCooperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)viewWillAppear:(BOOL)animated {
    if (JUserID) {
        [self setupMyCooperationViewController];
        [self fetchMyCooperationListWithIsLoadingMore:NO];
    } else {
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            loginBtn.centerX = self.view.centerX;
            loginBtn.y = ScreenHeight/3;
            loginBtn.width = 60;
            loginBtn.height = 30;
            loginBtn.backgroundColor = [UIColor hexColorFloat:@"ffd705"];
            [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
            [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        } action:^(UIButton *btn) {
//            NSLoginViewController *login = [[NSLoginViewController alloc] init];
//            
//            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
//            nav.navigationBar.hidden = YES;
//            [self presentViewController:nav animated:YES completion:nil];
//        }];
        [self.view addSubview:loginBtn];
    }
}
#pragma mark - Network Requests and Data Handling
- (void)fetchMyCooperationListWithIsLoadingMore:(BOOL)isLoadingMore {
    if (!isLoadingMore) {
        self.requestType = NO;
        currentPage = 1;
        self.requestParams = @{@"page":@(currentPage),@"uid":JUserID,kIsLoadingMore:@(NO),@"token":LoginToken};
    }else{
        ++currentPage;
        self.requestParams = @{@"page":@(currentPage),@"uid":JUserID,kIsLoadingMore:@(YES),@"token":LoginToken};
    }
    
    self.requestURL = myCooperationListUrl;
    
}
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr {
    if (requestErr) {
        
    } else {
        if ([operation.urlTag isEqualToString:myCooperationListUrl]) {
            NSMyCooperationListModel *model = (NSMyCooperationListModel *)parserObject;
            if (!operation.isLoadingMore) {
                [myCooperationTab.pullToRefreshView stopAnimating];
                self.myCooperationArr = [NSMutableArray arrayWithArray:model.myCooperationList];
                
            }else{
                [myCooperationTab.infiniteScrollingView stopAnimating];
                [self.myCooperationArr addObjectsFromArray:model.myCooperationList];
            }
            
            [myCooperationTab reloadData];
        }
    }
}
- (void)setupMyCooperationViewController {
    _myCooperationArr = [NSMutableArray arrayWithArray:@[@"1",@"2",@"3",@"4",@"5"]];
    //我的
    myCooperationTab = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    
    myCooperationTab.delegate = self;
    
    myCooperationTab.dataSource= self;
    
    myCooperationTab.rowHeight = 60;
        
    myCooperationTab.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    
    //    [lyricTableView registerClass:[NSNewMusicTableViewCell class] forCellReuseIdentifier:lyricCellIdentify];
    self.view = myCooperationTab;
//    [self.contentScrollView addSubview:myCooperationTab];
    
   
    WS(wSelf);
    //refresh
    [myCooperationTab addDDPullToRefreshWithActionHandler:^{
        if (!wSelf) {
            return ;
        }else{
//                        [Wself fetchDataWithType:2 andIsLoadingMore:NO];
        }
    }];
    //loadingMore
    [myCooperationTab addDDInfiniteScrollingWithActionHandler:^{
        if (!wSelf) {
            return ;
        }
        //        [Wself fetchDataWithType:2 andIsLoadingMore:YES];
    }];
    
    emptyImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.0_noMyData"]];
    
    emptyImage.hidden = YES;
    
    emptyImage.centerX = ScreenWidth/2;
    
    emptyImage.y = 100;
    
    [myCooperationTab addSubview:emptyImage];
}
#pragma mark - UITableDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _myCooperationArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"myCooperationCell";
    
    NSMyCooperationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[NSMyCooperationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        
        maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        
        maskView.backgroundColor = [UIColor lightGrayColor];
        
        maskView.alpha = 0.5;
        
        [self.view addSubview:maskView];
        
        tipView = [[NSTipView alloc] initWithFrame:CGRectMake(60, 80, ScreenWidth-120, 338)];
        
        tipView.delegate = self;
        
        tipView.imgName = @"2.0_backgroundImage";
        
        tipView.tipText = @"采纳后，您的合作需求将会结束并标示为“成功”，不再接受其他人的合作";
        [self.view addSubview:tipView];
        
        
//        [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.top.equalTo(self.view.mas_top).offset(80);
//            make.left.equalTo(self.view.mas_left).offset(60);
//            make.right.equalTo(self.view.mas_right).offset(-60);
//            make.height.mas_equalTo(338);
//            
//        }];
        CAKeyframeAnimation *keyFrame = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        keyFrame.values = @[@(0.2), @(0.4), @(0.6), @(0.8), @(1.0), @(1.2), @(1.0)];
        keyFrame.duration = 0.3;
        keyFrame.removedOnCompletion = NO;
        [tipView.layer addAnimation:keyFrame forKey:nil];
        index = indexPath;
        
    }
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
        
        [_myCooperationArr removeObjectAtIndex:index.row];
        
        [myCooperationTab deleteRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationLeft];
        
    }];
}
- (NSMutableArray *)myCooperationArr {
    if (!_myCooperationArr) {
        self.myCooperationArr = [NSMutableArray arrayWithCapacity:5];
    }
    return _myCooperationArr;
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
