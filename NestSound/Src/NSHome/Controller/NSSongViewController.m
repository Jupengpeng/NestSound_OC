//
//  NSSongViewController.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/4.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSSongViewController.h"
#import "NSSongListHeaderView.h"
#import "NSSongCell.h"
#import "NSPlayMusicViewController.h"
#import "NSSongListModel.h"
@interface NSSongViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>{
    NSMutableArray * songAry;
    
    long songListId;
    UITableView * songsTable;
    NSSongListHeaderView * header;
    NSString * url;
    singListModel * singListDetail;
}


@end


@implementation NSSongViewController

static NSString * cellId = @"SongCell";


-(instancetype)initWithSongListId:(long )listId
{
    
    if (self = [super init]) {
        songListId = listId;
        NSLog(@"thsi is %ld",listId);
    }

    return self;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    [self configureUIApperance];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self fetchSongListData];

}
#pragma mark -fetchSongListData
-(void)fetchSongListData
{
//        [songsTable setContentOffset:CGPointMake(0, -60) animated:YES];
//        [songsTable performSelector:@selector(triggerPullToRefresh)];
    [self fetchDataWithIsLoadingMore:NO];
}

#pragma mark -fetchDataWithIsLoadingMore
-(void)fetchDataWithIsLoadingMore:(BOOL)isLodadingMore
{
    int currentPage;
    if (!isLodadingMore) {
        currentPage = 1;
    }else{
        ++ currentPage;
    }
    NSDictionary * dic = @{@"id":@(songListId),@"page":@(currentPage)};

    NSString * str = [NSTool encrytWithDic:dic];
    url = [SongListURL stringByAppendingString:str];
   
    self.requestParams = @{kIsLoadingMore:@(isLodadingMore)};
    self.requestType = YES;
    NSLog(@"%@",url);
    self.requestURL = url;
}

#pragma mark -actionFetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if (!parserObject.success) {
        if ([operation.urlTag isEqualToString:url]) {
            NSSongListModel * songListModel = (NSSongListModel *)parserObject;
            singListDetail = songListModel.songListDetail.listDetail;
            if (!operation.isLoadingMore) {
                songAry = [NSMutableArray arrayWithArray:songListModel.SongList.songList];
            }else
            {
                [songAry addObjectsFromArray:songListModel.SongList.songList];
            }
          
            if (!operation.isLoadingMore) {
                [songsTable.pullToRefreshView stopAnimating];
            }else{
                [songsTable.infiniteScrollingView stopAnimating];
                songsTable.showsInfiniteScrolling = NO;
            }
            [songsTable reloadData];
           

            
        }
       
        
    }else{
        
        [[NSToastManager manager ] showtoast:@"亲，您网络飞出去玩了"];
    }
    
}

#pragma mark -configureUIAppearance
-(void)configureUIApperance
{
    
    //title
    self.title = @"歌单";
//    LocalizedStr(@"promot_song");
    
    //tableView
    songsTable = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    songsTable.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    songsTable.delegate = self;
    songsTable.dataSource = self;
//    songsTable.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    songsTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
     [self.view addSubview:songsTable];
    
    
        //constraints
        [songsTable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self.view);
        }];

    WS(wSelf);
    
    // refresh
    [songsTable addDDPullToRefreshWithActionHandler:^{
        
        if (!wSelf) {
            return ;
        }
        
        [wSelf fetchDataWithIsLoadingMore:@(NO)];
  
    }];
    
    // loadingMore
    [songsTable addDDInfiniteScrollingWithActionHandler:^{
        
        if (!wSelf) {
            return ;
        }
        [wSelf fetchDataWithIsLoadingMore:@(YES)];
    }];
    
    // hidden LoadingMoreView
    songsTable.showsInfiniteScrolling = NO;
}

#pragma mark tablView datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return songAry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 180;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //headerView
    header = [[NSSongListHeaderView alloc] init];
    header.singListType = singListDetail;
    return header;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * songCellIdentifer = @"NSSongCell";
    songModel * song = songAry[indexPath.row];
    NSSongCell * songCell = [tableView dequeueReusableCellWithIdentifier:songCellIdentifer];
    if (!songCell) {
        songCell = [[NSSongCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:songCellIdentifer];
    }

    songCell.number = indexPath.row + 1 ;
    songCell.songModel = song;
    return songCell;
}

#pragma mark tableView delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    songModel * song = songAry[indexPath.row];
    NSPlayMusicViewController * playVC = [NSPlayMusicViewController sharedPlayMusic];
    playVC.itemId = song.itemId;
    [self.navigationController pushViewController:playVC animated:YES];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (songsTable.contentOffset.y >songsTable.contentSize.height ) {
        [self fetchDataWithIsLoadingMore:YES];
        songsTable.showsInfiniteScrolling = YES;
    }
}

@end
