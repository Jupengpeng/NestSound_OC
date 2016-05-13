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

@interface NSMusicViewController () <UICollectionViewDelegate, UICollectionViewDataSource> {
    
    UICollectionView *_collection;
}


@end

static NSString * const RecommendCell = @"RecommendCell";
static NSString * const headerView = @"HeaderView";

@implementation NSMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSRecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:RecommendCell forIndexPath:indexPath];
    
    cell.authorName = @"hjay";
    cell.workName = @"zheshisha";
    cell.imgeUrl = nil;
    cell.type = @"1";
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
        
        reusable.titleLable.text = LocalizedStr(@"热门歌曲");
        
    } else if (indexPath.section == 1) {
       
        UIButton *newMusic = [reusable loadMore];
        
        [newMusic addTarget:self action:@selector(newMusic:) forControlEvents:UIControlEventTouchUpInside];
        
        reusable.titleLable.text = LocalizedStr(@"最新歌曲");
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
