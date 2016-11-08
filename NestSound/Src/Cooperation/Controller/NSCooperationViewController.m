//
//  NSCooperationViewController.m
//  NestSound
//
//  Created by yinchao on 16/10/24.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSCooperationViewController.h"
#import "NSCooperationDetailViewController.h"
#import "NSInvitationListTableViewCell.h"
#import "NSCooperationListTableViewCell.h"
#import "NSCooperationMoreCommentCell.h"
#import "NSLabelTableViewCell.h"
#import "NSCooperationListModel.h"
#import "NSUserPageViewController.h"
#import "NSAccompanyListViewController.h"
#import "NSCooperationDetailModel.h"
@interface NSCooperationViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,NSInvitationListTableViewCellDelegate,NSTipViewDelegate>
{
    UIImageView *emptyImgView;
    UITableView *cooperationTab;
    NSTipView *_tipView;
    UIView *_maskView;
    int currentPage;
    int cooperationId;
}

@property (nonatomic,strong) NSMutableArray *cooperationArr;
@end

@implementation NSCooperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCooperationViewController];
    [self fetchCooperationListWithIsLoadingMore:NO];
}
#pragma mark - Network Requests and Data Handling
- (void)fetchCooperationListWithIsLoadingMore:(BOOL)isLoadingMore {
    self.requestType = NO;
    if (!isLoadingMore) {
        currentPage = 1;
//        self.requestParams = @{@"page":@(currentPage),kIsLoadingMore:@(NO)};
    }else{
        ++currentPage;
//        self.requestParams = @{@"page":@(currentPage),kIsLoadingMore:@(YES)};
    }
    self.requestParams = @{@"page":@(currentPage),kIsLoadingMore:@(isLoadingMore)};
    self.requestURL = cooperationListUrl;
    
}
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr {
    if (requestErr) {
        
    } else {
        if ([operation.urlTag isEqualToString:cooperationListUrl]) {
            NSCooperationListModel *model = (NSCooperationListModel *)parserObject;
            if (!operation.isLoadingMore) {
                [cooperationTab.pullToRefreshView stopAnimating];
                self.cooperationArr = [NSMutableArray arrayWithArray:model.mainCooperationList];
                
            }else{
                [cooperationTab.infiniteScrollingView stopAnimating];
                [self.cooperationArr addObjectsFromArray:model.mainCooperationList];
            }
            [cooperationTab reloadData];
        } else if ([operation.urlTag isEqualToString:coCooperateActionUrl]){
            CoWorkModel *workModel = (CoWorkModel *)parserObject;
            NSAccompanyListViewController *accompanyController = [[NSAccompanyListViewController alloc] init];
            workModel.did = [NSString stringWithFormat:@"%d",cooperationId];
            accompanyController.coWorkModel = workModel;
            [self.navigationController pushViewController:accompanyController animated:YES];
            
            
            
            
        }
    }
}
- (void)setupCooperationViewController {
    
    //合作
    cooperationTab = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    
    cooperationTab.delegate = self;
    
    cooperationTab.dataSource = self;
    
//    cooperationTab.rowHeight = 80;
    
//    cooperationTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    cooperationTab.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    
    //    [musicTableView registerClass:[NSNewMusicTableViewCell class] forCellReuseIdentifier:musicCellIdentify];
    self.view = cooperationTab;
    
//    UIView *noLineView = [[UIView alloc] initWithFrame:CGRectZero];
//    
//    cooperationTab.tableFooterView = noLineView;
    
    WS(Wself);
    //refresh
    [cooperationTab addDDPullToRefreshWithActionHandler:^{
        if (!Wself) {
            return ;
        }else{
            [Wself fetchCooperationListWithIsLoadingMore:NO];
        }
    }];
    //loadingMore
    [cooperationTab addDDInfiniteScrollingWithActionHandler:^{
        if (!Wself) {
            return ;
        }
        [Wself fetchCooperationListWithIsLoadingMore:YES];
    }];
    emptyImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.0_noMyData"]];
    
    emptyImgView.hidden = YES;
    
    emptyImgView.centerX = ScreenWidth/2;
    
    emptyImgView.y = 100;
    
    [cooperationTab addSubview:emptyImgView];
    
    
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.cooperationArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MainCooperationListModel *model = self.cooperationArr[section];
    NSArray *commentArr = [NSArray arrayWithArray:model.cooperationCommentList];
    return commentArr.count > 3 ? 6 : 3 + commentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainCooperationListModel *mainModel = self.cooperationArr[indexPath.section];
    NSArray *commentArr = [NSArray arrayWithArray:mainModel.cooperationCommentList];
    CooperationModel *cooperationModel = mainModel.cooperation;
    NSInteger commentNum;
    if (commentArr.count>3) {
        commentNum = 6;
    } else {
        commentNum = 3 + commentArr.count;
    }
    if (indexPath.row == 0) {
        static NSString *ID = @"TopCell";
        
        NSInvitationListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (cell == nil) {
            
            cell = [[NSInvitationListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            cell.delegate = self;
        }
        
        cell.cooperationModel = cooperationModel;
        cell.cooperationUser = mainModel.cooperationUser;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else if (indexPath.row == 1) {
        static NSString *ID = @"midCell";
        
        NSCooperationListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (cell == nil) {
            
            cell = [[NSCooperationListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            
        }
        cell.cooperationModel = cooperationModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else if (indexPath.row == commentNum-1) {
        static NSString * moreCommentCellIdenfity = @"moreCommentCell";
        NSCooperationMoreCommentCell * moreCommentCell = [tableView dequeueReusableCellWithIdentifier:moreCommentCellIdenfity];
        if (!moreCommentCell) {
            moreCommentCell = [[NSCooperationMoreCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:moreCommentCellIdenfity];
            moreCommentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        moreCommentCell.cooperationModel = cooperationModel;
        return moreCommentCell;
    } else {
        
        static NSString * commentCellIdenfity = @"bottomCell";
        NSLabelTableViewCell * bottomCell = [tableView dequeueReusableCellWithIdentifier:commentCellIdenfity];
        if (!bottomCell) {
            bottomCell = [[NSLabelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentCellIdenfity];
            bottomCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        bottomCell.commentModel = commentArr[indexPath.row-2];
        return bottomCell;
    }
    
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MainCooperationListModel *mainModel = self.cooperationArr[indexPath.section];
    CooperationModel *cooperationModel = mainModel.cooperation;
    NSCooperationDetailViewController *cooperationDetailVC = [[NSCooperationDetailViewController alloc] init];
    if (cooperationModel.uId == [JUserID intValue]) {
        cooperationDetailVC.isMyCoWork = YES;
    }
    cooperationDetailVC.detailTitle = cooperationModel.cooperationTitle;
    cooperationDetailVC.cooperationId = cooperationModel.cooperationId;
    [self.navigationController pushViewController:cooperationDetailVC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        return 60;
    } else if (indexPath.row == 1) {
        
        NSCooperationListTableViewCell *cell = (NSCooperationListTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.lyricLabelMaxY;
    } else {
        return 30;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1.5;
}
#pragma mark - NSInvitationListTableViewCellDelegate
- (void)invitationBtnClickWith:(NSInvitationListTableViewCell *)cell {
    NSIndexPath *indexPath = [cooperationTab indexPathForCell:cell];
    MainCooperationListModel *mainModel = self.cooperationArr[indexPath.section];
    CooperationModel *cooperationModel = mainModel.cooperation;
    cooperationId = cooperationModel.cooperationId;
    
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    
    _maskView.backgroundColor = [UIColor lightGrayColor];
    
    _maskView.alpha = 0.5;
    
    [self.navigationController.view addSubview:_maskView
     ];
    
    CGFloat padding = ScreenWidth *60/375.0;
    CGFloat width = (ScreenWidth - padding * 2);
    CGFloat height = width * 338/256.0f;
    
    
    _tipView = [[NSTipView alloc] initWithFrame:CGRectMake(padding, (ScreenHeight - height)/2.0f, width, height)];
    
    _tipView.delegate = self;
    
    _tipView.imgName = @"2.3_tipImg_cooperate";
    
    _tipView.tipText = [NSString stringWithFormat:@"1.需求结束前,您的作品无法删除\n2.如被采纳,删除该作品仅对自己有效"];
    [self.navigationController.view addSubview:_tipView];
    
    CAKeyframeAnimation *keyFrame = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    keyFrame.values = @[@(0.2), @(0.4), @(0.6), @(0.8), @(1.0), @(1.2), @(1.0)];
    keyFrame.duration = 0.3;
    keyFrame.removedOnCompletion = NO;
    [_tipView.layer addAnimation:keyFrame forKey:nil];
    
}
- (void)iconBtnClickWith:(NSInvitationListTableViewCell *)cell {
    
    NSIndexPath *indexPath = [cooperationTab indexPathForCell:cell];
    MainCooperationListModel *mainModel = self.cooperationArr[indexPath.section];
    CooperationModel *cooperationModel = mainModel.cooperation;
    
    NSUserPageViewController *pageVC = [[NSUserPageViewController alloc] initWithUserID:[NSString stringWithFormat:@"%ld",cooperationModel.uId]];
    

    pageVC.who = (cooperationModel.uId == [JUserID integerValue]) ? Myself : Other;
    
    [self.navigationController pushViewController:pageVC animated:YES];
}
#pragma mark - NSTipViewDelegate

- (void)cancelBtnClick {
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _tipView.transform = CGAffineTransformScale(_tipView.transform, 0.1, 0.1);
        
    } completion:^(BOOL finished) {
        
        [_maskView removeFromSuperview];
        
        [_tipView removeFromSuperview];
    }];
}
- (void)ensureBtnClick {
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _tipView.transform = CGAffineTransformScale(_tipView.transform, 0.1, 0.1);
        
    } completion:^(BOOL finished) {
        
        [_maskView removeFromSuperview];
        
        [_tipView removeFromSuperview];
        
        self.requestType = NO;
        
        self.requestParams = @{@"did":@(cooperationId),
                               @"uid":JUserID,@"token":LoginToken};
        
        self.requestURL = coCooperateActionUrl;
    }];
}

- (NSMutableArray *)cooperationArr {
    if (!_cooperationArr) {
        self.cooperationArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _cooperationArr;
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
