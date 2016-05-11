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




@interface NSHomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource, NSIndexCollectionReusableViewDelegate> {
    
    UICollectionView *_collection;
}


@end

static NSString * const RecommendCell = @"RecommendCell";
static NSString * const MusicSayCell = @"MusicSayCell";
static NSString * const SongMenuCell = @"SongMenuCell";
static NSString * const headerView = @"HeaderView";
static NSString * const NewWorkCell = @"NewWorkCell";

@implementation NSHomeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
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
    
    _collection.frame = [UIScreen mainScreen].bounds;
    
    [super viewDidLayoutSubviews];
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
        
        cell.authorName = @"hjay";
        cell.workName = @"zheshisha";
        cell.imgeUrl = nil;
        cell.type = @"1";
        cell.contentView.layer.borderColor = [UIColor hexColorFloat:@"e5e5e5"].CGColor;
        cell.contentView.layer.borderWidth = 1;

        return cell;
        

    } else if (indexPath.section == 1) {
        
        NSSongMenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SongMenuCell forIndexPath:indexPath];
        
        return cell;
        
    } else if (indexPath.section == 2) {
        
        NSRecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NewWorkCell forIndexPath:indexPath];
        cell.authorName = @"hjay";
        cell.workName = @"zheshisha";
        cell.imgeUrl = nil;
        cell.type = @"1";
        cell.contentView.layer.borderColor = [UIColor hexColorFloat:@"e5e5e5"].CGColor;
        cell.contentView.layer.borderWidth = 1;
        
        return cell;
        
    } else {
        
        NSMusicSayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MusicSayCell forIndexPath:indexPath];
    
        
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
    
    NSArray *array = @[@"img_01",@"img_02",@"img_03",@"img_04",@"img_05"];
    
    if (indexPath.section == 0) {
        
        [reusable addHeaderViewWithImageArray:array];
        
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
    
    
    
    NSLog(@"点击了第%zd张图片",imageBtn.tag);
}


@end
