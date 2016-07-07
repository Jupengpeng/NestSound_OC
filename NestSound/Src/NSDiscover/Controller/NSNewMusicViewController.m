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
}

@end

@implementation NSNewMusicViewController

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
    if (!parserObject.success) {
        if ([operation.urlTag isEqualToString:url]) {
            NSDiscoverMoreLyricModel * discoverMore = (NSDiscoverMoreLyricModel *)parserObject;
            if (!operation.isLoadingMore) {
                DataAry = [NSMutableArray arrayWithArray:discoverMore.moreLyricList];
            }else{
                [DataAry addObjectsFromArray:discoverMore.moreLyricList];
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
        [self.navigationController pushViewController:playVC animated:YES];
    }
    
}


@end







