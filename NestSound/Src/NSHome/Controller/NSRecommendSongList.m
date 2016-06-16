//
//  NSRecommendSongList.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/4.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSRecommendSongList.h"


@interface NSRecommendSongList ()
<
UICollectionViewDataSource,
UICollectionViewDelegate
>{
    
    NSMutableArray * recommendSongList;
    
    UICollectionView * SongCollectionView;

   
}



@end

@implementation NSRecommendSongList


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    



}

#pragma mark - configureUIAppearance
-(void)configureUIAppearance
{
    //title
    self.title = @"歌单";
    LocalizedStr(@"promot_song");
    
    //collection
    

}


#pragma mark - collectionView delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return recommendSongList.count;


}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    
    return cell;


}


#pragma mark - collectionView DataSource

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
        

    
}



@end
