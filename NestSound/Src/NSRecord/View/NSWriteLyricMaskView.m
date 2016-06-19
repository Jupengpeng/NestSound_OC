//
//  NSWriteLyricMaskView.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/31.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSWriteLyricMaskView.h"
#import "NSLyricLibraryListModel.h"
#import "NSLexiconCollectionViewCell.h"

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
    NSMutableArray * lyricsAry;
    UIView * bottomView;
    UICollectionView * lyricTypeColl;
    UITableView * lyricTableView;
    NSMutableArray * dataAry;
}
@end
static  NSString * const lyricTypeID = @"lyricType";
@implementation NSWriteLyricMaskView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self configreUIAppearance];
    }
    return self;
}

#pragma  mark -configureUIAppearance
-(void)configreUIAppearance
{
    
    self.backgroundColor = [UIColor whiteColor];
//    self.alpha = 0.4;
    
    //bottom view
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomView];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    layout.sectionInset = UIEdgeInsetsMake(1, 0, 1, 0);
    layout.itemSize = CGSizeMake(self.width / 5 - 1, 33);
    
    
    lyricTypeColl = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 10, self.size.width, 35) collectionViewLayout:layout];
    lyricTypeColl.delegate = self;
    lyricTypeColl.dataSource = self;
    lyricTypeColl.backgroundColor = [UIColor lightGrayColor];
    [bottomView addSubview:lyricTypeColl];
    
    [lyricTypeColl registerClass:[NSLexiconCollectionViewCell class] forCellWithReuseIdentifier:lyricTypeID];
    
    
    lyricTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, bottomView.width, bottomView.height - 45) style:UITableViewStylePlain];
    lyricTableView.dataSource = self;
    lyricTableView.delegate = self;
//    lyricTableView.backgroundColor = [UIColor orangeColor];
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
//    return 5;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSTypeLyricListModel * lyricTy = lyricTypeAry[row];
    
    NSLexiconCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:lyricTypeID forIndexPath:indexPath];
    
    cell.lyricLibraryListModel = lyricTy;
    
    cell.backgroundColor = [UIColor whiteColor];
    
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
