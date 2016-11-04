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
