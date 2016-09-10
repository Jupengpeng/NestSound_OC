//
//  NSJoinerListController.m
//  NestSound
//
//  Created by 鞠鹏 on 16/8/17.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSStarMusicianListController.h"
#import "NSStarMusicianListCell.h"
#import "NSStarMusicianDetailController.h"
#import "NSMusicianListModel.h"
@interface NSStarMusicianListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign) NSInteger page;

@property (nonatomic,strong) NSMutableArray *musicianArray;

@end

@implementation NSStarMusicianListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupUI];
    
}

- (void)fetchMusicianListdataWithIsLoadingMore:(BOOL)isLoadingMore{
    
    self.requestType = NO;

    if (!isLoadingMore) {
        self.page = 1;
        self.requestParams = @{@"page":[NSString stringWithFormat:@"%ld",self.page],
                               kIsLoadingMore :@(NO)};
    }else{
        ++self.page;
        self.requestParams = @{@"page":[NSString stringWithFormat:@"%ld",self.page],
                               kIsLoadingMore:@(YES)};
    }
    
    self.requestURL = musicianListUrl;
    
}

- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr{
    if (requestErr) {
        [_tableView.pullToRefreshView stopAnimating];
        [_tableView.infiniteScrollingView stopAnimating];
    }else{
        if ([operation.urlTag isEqualToString:musicianListUrl]) {
            NSMusicianListModel *listModel = (NSMusicianListModel *)parserObject;
            if (!operation.isLoadingMore) {
                if (self.musicianArray.count) {
                    [self.musicianArray removeAllObjects];
                }
            }

            [self.musicianArray addObjectsFromArray:listModel.musicianList];

            if (!operation.isLoadingMore) {
                [_tableView.pullToRefreshView stopAnimating];
            }else{
                [_tableView.infiniteScrollingView stopAnimating];
            }

        }
        [self.tableView  reloadData];
    }
}

- (void)setupUI{
    
    
    self.title = @"明星音乐人";
    [self.view addSubview:self.tableView];
    
    WS(weakSelf);
    [self.tableView addDDPullToRefreshWithActionHandler:^{
       
        if (!weakSelf) {
            
        }else{
            [weakSelf fetchMusicianListdataWithIsLoadingMore:NO];
        }
    }];
    
    [self.tableView addDDInfiniteScrollingWithActionHandler:^{
       
        if (!weakSelf) {
            
        }else{
            [weakSelf fetchMusicianListdataWithIsLoadingMore:YES];
        }
    }];

    [_tableView triggerPullToRefresh];

}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.musicianArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSStarMusicianListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSStarMusicianListCellId"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.musicianArray.count) {
        NSMusicianListDetailModel *detailModel = self.musicianArray[indexPath.section];
        cell.musicianModel = detailModel;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMusicianListDetailModel *detailModel = self.musicianArray[indexPath.section];

    NSStarMusicianDetailController *detailController= [[NSStarMusicianDetailController alloc]init];
    detailController.uid = [NSString stringWithFormat:@"%ld",detailModel.musicianId];
    detailController.name = detailModel.name;
    [self.navigationController pushViewController:detailController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - lazy init
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor hexColorFloat:@"efeff4"];
        [_tableView registerClass:[NSStarMusicianListCell class] forCellReuseIdentifier:@"NSStarMusicianListCellId"];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    return _tableView;
}

- (NSMutableArray *)musicianArray{
    if (!_musicianArray) {
        _musicianArray = [NSMutableArray array];
    }
    return _musicianArray;
}

@end
