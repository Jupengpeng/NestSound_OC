//
//  NSWriteLyricMaskView.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/31.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSWriteLyricMaskView.h"
#import "NSLyricLibraryListModel.h"

@interface NSWriteLyricMaskView ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
UITableViewDataSource,
UITableViewDelegate
>
{
    NSMutableArray * lyricTypeAry;
<<<<<<< HEAD
    NSMutableArray * lyricsAry;
    UIView * bottomView;
    UICollectionView * lyricTypeColl;
    UITableView * lyricTableView;
    NSMutableArray * dataAry;
=======
    

>>>>>>> zhangxuanhe
}
@end

@implementation NSWriteLyricMaskView
-(instancetype)init
{
    if (self = [super init]) {
        [self configreUIAppearance];
    }
    return self;
}

#pragma  mark -configureUIAppearance
-(void)configreUIAppearance
{
    
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.4;
    
    //bottom view
    bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomView];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    lyricTypeColl = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 10, self.size.width, 35) collectionViewLayout:layout];
    lyricTypeColl.delegate = self;
    lyricTypeColl.dataSource = self;
    [bottomView addSubview:lyricTypeColl];
    
    lyricTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    lyricTableView.dataSource = self;
    lyricTableView.delegate = self;
    [bottomView addSubview:lyricTableView];
    
    
    
}
#pragma mark -layout
-(void)layoutSubviews
{
    [super layoutSubviews];
    //constraints

}

#pragma mark -setter && getter
-(void)setLyricLibraryListModel:(NSLyricLibraryListModel *)lyricLibraryListModel
{
    _lyricLibraryListModel = lyricLibraryListModel;
    lyricTypeAry = [NSMutableArray arrayWithArray:lyricLibraryListModel.LyricLibaryListModel];
    NSTypeLyricListModel * typeList =lyricTypeAry[0];
    lyricsAry = [NSMutableArray arrayWithArray:typeList.lyricLibaryList];
    dataAry = lyricsAry;
    
}
#pragma mark collectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
       return  lyricTypeAry.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSTypeLyricListModel * lyricTy = lyricTypeAry[row];
    static  NSString * const lyricTypeID = @"lyricType";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:lyricTypeID forIndexPath:indexPath];
    if (!cell) {
        cell = [[UICollectionViewCell alloc] init];
        UILabel * label = [[UILabel alloc] initWithFrame:cell.contentView.frame];
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 100;
        label.textColor = [UIColor blackColor];
        [cell.contentView addSubview:label];
        cell.selectedBackgroundView.backgroundColor = [UIColor hexColorFloat:@"ffd527"];
    }
    UILabel * label = [cell.contentView viewWithTag:100];
    label.text = lyricTy.typeTitle;
    
    return cell;
    
}
#pragma mark -collectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (lyricsAry) {
        lyricsAry = nil;
    }
    NSInteger row = indexPath.row;
    NSTypeLyricListModel * tpel = lyricTypeAry[row];
    lyricsAry = [NSMutableArray arrayWithArray:tpel.lyricLibaryList];
    dataAry = lyricsAry;
    [lyricTableView reloadData];
    [lyricTableView setContentOffset:CGPointMake(0,0) animated:NO];
    
}
#pragma mark -collectViewLayout
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80, 35);
}


#pragma mark -tableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataAry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString  * const lyricID = @"lyricID";
    LyricLibList * lib = dataAry[indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:lyricID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyricID];
        
    }
    cell.textLabel.text = lib.lyrics;
    return cell;
}

#pragma mark -tableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString * lyricStr = cell.textLabel.text;
    [_delegate selectedlrcString:lyricStr];
}

@end
