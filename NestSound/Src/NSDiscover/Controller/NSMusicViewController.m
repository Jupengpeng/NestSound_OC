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
#import "NSDiscoverMusicListModel.h"
#import "NSDicoverLyricListModel.h"
@interface NSMusicViewController () <UICollectionViewDelegate, UICollectionViewDataSource> {
    
    UICollectionView *_collection;
    NSMutableArray * newSongList;
    NSMutableArray * hotSongList;
    BOOL isMusic;
}


@end

static NSString * const RecommendCell = @"RecommendCell";
static NSString * const headerView = @"HeaderView";

@implementation NSMusicViewController

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


-(void)viewWillAppear:(BOOL)animated
{
    [self fetchData];
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
}


#pragma mark -fetchData
-(void)fetchData
{
    self.requestParams = nil;
    self.requestType = YES;
    NSDictionary * dic = @{@"name":@"hjay"};
    NSDictionary * dic1 = [[NSHttpClient client] encryptWithDictionary:@{@"data":dic} isEncrypt:YES];
    NSString * str = [NSString stringWithFormat:@"data=%@",[dic1 objectForKey:requestData]];
    NSString * url;
    if (isMusic) {
       url = [dicoverMusicURL stringByAppendingString:str];
    }else{
        
#warning  set url
        
//        url = [];
    }
   
    self.requestURL = url;
    
}

#pragma  mark override -actionFectionData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    
    
    
    if ([operation.urlTag isEqualToString:dicoverMusicURL]) {
        if (!parserObject.success) {
            NSDiscoverMusicListModel * musicListModel = (NSDiscoverMusicListModel *)parserObject;
            if (musicListModel.HotList.hotList.count == 0) {
                
            }else{
                hotSongList = [NSMutableArray arrayWithArray:musicListModel.HotList.hotList];
            }
            if (musicListModel.SongList.songList.count == 0) {
                
            }else{
                newSongList = [NSMutableArray arrayWithArray:musicListModel.SongList.songList];
            }
        }
    }else{
        if (!parserObject.success) {
            NSDicoverLyricListModel * lyricListModel = (NSDicoverLyricListModel *)parserObject;
            if (lyricListModel.HotLyricList.hotLyricList.count == 0) {
                
            }else{
                hotSongList = [NSMutableArray arrayWithArray:lyricListModel.HotLyricList.hotLyricList];
            }
            if (lyricListModel.LyricList.lyricList.count == 0) {
                
            }else{
                newSongList = [NSMutableArray arrayWithArray:lyricListModel.LyricList.lyricList];
            }
        }
    
    }
    
    [self configureUIAppearance];
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 6;
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
    
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(ScreenWidth, 30);
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    NSIndexCollectionReusableView *reusable = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerView forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        
        UIButton *hotMusic = [reusable loadMore];
       
        [hotMusic addTarget:self action:@selector(hotMusic:) forControlEvents:UIControlEventTouchUpInside];
        
        reusable.titleLable.text = self.topTitle;
        
    } else if (indexPath.section == 1) {
       
        UIButton *newMusic = [reusable loadMore];
        
        [newMusic addTarget:self action:@selector(newMusic:) forControlEvents:UIControlEventTouchUpInside];
        
        reusable.titleLable.text = self.bottomTitle;
    }
    
    
    return reusable;
    
}

//push hotMusicVC
- (void)hotMusic:(UIButton *)topBtn {
    
    NSLog(@"点击了热门歌曲的更多");
    NSNewMusicViewController * hotMusicVC = [[NSNewMusicViewController alloc] initWithType:@"hot"];
    [self.navigationController pushViewController:hotMusicVC animated:YES];
    
}
//push newMusicVC
- (void)newMusic:(UIButton *)newBtn {
    
    NSLog(@"点击了最新歌曲的更多");
    
    NSNewMusicViewController *newMusic = [[NSNewMusicViewController alloc] initWithType:nil];
    
    [self.navigationController pushViewController:newMusic animated:YES];
}

@end
