//
//  NSMusicianListViewController.m
//  NestSound
//
//  Created by yinchao on 2016/11/21.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSMusicianListViewController.h"
#import "NSMusicianListCell.h"
#import "NSInvitationListModel.h"
@interface NSMusicianListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *musicianTab;
    int currentPage;
    NSString *urlTag;
}
@property (nonatomic,strong) NSMutableArray *musicianArr;
@end

@implementation NSMusicianListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchMusicianListWithIsLoadingMore:NO];
    [self setupMusicianListUI];
}
#pragma mark - Network Requests and Data Handling
- (void)fetchMusicianListWithIsLoadingMore:(BOOL)isLoadingMore {
    
    self.requestType = YES;
    if (!isLoadingMore) {
        currentPage = 1;
        
    }else{
        ++currentPage;
        
    }
    self.requestParams = @{kIsLoadingMore :@(isLoadingMore)};
    NSDictionary *dic = nil;
    dic = @{@"page":@(currentPage)};
    NSString *str = [NSTool encrytWithDic:dic];
    urlTag = [musiciansListUrl stringByAppendingString:str];
    self.requestURL = urlTag;
}
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr {
    if (requestErr) {
        
    } else {
        if ([operation.urlTag isEqualToString:urlTag]) {
            NSInvitationListModel *invitationModel = (NSInvitationListModel *)parserObject;
            if (!operation.isLoadingMore) {
                [musicianTab.pullToRefreshView stopAnimating];
                self.musicianArr = [NSMutableArray arrayWithArray:invitationModel.invitationList];
            }else{
                [musicianTab.infiniteScrollingView stopAnimating];
                [self.musicianArr addObjectsFromArray:invitationModel.invitationList];
            }
            [musicianTab reloadData];
        }
    }
}
- (void)setupMusicianListUI {
    
    self.title = @"音乐人列表";
    
    self.view.backgroundColor = KBackgroundColor;
    
    musicianTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
    
    musicianTab.dataSource = self;
    
    musicianTab.delegate = self;
    
    musicianTab.rowHeight = 80;
    
    [self.view addSubview:musicianTab];
    
    UIView *noLineView = [[UIView alloc] initWithFrame:CGRectZero];
    
    musicianTab.tableFooterView = noLineView;
    
    WS(wSelf);
    //refresh
    [musicianTab addDDPullToRefreshWithActionHandler:^{
        if (!wSelf) {
            return ;
        }else{
            [wSelf fetchMusicianListWithIsLoadingMore:NO];
        }
    }];
    //loadingMore
    [musicianTab addDDInfiniteScrollingWithActionHandler:^{
        if (!wSelf) {
            return ;
        }
        [wSelf fetchMusicianListWithIsLoadingMore:YES];
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.musicianArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"musicListCell";
    
    NSMusicianListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    //
    if (cell == nil) {
        
        cell = [[NSMusicianListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        //        cell.delegate = self;
    }
    InvitationModel *model = self.musicianArr[indexPath.row];
    cell.musicianModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

#pragma mark - NSInvitationListTableViewCellDelegate
//- (void)invitationBtnClickWith:(NSInvitationListTableViewCell *)cell {
//
//    index = [invitationTab indexPathForCell:cell];
//    InvitationModel *model = self.invitationArr[index.row];
//    self.requestType = NO;
//    self.requestParams = @{@"uid":JUserID,@"target_uid":@(model.uId),@"did":@(self.cooperationId),@"token":LoginToken};
//    self.requestURL = invitationUrl;
//}
//- (void)iconBtnClickWith:(NSInvitationListTableViewCell *)cell {
//
//    NSIndexPath *indexPath = [invitationTab indexPathForCell:cell];
//
//    InvitationModel *model = self.invitationArr[indexPath.row];
//
//    NSUserPageViewController *pageVC = [[NSUserPageViewController alloc] initWithUserID:[NSString stringWithFormat:@"%ld",model.uId]];
//
//    pageVC.who = Other;
//
//    [self.navigationController pushViewController:pageVC animated:YES];
//}
- (NSMutableArray *)musicianArr {
    if (!_musicianArr) {
        self.musicianArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _musicianArr;
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
