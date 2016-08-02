//
//  NSNewMusicViewController.m
//  NestSound
//
//  Created by Apple on 16/5/8.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSNewMusicViewController.h"
#import "NSNewMusicTableViewCell.h"
#import "NSDiscoverMoreLyricModel.h"
#import "NSPlayMusicViewController.h"
#import "NSLyricViewController.h"
@interface NSNewMusicViewController () <UITableViewDelegate, UITableViewDataSource> {
    
    UITableView *_tableView;
    NSMutableArray * DataAry;
    BOOL isLyric;
    int currentPage;
    NSString * url;
    int typed;
    UIImageView * playStatus;
}
@property (nonatomic, strong)  NSPlayMusicViewController *playSongsVC;
@property (nonatomic, strong) NSMutableArray *itemIdList;
@end

@implementation NSNewMusicViewController
- (NSPlayMusicViewController *)playSongsVC {
    
    if (!_playSongsVC) {
        
        _playSongsVC = [NSPlayMusicViewController sharedPlayMusic];
        
    }
    
    return _playSongsVC;
}
- (NSMutableArray *)itemIdList {
    if (!_itemIdList) {
        self.itemIdList = [NSMutableArray arrayWithCapacity:1];
    }
    return _itemIdList;
}
-(instancetype)initWithType:(NSString *)type andIsLyric:(BOOL)isLyric_
{
    self = [super init];
    if (self) {
        self.MusicType = type;
        isLyric = isLyric_;
    }
    return self;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    playStatus  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 21)];
    
    playStatus.animationDuration = 0.8;
    playStatus.animationImages = @[[UIImage imageNamed:@"2.0_play_status_1"],
                                   [UIImage imageNamed:@"2.0_play_status_2"],
                                   [UIImage imageNamed:@"2.0_play_status_3"],
                                   [UIImage imageNamed:@"2.0_play_status_4"],
                                   [UIImage imageNamed:@"2.0_play_status_5"],
                                   [UIImage imageNamed:@"2.0_play_status_6"],
                                   [UIImage imageNamed:@"2.0_play_status_7"],
                                   [UIImage imageNamed:@"2.0_play_status_8"],
                                   [UIImage imageNamed:@"2.0_play_status_9"],
                                   [UIImage imageNamed:@"2.0_play_status_10"],
                                   [UIImage imageNamed:@"2.0_play_status_11"],
                                   [UIImage imageNamed:@"2.0_play_status_12"],
                                   [UIImage imageNamed:@"2.0_play_status_13"],
                                   [UIImage imageNamed:@"2.0_play_status_14"],
                                   [UIImage imageNamed:@"2.0_play_status_15"],
                                   [UIImage imageNamed:@"2.0_play_status_16"]];
    
    [playStatus stopAnimating];
    playStatus.userInteractionEnabled = YES;
    playStatus.image = [UIImage imageNamed:@"2.0_play_status_1"];
    UIButton * btn = [[UIButton alloc] initWithFrame:playStatus.frame ];
    [playStatus addSubview:btn];
    [btn addTarget:self action:@selector(musicPaly:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:playStatus];
    self.navigationItem.rightBarButtonItem = item;
    if (isLyric) {
        if ([self.MusicType isEqualToString:@"hot"]) {
            self.title = @"热门歌词";
        }else{
            self.title = @"最新歌词";
        }
    }else{
    if ([self.MusicType isEqualToString:@"hot"]) {
            self.title = @"热门歌曲";
//          LocalizedStr(@"promot_hotMusic");
        }else{
            self.title = @"最新歌曲";
//        LocalizedStr(@"promot_newMusic");
            }
    }
    
    _tableView = [[UITableView alloc] init];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.rowHeight = 80;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.view = _tableView;
    
    WS(wSelf);
    //refresh
    [_tableView addDDPullToRefreshWithActionHandler:^{
        if (!wSelf) {
            return ;
        }else{
        
            [wSelf fetchDataWithIsLoadingMore:NO];
        }
    }];
    
    //loadingMore
    [_tableView addDDInfiniteScrollingWithActionHandler:^{
        if (!wSelf) {
            return ;
        }else{
            [wSelf fetchDataWithIsLoadingMore:YES];
        }
    }];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (DataAry.count == 0) {
        [self fetchDataWithIsLoadingMore:NO];
    }
    
    if (self.playSongsVC.player == nil) {
        
    } else {
        
        if (self.playSongsVC.player.rate != 0.0) {
            [playStatus startAnimating];
        }else{
            [playStatus stopAnimating];
        }
    }
    
}



