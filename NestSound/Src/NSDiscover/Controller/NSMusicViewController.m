//
//  NSMusicViewController.m
//  NestSound
//
//  Created by Apple on 16/5/7.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSMusicViewController.h"
#import "NSIndexCollectionReusableView.h"
#import "NSRecommendCell.h"
#import "NSNewMusicViewController.h"
#import "NSDicoverLyricListModel.h"
#import "NSDiscoverMusicListModel.h"
#import "NSPlayMusicViewController.h"
#import "NSLyricViewController.h"
@interface NSMusicViewController () <UICollectionViewDelegate, UICollectionViewDataSource> {
    
    UICollectionView *_collection;
    NSMutableArray * newSongList;
    NSMutableArray * hotSongList;
    BOOL isMusic;
    NSString * lyricURL;
    NSString * musicURL;
}

@property (nonatomic, strong) NSMutableArray *hotItemIdList;
@property (nonatomic, strong) NSMutableArray *latestItemIdList;
@end

static NSString * const RecommendCell = @"RecommendCell";
static NSString * const headerView = @"HeaderView";

@implementation NSMusicViewController
- (NSMutableArray *)hotItemIdList {
    if (!_hotItemIdList) {
        self.hotItemIdList = [NSMutableArray arrayWithCapacity:1];
    }
    return _hotItemIdList;
}
- (NSMutableArray *)latestItemIdList {
    if (!_latestItemIdList) {
        self.latestItemIdList = [NSMutableArray arrayWithCapacity:1];
    }
    return _latestItemIdList;
}
-(instancetype)initWithIsMusic:(BOOL)isMusic_
{
    if (self = [super init]) {
        isMusic = isMusic_;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUIAppearance];
}

-(void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    if (newSongList.count == 0 || newSongList == nil) {
        [_collection setContentOffset:CGPointMake(0, -60) animated:YES];
        [_collection performSelector:@selector(triggerPullToRefresh) withObject:self afterDelay:0.5];
       
    }
}

#pragma mark -configureUIAppearance
-(void)configureUIAppearance
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.minimumLineSpacing = 10;
    
    layout.minimumInteritemSpacing = 10;
    
    layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    
    CGFloat W = (ScreenWidth - 50) / 3;
    
    layout.itemSize = CGSizeMake(W, W + W * 0.38);
    
    _collection = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    
    _collection.delegate = self;
    
    _collection.dataSource = self;
    
    _collection.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    
    [_collection registerClass:[NSRecommendCell class] forCellWithReuseIdentifier:RecommendCell];
    
    [_collection registerClass:[NSIndexCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerView];
    self.view = _collection;
//    [self.view addSubview:_collection];
    //refresh
    WS(wSelf);
    [_collection addDDPullToRefreshWithActionHandler:^{
        if (!wSelf) {
            return ;
        }else{
            
            [wSelf fetchData];
        }
        
    }];
    
}


#pragma mark -fetchData
-(void)fetchData
{
    self.requestType = YES;
    NSDictionary * dic = @{@"name":@""};
    NSString * str =  [NSTool encrytWithDic:dic];
    if (isMusic) {
       musicURL = [dicoverMusicURL stringByAppendingString:str];
        self.requestURL = musicURL;
    }else{
       lyricURL = [dicoverLyricURL stringByAppendingString:str];
        self.requestURL = lyricURL;
    }
    
}

