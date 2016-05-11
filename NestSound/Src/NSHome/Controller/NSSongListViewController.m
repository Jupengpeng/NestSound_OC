//
//  NSSongListViewController.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/4.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSSongListViewController.h"
#import "NSSongViewController.h"

@interface NSSongListViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>{

    NSMutableArray * SongLists;
    
    UICollectionView * SongListColl;

    NSSongViewController * songVC;

}



@end

@implementation NSSongListViewController
 static NSString * cellId = @"SongListCell";
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self configureUIAperance];
    

}

-(void)configureUIAperance
{
    //title
    self.title = LocalizedStr(@"promot_song");
    
    //collection
    UICollectionViewFlowLayout * SongListCollLayOut = [[UICollectionViewFlowLayout alloc] init];
    SongListColl = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:SongListCollLayOut];
    SongListColl.showsHorizontalScrollIndicator = NO;
    SongListColl.showsVerticalScrollIndicator = NO;
    SongListColl.delegate = self;
    SongListColl.dataSource = self;
    
    SongListColl.bounces = NO;
    
    

}


#pragma mark collectionView dataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return SongLists.count;

}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * SongListCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    if (!SongListCell) {
        SongListCell = [[UICollectionViewCell alloc] init];
        UIImageView * back = [[UIImageView alloc] init];
        [SongListCell.contentView addSubview:back];
        
    }
    return SongListCell;
}

#pragma mark collectionView delegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    songVC = [[NSSongViewController alloc] initWithSongListId:@"lal"];
    [self.navigationController pushViewController: songVC animated:YES];
    
}

#pragma mark collectionViewDelegateLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(100, 100);
    
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(15, 0, 0, 15);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

@end
