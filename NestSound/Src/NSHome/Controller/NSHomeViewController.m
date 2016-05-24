//
//  NSHomeViewController.m
//  NestSound
//
//  Created by yandi on 16/4/24.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSHomeViewController.h"
#import "NSSongMenuCollectionViewCell.h"
#import "NSIndexCollectionReusableView.h"
#import "NSMusicSayCollectionViewCell.h"
#import "NSRecommendCell.h"
#import "NSIndexModel.h"
#import "NSH5ViewController.h"


@interface NSHomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource, NSIndexCollectionReusableViewDelegate> {
    
    UICollectionView *_collection;
    NSMutableArray * bannerAry;
    NSMutableArray * recommendAry;
    NSMutableArray * recommendSongAry;
    NSMutableArray * newListAry;
    NSMutableArray * musicSayAry;
}


@end

static NSString * const RecommendCell = @"RecommendCell";
static NSString * const MusicSayCell = @"MusicSayCell";
static NSString * const SongMenuCell = @"SongMenuCell";
static NSString * const headerView = @"HeaderView";
static NSString * const NewWorkCell = @"NewWorkCell";

@implementation NSHomeViewController

-(instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self fetchIndexData];
    
    
    
}

-(void)configureUIAppearance
{

    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    _collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    
    _collection.delegate = self;
    
    _collection.dataSource = self;
    
    _collection.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    
    [_collection registerClass:[NSRecommendCell class] forCellWithReuseIdentifier:RecommendCell];
    
    [_collection registerClass:[NSSongMenuCollectionViewCell class] forCellWithReuseIdentifier:SongMenuCell];
    
    [_collection registerClass:[NSRecommendCell class] forCellWithReuseIdentifier:NewWorkCell];
    
    [_collection registerClass:[NSMusicSayCollectionViewCell class] forCellWithReuseIdentifier:MusicSayCell];
    
    [_collection registerClass:[NSIndexCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerView];
    
    [self.view addSubview:_collection];
}

- (void)viewDidLayoutSubviews {
    
    _collection.frame = CGRectMake(0, 0, ScreenWidth, self.view.height);
    
    [super viewDidLayoutSubviews];
}

#pragma  mark -fetchIndexData
-(void)fetchIndexData
{
    self.requestParams = nil;
    self.requestType = YES;
    NSDictionary * dic = @{@"1":@"2"};
    
    NSDictionary * dic1 = [[NSHttpClient client] encryptWithDictionary:@{@"data":dic} isEncrypt:1];
    NSString * str = [NSString stringWithFormat:@"data=%@",[dic1 objectForKey:requestData]];
    self.requestURL = [indexURL stringByAppendingString:str];
    
}

#pragma mark -override FetchData;
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if (!parserObject.success) {

#ifdef debug
        
        NSLog(@"this is%@",parserObject.description);
        
#endif
        
            NSIndexModel * indexModel = (NSIndexModel *)parserObject;
            bannerAry = [NSMutableArray arrayWithArray:indexModel.BannerList.bannerList];
            recommendAry = [NSMutableArray arrayWithArray:indexModel.RecommendList.recommendList];
            recommendSongAry = [NSMutableArray arrayWithArray:indexModel.RecommendSongList.recommendSongList];
            newListAry = [NSMutableArray arrayWithArray:indexModel.NewList.songList];
        musicSayAry = [NSMutableArray arrayWithArray:indexModel.MusicSayList.musicSayList];
        [self configureUIAppearance];
        
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 4;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 6;
        
    } else if (section == 1) {
        
        return 4;
        
    } else if (section == 2){
        
        return 6;
        
    } else {
        
        return 2;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {

        NSRecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:RecommendCell forIndexPath:indexPath];
        
        NSRecommend * recommendModel =  (NSRecommend *)[recommendAry objectAtIndex:indexPath.row];
        cell.recommend = recommendModel;
        cell.contentView.layer.borderColor = [UIColor hexColorFloat:@"e5e5e5"].CGColor;
        cell.contentView.layer.borderWidth = 1;

        return cell;
        

    } else if (indexPath.section == 1) {
        
        NSSongMenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SongMenuCell forIndexPath:indexPath];
        
        NSRecommendSong * recommendSongModel = (NSRecommendSong *)[recommendSongAry objectAtIndex:indexPath.row];
        cell.recommendSong = recommendSongModel;
        
        return cell;
        
    } else if (indexPath.section == 2) {
        
        NSRecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NewWorkCell forIndexPath:indexPath];
        NSNew * newModel = (NSNew *)[newListAry objectAtIndex:indexPath.row];
        cell.songNew = newModel;

        cell.contentView.layer.borderColor = [UIColor hexColorFloat:@"e5e5e5"].CGColor;
        cell.contentView.layer.borderWidth = 1;
        
        return cell;
        
    } else {
        
        NSMusicSayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MusicSayCell forIndexPath:indexPath];
        NSMusicSay * musicSayModel = (NSMusicSay *)[musicSayAry objectAtIndex:indexPath.row];
        cell.musicSay = musicSayModel;
        return cell;
    }
    
}

#pragma mark <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        CGFloat W = (ScreenWidth - 50) / 3;
        return CGSizeMake(W, W + W * 0.38);
        
    } else if (indexPath.section == 1) {
        
        CGFloat W = (ScreenWidth - 40) * 0.5;
        return CGSizeMake(W, W);
        
    } else if (indexPath.section == 2) {
        
        CGFloat W = (ScreenWidth - 50) / 3;
        return CGSizeMake(W, W + W * 0.38);
        
    } else {
        
        CGFloat W = (ScreenWidth - 30);
        return CGSizeMake(W, 200);
    }
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 15, 0, 15);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return CGSizeMake(ScreenWidth, 230);
    }
    return CGSizeMake(ScreenWidth, 30);
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    NSIndexCollectionReusableView *reusable = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerView forIndexPath:indexPath];
    
    reusable.delegate = self;
    
    
    if (indexPath.section == 0) {
        
        reusable.bannerAry = bannerAry;

        
        reusable.titleLable.text = LocalizedStr(@"promot_recommendWorks");
        
    } else if (indexPath.section == 1) {
        
        [[reusable viewWithTag:100] removeFromSuperview];

        [[reusable viewWithTag:200] removeFromSuperview];

        reusable.titleLable.text = LocalizedStr(@"promot_recommendSongList");

    } else if (indexPath.section == 2) {
        [[reusable viewWithTag:100] removeFromSuperview];

        [[reusable viewWithTag:200] removeFromSuperview];

        reusable.titleLable.text = LocalizedStr(@"promot_newWorks");

    } else {
        [[reusable viewWithTag:100] removeFromSuperview];

        [[reusable viewWithTag:200] removeFromSuperview];

        reusable.titleLable.text = LocalizedStr(@"promot_musicSay");

    }
    
    return reusable;
    
}

//轮播器点击事件
- (void)indexCollectionReusableView:(NSIndexCollectionReusableView *)reusableView withImageBtn:(UIButton *)imageBtn {
    
    NSBanner * banner = (NSBanner *)bannerAry[imageBtn.tag];
    if (banner.state == 1) {
        NSH5ViewController * event = [[NSH5ViewController alloc] init];
        event.h5Url = banner.activityURL;
        [self.navigationController pushViewController:event animated:YES];
    }else{
    
    
    }
    
    NSLog(@"点击了第%zd张图片",imageBtn.tag);
}


@end
