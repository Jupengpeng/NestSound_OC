//
//  NSImportLyricViewController.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/11.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSImportLyricViewController.h"
#import "NSLyricCell.h"
#import "NSLyricViewController.h"
#import "NSMyLricListModel.h"
@interface NSImportLyricViewController()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
>
{
    UICollectionView * lyricCollecView;
    NSMutableArray * lyricesAry;
    UILabel * lyricesNameLabel;
    UILabel * authorLabel;
    UIImageView * titlePage;
    
}

@end
static NSString  * const lyricCellIdifity = @"lyricCell";
@implementation NSImportLyricViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configureUIAppearance];
}

#pragma mark -fectData
-(void)fetchMyLyricDataIsLoadingMore:(BOOL)isLoadingMore
{
    
    
}

#pragma mark --override action fetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    

}

#pragma mark -configureAppearance
-(void)configureUIAppearance
{
    
    
    //lyricCollecView
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    lyricCollecView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [lyricCollecView registerClass:[NSLyricCell class] forCellWithReuseIdentifier:lyricCellIdifity];
    [self.view addSubview:lyricCollecView];
    
    //constraints
    [lyricCollecView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    
}

#pragma mark collectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return lyricesAry.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLyricCell * lyricCell = [collectionView dequeueReusableCellWithReuseIdentifier:lyricCellIdifity forIndexPath:indexPath];
    lyricCell.titlePageUrl = @"111";
    lyricCell.lyricName = @"nishuoddshigesha";
    lyricCell.authorName = @"hjay";
    
    return lyricCell;
}

#pragma mark collectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLyricViewController * lyricVC = [[NSLyricViewController alloc] init];
    
    [self.navigationController pushViewController:lyricVC animated:YES];
}

#pragma mark UICollectionViewDelegateFlowLayout
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 15, 0, 15);
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
