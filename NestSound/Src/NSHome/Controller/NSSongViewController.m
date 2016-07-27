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
    NSMutableArray * songList;
    UIImageView * playStatus;
    NSInteger selectRow;
}

@property (nonatomic, strong)  NSPlayMusicViewController *playSongsVC;
@end


@implementation NSSongViewController
- (NSPlayMusicViewController *)playSongsVC {
    
    if (!_playSongsVC) {
        
        _playSongsVC = [NSPlayMusicViewController sharedPlayMusic];
        
    }
    
    return _playSongsVC;
}
static NSString * cellId = @"SongCell";


-(instancetype)initWithSongListId:(long )listId
{
    
    if (self = [super init]) {
        songListId = listId;
        songList = [NSMutableArray array];
    }

    return self;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToRow:) name:@"scrollToRow" object:nil];
    [self configureUIApperance];
    [self fetchSongListData];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}
- (void)scrollToRow:(NSNotification *)info {
    NSString *itemId = info.object;
    songModel *model1 = nil;
   for (songModel * model in songAry) {
       if ([[NSString stringWithFormat:@"%ld",model.itemId] isEqualToString: itemId]) {
           model1 = model;
       }
   }
    NSInteger index = [songAry indexOfObject:model1];
    selectRow = [songAry indexOfObject:model1] + 1;
    NSSongCell *cell = (NSSongCell *)[songsTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    cell.index = YES;
//    cell.playImg.hidden = NO;
//    cell.numberLab.hidden = YES;
//    [songsTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    [songsTable reloadData];
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
    self.requestURL = url;
}

#pragma mark -actionFetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if (requestErr) {
        
    } else {
        if (!parserObject.success) {
            if ([operation.urlTag isEqualToString:url]) {
                NSSongListModel * songListModel = (NSSongListModel *)parserObject;
                singListDetail = songListModel.songListDetail.listDetail;
                if (!operation.isLoadingMore) {
                    songAry = [NSMutableArray arrayWithArray:songListModel.SongList.songList];
                    for (songModel * model in songAry) {
                        [songList addObject:@(model.itemId)];
                    }
                }else{
                    [songAry addObjectsFromArray:songListModel.SongList.songList];
                }
                
                if (!operation.isLoadingMore) {
                    [songsTable.pullToRefreshView stopAnimating];
                }else{
                    [songsTable.infiniteScrollingView stopAnimating];
                    songsTable.showsInfiniteScrolling = NO;
                }
                if ([NSPlayMusicViewController sharedPlayMusic].itemUid) {
                    songModel *model1 = nil;
                    for (songModel * model in songAry) {
                        if ([[NSString stringWithFormat:@"%ld",model.itemId] isEqualToString: [NSString stringWithFormat:@"%ld", [NSPlayMusicViewController sharedPlayMusic].itemUid]]) {
                            model1 = model;
                        }
                    }
                    selectRow = [songAry indexOfObject:model1] + 1;
                }
                [songsTable reloadData];
                
            }
            
        }
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
    
//    // refresh
//    [songsTable addDDPullToRefreshWithActionHandler:^{
//        
//        if (!wSelf) {
//            return ;
//        }
//        
//        [wSelf fetchDataWithIsLoadingMore:@(NO)];
//  
//    }];
    
    // loadingMore
    [songsTable addDDInfiniteScrollingWithActionHandler:^{
        
        if (!wSelf) {
            return ;
        }
        [wSelf fetchDataWithIsLoadingMore:YES];
    }];
    
    // hidden LoadingMoreView
    songsTable.showsInfiniteScrolling = NO;
}

#pragma mark -playAllGedan
-(void)playAll
{
    if (songAry.count) {
        songModel * song = songAry[0];
        NSPlayMusicViewController * playVC = [NSPlayMusicViewController sharedPlayMusic];
        playVC.itemUid = song.itemId;
        playVC.from = @"gedan";
        playVC.geDanID = (int)songListId;
        playVC.songAry = songList;
        playVC.songID = 0;
        [self.navigationController pushViewController:playVC animated:YES];
    } else {
        [[NSToastManager manager] showtoast:@""];
    }
    
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
    [header.playAllBtn addTarget:self action:@selector(playAll) forControlEvents:UIControlEventTouchUpInside];
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
    songCell.number = indexPath.row + 1;
     songCell.songModel = song;
    if (selectRow == indexPath.row+ 1) {
        songCell.numberLab.hidden = YES;
        songCell.playImg.hidden = NO;
    } else {
        songCell.numberLab.hidden = NO;
        songCell.playImg.hidden = YES;
    }
    
    return songCell;
}

#pragma mark tableView delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    NSSongCell *cell = (NSSongCell *)[tableView cellForRowAtIndexPath:indexPath];
//    cell.playImg.hidden = NO;
//    cell.numberLab.hidden = YES;
    selectRow = indexPath.row + 1;
    songModel * song = songAry[indexPath.row];
    NSInteger row = indexPath.row;
    NSPlayMusicViewController * playVC = [NSPlayMusicViewController sharedPlayMusic];
    playVC.itemUid = song.itemId;
    playVC.from = @"gedan";
    playVC.geDanID = (int)songListId;
    playVC.songAry = songList;
    playVC.songID = row;
    [tableView reloadData];
    [self.navigationController pushViewController:playVC animated:YES];
}
//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self tableView:tableView didDeselectRowAtIndexPath:indexPath];
//    NSSongCell *cell = (NSSongCell *)[tableView cellForRowAtIndexPath:indexPath];
//    cell.playImg.hidden = YES;
//    cell.numberLab.hidden = NO;
//}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (songsTable.contentOffset.y >songsTable.contentSize.height ) {
        [self fetchDataWithIsLoadingMore:YES];
        songsTable.showsInfiniteScrolling = YES;
    }
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"scrollToRow" object:nil];
}
@end
