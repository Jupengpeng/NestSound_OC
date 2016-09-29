//
//  NSActivityJoinerListController.m
//  NestSound
//
//  Created by 鞠鹏 on 16/8/18.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSActivityJoinerListController.h"
#import "NSActivityJoinerListCell.h"
#import "NSActivityJoinerListModel.h"
#import "NSUserPageViewController.h"
@interface NSActivityJoinerListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign) NSInteger page;

@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation NSActivityJoinerListController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self initUI];
}

- (void)initUI{
    self.view.backgroundColor = [UIColor hexColorFloat:@"e5e5e5"];
    self.title = @"参加人";
    [self.view addSubview:self.tableView];
    
    WS(weakSelf);
    [self.tableView addDDPullToRefreshWithActionHandler:^{
        
        [weakSelf fetchJoinerListDataIsLoadingMore:NO];
        
    }];
    
    [self.tableView addDDInfiniteScrollingWithActionHandler:^{
        [weakSelf fetchJoinerListDataIsLoadingMore:YES];
    }];
    
    [self.tableView triggerPullToRefresh];
}

- (void)fetchJoinerListDataIsLoadingMore:(BOOL)isLoadingMore{
    
    self.requestType = NO;
    if (isLoadingMore) {
        self.page ++;
        self.requestParams = @{kIsLoadingMore:@(YES),
                               @"aid":self.aid,
                               @"page":[NSString stringWithFormat:@"%ld",(long)self.page]};
    }else{
        self.page = 1;
        self.requestParams = @{kIsLoadingMore:@(NO),
                               @"aid":self.aid,
                               @"page":[NSString stringWithFormat:@"%ld",(long)self.page]};
    }
    
    self.requestURL = joinedUserListUrl;
}

#pragma mark - overwrite load data method 

- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr{
    
    if (requestErr) {
        
    }else{
        NSActivityJoinerListModel *listModel = (NSActivityJoinerListModel *)parserObject;

    
        if (!operation.isLoadingMore) {
            [_tableView.pullToRefreshView stopAnimating];
            if (self.dataArray.count) {
                [self.dataArray removeAllObjects];
            }
        }else{
            [_tableView.infiniteScrollingView stopAnimating];
        }
        [self.dataArray addObjectsFromArray:listModel.joinerList];
        
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSActivityJoinerListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSActivityJoinerListCellID"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSActivityJoinerDetailModel *detailModel = self.dataArray[indexPath.row];
    cell.detailModel = detailModel;

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSActivityJoinerDetailModel *detailModel = self.dataArray[indexPath.row];

    NSUserPageViewController *pageVC = [[NSUserPageViewController alloc] initWithUserID:[NSString stringWithFormat:@"%ld",detailModel.joinerId]];
    if (detailModel.joinerId != [JUserID integerValue]) {
        pageVC.who = Other;
        [self.navigationController pushViewController:pageVC animated:YES];
    }
}

#pragma mark - lazy init


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, ScreenWidth, ScreenHeight - 65)];
        [self.tableView registerClass:[NSActivityJoinerListCell class] forCellReuseIdentifier:@"NSActivityJoinerListCellID"];
        _tableView.separatorColor = [UIColor hexColorFloat:@"e5e5e5"];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = [UIColor hexColorFloat:@"e5e5e5"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    return _tableView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
