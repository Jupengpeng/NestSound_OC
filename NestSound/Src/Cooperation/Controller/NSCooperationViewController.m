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
@interface NSCooperationViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,NSInvitationListTableViewCellDelegate>
{
    UIImageView *emptyImgView;
    UITableView *cooperationTab;
    int currentPage;
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
    cooperationDetailVC.detailTitle = mainModel.cooperationUser.nickName;
    cooperationDetailVC.cooperationId = cooperationModel.cooperationId;
    [self.navigationController pushViewController:cooperationDetailVC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        return 60;
    } else if (indexPath.row == 1) {
        return 170;
    } else {
        return 30;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1.5;
}
#pragma mark - NSInvitationListTableViewCellDelegate
- (void)invitationBtnClickWith:(NSInvitationListTableViewCell *)cell {
    self.requestType = NO;
    self.requestParams = @{@"did":@"",@"uid":JUserID,@"itemid":@""};
}
- (void)iconBtnClickWith:(NSInvitationListTableViewCell *)cell {
    
    NSIndexPath *indexPath = [cooperationTab indexPathForCell:cell];
    MainCooperationListModel *mainModel = self.cooperationArr[indexPath.section];
    CooperationModel *cooperationModel = mainModel.cooperation;
    
    NSUserPageViewController *pageVC = [[NSUserPageViewController alloc] initWithUserID:[NSString stringWithFormat:@"%ld",cooperationModel.uId]];
    
    pageVC.who = Other;
    
    [self.navigationController pushViewController:pageVC animated:YES];
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