#pragma  mark override -actionFectionData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if (requestErr) {
        
        [_collection.pullToRefreshView stopAnimating];
        
    } else {
        if (!parserObject.success){
            
            if ([operation.urlTag isEqualToString:musicURL]) {
                
                NSDiscoverMusicListModel * musicListModel = (NSDiscoverMusicListModel *)parserObject;
                if (musicListModel.HotList.hotList.count == 0) {
                    
                }else{
                    hotSongList = [NSMutableArray arrayWithArray:musicListModel.HotList.hotList];
                    for (NSRecommend *model in hotSongList) {
                        [self.hotItemIdList addObject:@(model.itemId)];
                    }
                }
                if (musicListModel.SongList.songList.count == 0) {
                    
                }else{
                    newSongList = [NSMutableArray arrayWithArray:musicListModel.SongList.songList];
                    for (NSRecommend *model in newSongList) {
                        [self.latestItemIdList addObject:@(model.itemId)];
                    }
                }
                
            }else if ([operation.urlTag isEqualToString:lyricURL]){
                
                NSDicoverLyricListModel * lyricListModel = (NSDicoverLyricListModel *)parserObject;
                if (lyricListModel.HotLyricList.hotLyricList.count == 0) {
                    
                }else{
                    hotSongList = [NSMutableArray arrayWithArray:lyricListModel.HotLyricList.hotLyricList];
                }
                if (lyricListModel.LyricList.lyricList.count == 0) {
                    
                }else{
                    newSongList = [NSMutableArray arrayWithArray:lyricListModel.LyricList.lyricList];
                }
                
            }else{
                
            }
            [_collection.pullToRefreshView stopAnimating];
            [_collection reloadData];
        }
    }
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return section ? newSongList.count : hotSongList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSRecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:RecommendCell forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.recommend = hotSongList[indexPath.row];
    }else{
        cell.recommend = newSongList[indexPath.row];
    }
    cell.contentView.layer.borderColor = [UIColor hexColorFloat:@"e5e5e5"].CGColor;
    cell.contentView.layer.borderWidth = 1;
    if (isMusic) {
        cell.isMusic = YES;
    }else{
        cell.isMusic = NO;
    }
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(ScreenWidth, 30);
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    NSIndexCollectionReusableView *reusable = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerView forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        reusable.SDCycleScrollView.hidden = YES;
        UIButton *hotMusic = [reusable loadMore:YES];
        [hotMusic addTarget:self action:@selector(hotMusic:) forControlEvents:UIControlEventTouchUpInside];
        
        reusable.titleLable.text = self.topTitle;
        
    } else if (indexPath.section == 1) {
       reusable.SDCycleScrollView.hidden = YES;
        UIButton *newMusic = [reusable loadMore:YES];
        [newMusic addTarget:self action:@selector(newMusic:) forControlEvents:UIControlEventTouchUpInside];
        
        reusable.titleLable.text = self.bottomTitle;
    }
    
    
    return reusable;
    
}

#pragma mark - collectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSRecommend * music;
    NSPlayMusicViewController * playVC = [NSPlayMusicViewController sharedPlayMusic];
    if (section == 0) {
       
        music = hotSongList[row];
        playVC.itemUid = music.itemId;
        playVC.from = @"red";
        playVC.geDanID = 0;
        playVC.songID = row;
        playVC.songAry = self.hotItemIdList;
    }else{
       
        music = newSongList[row];
        playVC.itemUid = music.itemId;
        playVC.from = @"news";
        playVC.geDanID = 0;
        playVC.songID = row;
        playVC.songAry = self.latestItemIdList;
    }
   long itemId = music.itemId;
    if (isMusic) {
        [self.navigationController pushViewController:playVC animated:YES];
    }else{
        NSLyricViewController * lyricVC = [[NSLyricViewController alloc] initWithItemId:itemId];
        [self.navigationController pushViewController:lyricVC animated:YES];
    }
    
}

//push hotMusicVC
- (void)hotMusic:(UIButton *)topBtn {
    

    if (isMusic) {
        NSNewMusicViewController * hotMusicVC = [[NSNewMusicViewController alloc] initWithType:@"hot" andIsLyric:NO];
        [self.navigationController pushViewController:hotMusicVC animated:YES];
    }else{
        NSNewMusicViewController * hotMusicVC = [[NSNewMusicViewController alloc] initWithType:@"hot" andIsLyric:YES];
        [self.navigationController pushViewController:hotMusicVC animated:YES];
    }
   
    
}
//push newMusicVC
- (void)newMusic:(UIButton *)newBtn {
    
    
    
    if (isMusic) {
        NSNewMusicViewController *newMusic = [[NSNewMusicViewController alloc] initWithType:@"lal" andIsLyric:NO];
        
        [self.navigationController pushViewController:newMusic animated:YES];

    }else{
        NSNewMusicViewController *newMusic = [[NSNewMusicViewController alloc] initWithType:@"lal" andIsLyric:YES];
        
        [self.navigationController pushViewController:newMusic animated:YES];

    }
}

@end