#pragma mark -fetchData
-(void)fetchDataWithIsLoadingMore:(BOOL)isLoadingMore
{
    self.requestType = YES;
    if (!isLoadingMore) {
        currentPage = 1;
        self.requestParams = @{kIsLoadingMore :@(NO)};
    }else{
        ++currentPage;
        self.requestParams = @{kIsLoadingMore:@(YES)};
    }
    if ([self.MusicType isEqualToString:@"hot"]) {
        typed = 2;
    }else{
        typed = 1;
    }
    NSDictionary * dic = @{@"page":[NSNumber numberWithInt:currentPage],@"orderType":[NSNumber numberWithInt:typed]};
    NSString * str = [NSTool encrytWithDic:dic];
    if (isLyric) {
        url = [discoverLyricMoreURL stringByAppendingString:str];
    }else{
        url = [discoverMusicMoreURL stringByAppendingString:str];
    }
    self.requestURL = url;
    

}



#pragma mark -override actionFetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if ( requestErr) {
        
    } else {
        if (!parserObject.success) {
            if ([operation.urlTag isEqualToString:url]) {
                NSDiscoverMoreLyricModel * discoverMore = (NSDiscoverMoreLyricModel *)parserObject;
                if (!operation.isLoadingMore) {
                    
                    DataAry = [NSMutableArray arrayWithArray:discoverMore.moreLyricList];
                    
                    for (NSMyMusicModel *model in DataAry) {
                        [self.itemIdList addObject:@(model.itemId)];
                    }
                }else{
                    
                    [DataAry addObjectsFromArray:discoverMore.moreLyricList];
                    for (NSMyMusicModel *model in DataAry) {
                        [self.itemIdList addObject:@(model.itemId)];
                    }
                }
                [_tableView reloadData];
                if (!operation.isLoadingMore) {
                    [_tableView.pullToRefreshView stopAnimating];
                }else{
                    [_tableView.infiniteScrollingView stopAnimating];
                }
            }
        }
    }

}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return DataAry.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"newMusicCell";
    
    NSNewMusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[NSNewMusicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }
    
    
//    [cell addDateLabel];
    
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    
    [cell.numLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(cell.mas_left);
    }];
    
    cell.numLabel.hidden = YES;
    cell.myMusicModel = DataAry[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMyMusicModel * myModel = DataAry[indexPath.row];
    long itemID = myModel.itemId;
    if (isLyric) {
        NSLyricViewController * lyricVC = [[NSLyricViewController alloc] initWithItemId:itemID];
        [self.navigationController pushViewController:lyricVC animated:YES];
    }else{
        NSPlayMusicViewController * playVC =[[NSPlayMusicViewController alloc] init];
        
        if ([self.MusicType isEqualToString:@"hot"]) {
           playVC.from = @"red";
        }else{
           playVC.from = @"news";
        }
        playVC.itemUid = itemID;
        playVC.geDanID = 0;
        playVC.songID = indexPath.row;
        playVC.songAry = self.itemIdList;
        [self.navigationController pushViewController:playVC animated:YES];
    }
    
}

- (void)musicPaly:(UIBarButtonItem *)palyItem {
    
    if (self.playSongsVC.player == nil) {
        [[NSToastManager manager] showtoast:@"您还没有听过什么歌曲哟"];
    } else {
        
        [self.navigationController pushViewController:self.playSongsVC animated:YES];
    }
    
}
@end







