//
//  NSCollectionCooperationViewController.m
//  NestSound
//
//  Created by yinchao on 16/10/25.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSCollectionCooperationViewController.h"
#import "NSCooperationCollectionTableViewCell.h"
#import "NSCollectionCooperationListModel.h"
#import "NSCooperationDetailViewController.h"
@interface NSCollectionCooperationViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *collectionTab;
    UIImageView *emptyImage;
    int currentPage;
}
@property (nonatomic,strong) NSMutableArray *collectionArr;
@end

@implementation NSCollectionCooperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCollectionViewController];
    [self fetchCollectCooperationListWithIsLoadingMore:NO];
}
#pragma mark - Network Requests and Data Handling
- (void)fetchCollectCooperationListWithIsLoadingMore:(BOOL)isLoadingMore {
    self.requestType = NO;
    if (!isLoadingMore) {
        currentPage = 1;
//        self.requestParams = @{@"page":@(currentPage),@"uid":JUserID,kIsLoadingMore:@(NO),@"token":LoginToken};
    }else{
        ++currentPage;
//        self.requestParams = @{@"page":@(currentPage),@"uid":JUserID,kIsLoadingMore:@(YES),@"token":LoginToken};
    }
    self.requestParams = @{@"page":@(currentPage),@"uid":JUserID,kIsLoadingMore:@(isLoadingMore),@"token":LoginToken};
    self.requestURL = collectCooperationListUrl;
    
}
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr {
    if (requestErr) {
        
    } else {
        if ([operation.urlTag isEqualToString:collectCooperationListUrl]) {
            NSCollectionCooperationListModel *model = (NSCollectionCooperationListModel *)parserObject;
            if (!operation.isLoadingMore) {
                [collectionTab.pullToRefreshView stopAnimating];
                self.collectionArr = [NSMutableArray arrayWithArray:model.collectionList];
                
            }else{
                [collectionTab.infiniteScrollingView stopAnimating];
                [self.collectionArr addObjectsFromArray:model.collectionList];
            }
            
            [collectionTab reloadData];
        } else if ([operation.urlTag isEqualToString:cancelCollectUlr]) {
            [self fetchCollectCooperationListWithIsLoadingMore:NO];
        }
    }
}
- (void)setupCollectionViewController {
    //收藏
    
    collectionTab = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    
    collectionTab.dataSource = self;
    
    collectionTab.delegate = self;
    
    collectionTab.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    
    //    [collectionTab registerClass:[NSSearchUserCollectionViewCell class] forCellWithReuseIdentifier:userCellIdentify];
    
    self.view = collectionTab;
    
    UIView *noLineView = [[UIView alloc] initWithFrame:CGRectZero];
    
    collectionTab.tableFooterView = noLineView;
    WS(Wself);
    //refresh
    [collectionTab addDDPullToRefreshWithActionHandler:^{
        if (!Wself) {
            return ;
        }
        [Wself fetchCollectCooperationListWithIsLoadingMore:NO];
    }];
    //loadingMore
    [collectionTab addDDInfiniteScrollingWithActionHandler:^{
        if (!Wself) {
            return ;
        }
        [Wself fetchCollectCooperationListWithIsLoadingMore:YES];
    }];
    
    emptyImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.0_noMyData"]];
    
    emptyImage.hidden = YES;
    
    emptyImage.centerX = ScreenWidth/2;
    
    emptyImage.y = 100;
    
    [collectionTab addSubview:emptyImage];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.collectionArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"collectionCell";
    
    NSCooperationCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[NSCooperationCollectionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }
    CollectionCooperationModel *model = self.collectionArr[indexPath.row];
    cell.collectionModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CollectionCooperationModel *collectionModel = self.collectionArr[indexPath.section];
    NSCooperationDetailViewController *cooperationDetailVC = [[NSCooperationDetailViewController alloc] init];
    cooperationDetailVC.cooperationId = collectionModel.cooperationId;
    cooperationDetailVC.detailTitle = collectionModel.cooperationTitle;
    [self.navigationController pushViewController:cooperationDetailVC animated:YES];
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //注意：1、当rowActionWithStyle的值为UITableViewRowActionStyleDestructive时，系统默认背景色为红色；当值为UITableViewRowActionStyleNormal时，背景色默认为淡灰色，可通过UITableViewRowAction的对象的.backgroundColor设置；
    //2、当左滑按钮执行的操作涉及数据源和页面的更新时，要先更新数据源，在更新视图，否则会出现无响应的情况
    CollectionCooperationModel *collectionModel = self.collectionArr[indexPath.section];
    UITableViewRowAction *cancelCollect = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"取消收藏"handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        self.requestType = NO;
        self.requestParams = @{@"did":@(collectionModel.cooperationId),@"uid":JUserID,@"type":@(0),@"token":LoginToken};
        self.requestURL = cancelCollectUlr;
    }];
        return @[cancelCollect];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
- (NSMutableArray *)collectionArr {
    if (!_collectionArr) {
        self.collectionArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _collectionArr;
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
