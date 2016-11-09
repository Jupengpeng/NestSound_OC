//
//  NSInvitationListViewController.m
//  NestSound
//
//  Created by yinchao on 16/10/27.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSInvitationListViewController.h"
#import "NSInvitationListTableViewCell.h"
#import "NSUserPageViewController.h"
#import "NSInvitationListModel.h"
@interface NSInvitationListViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,NSInvitationListTableViewCellDelegate>
{
    int currentPage;
    UITableView *invitationTab;
    NSIndexPath *index;
}
@property (nonatomic,strong) NSMutableArray *invitationArr;
@end

@implementation NSInvitationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInvitationView];
    [self fetchInvitationListWithIsLoadingMore:NO withKey:@""];
}
#pragma mark - Network Requests and Data Handling
- (void)fetchInvitationListWithIsLoadingMore:(BOOL)isLoadingMore withKey:(NSString *)keyStr {
    self.requestType = NO;
    if (!isLoadingMore) {
        currentPage = 1;
        
    }else{
        ++currentPage;
        
    }
    if (keyStr.length) {
        self.requestParams = @{@"did":@(self.cooperationId),@"page":@(currentPage),@"uid":JUserID,kIsLoadingMore:@(isLoadingMore),@"token":LoginToken,@"key":keyStr};
    } else {
    self.requestParams = @{@"did":@(self.cooperationId),@"page":@(currentPage),@"uid":JUserID,kIsLoadingMore:@(isLoadingMore),@"token":LoginToken};
    }
    self.requestURL = invitationListUrl;
    
}
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr {
    if (requestErr) {
        
    } else {
        if ([operation.urlTag isEqualToString:invitationListUrl]) {
            NSInvitationListModel *invitationModel = (NSInvitationListModel *)parserObject;
            if (!operation.isLoadingMore) {
                [invitationTab.pullToRefreshView stopAnimating];
                self.invitationArr = [NSMutableArray arrayWithArray:invitationModel.invitationList];
            }else{
                [invitationTab.infiniteScrollingView stopAnimating];
                [self.invitationArr addObjectsFromArray:invitationModel.invitationList];
            }
            [invitationTab reloadData];
        } else if ([operation.urlTag isEqualToString:invitationUrl]) {
            if (parserObject.code == 200) {
                
                NSInvitationListTableViewCell *cell = [invitationTab cellForRowAtIndexPath:index];
                InvitationModel *model = self.invitationArr[index.row];
                model.isInvited = 1;
                [cell.invitationBtn setTitle:@"已邀请" forState:UIControlStateNormal];
                cell.invitationBtn.backgroundColor = [UIColor hexColorFloat:@"f2f2f2"];
                cell.invitationBtn.userInteractionEnabled = NO;
            }
            
        }
    }
}
- (void)setupInvitationView {
    
    self.title = @"邀请";

    self.view.backgroundColor = KBackgroundColor;
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 5, ScreenWidth-20, 30)];
    
//    searchBar.backgroundColor = [UIColor lightGrayColor];
    
    searchBar.backgroundImage = [image imageWithColor:[UIColor whiteColor] size:searchBar.bounds.size];
    
    searchBar.layer.cornerRadius = 5;
    
    searchBar.layer.masksToBounds = YES;
    
    searchBar.delegate = self;
    
//    searchBar.tintColor = [UIColor darkGrayColor];
    
    searchBar.showsCancelButton = NO;
    
    searchBar.placeholder = @"搜索";
    
    [self.view addSubview:searchBar];
    
    invitationTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, ScreenHeight-84) style:UITableViewStylePlain];
    
    invitationTab.dataSource = self;
    
    invitationTab.delegate = self;
    
    invitationTab.rowHeight = 60;
    
    [self.view addSubview:invitationTab];
    
    UIView *noLineView = [[UIView alloc] initWithFrame:CGRectZero];
    
    invitationTab.tableFooterView = noLineView;
    
    WS(wSelf);
    //refresh
    [invitationTab addDDPullToRefreshWithActionHandler:^{
        if (!wSelf) {
            return ;
        }else{
            [wSelf fetchInvitationListWithIsLoadingMore:NO withKey:searchBar.text];
        }
    }];
    //loadingMore
    [invitationTab addDDInfiniteScrollingWithActionHandler:^{
        if (!wSelf) {
            return ;
        }
        [wSelf fetchInvitationListWithIsLoadingMore:YES withKey:searchBar.text];
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.invitationArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"invitationCell";
    
    NSInvitationListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[NSInvitationListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.delegate = self;
    }
    InvitationModel *model = self.invitationArr[indexPath.row];
    cell.invitationModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate
#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    
    [self fetchInvitationListWithIsLoadingMore:NO withKey:searchBar.text];
    
}
#pragma mark - NSInvitationListTableViewCellDelegate
- (void)invitationBtnClickWith:(NSInvitationListTableViewCell *)cell {
    
    index = [invitationTab indexPathForCell:cell];
    InvitationModel *model = self.invitationArr[index.row];
    self.requestType = NO;
    self.requestParams = @{@"uid":JUserID,@"target_uid":@(model.uId),@"did":@(self.cooperationId),@"token":LoginToken};
    self.requestURL = invitationUrl;
}
- (void)iconBtnClickWith:(NSInvitationListTableViewCell *)cell {
    
    NSIndexPath *indexPath = [invitationTab indexPathForCell:cell];
    
    InvitationModel *model = self.invitationArr[indexPath.row];
    
    NSUserPageViewController *pageVC = [[NSUserPageViewController alloc] initWithUserID:[NSString stringWithFormat:@"%ld",model.uId]];
    
    pageVC.who = Other;
    
    [self.navigationController pushViewController:pageVC animated:YES];
}
- (NSMutableArray *)invitationArr {
    if (!_invitationArr) {
        self.invitationArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _invitationArr;
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
