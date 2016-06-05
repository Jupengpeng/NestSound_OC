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
    int currentPage;
    NSString * url;
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


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [lyricCollecView setContentOffset:CGPointMake(0, 60) animated:YES];
    [lyricCollecView performSelector:@selector(triggerPullToRefresh) withObject:nil afterDelay:0.5];

}

#pragma mark -fectData
-(void)fetchMyLyricDataIsLoadingMore:(BOOL)isLoadingMore
{
    if (!isLoadingMore) {
        currentPage = 1;
        self.requestParams = @{kIsLoadingMore:@(NO)};
    }else{
        ++currentPage;
        self.requestParams = @{kIsLoadingMore:@(YES)};
    }
    self.requestType = YES;
    NSDictionary * dic = @{@"page":[NSString stringWithFormat:@"%d",currentPage],@"uid":JUserID};
    NSString * str = [NSTool encrytWithDic:dic];
    url = [myLyricListURL stringByAppendingString:str];
    self.requestURL = url;
    
}

#pragma mark --override action fetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if (!parserObject.success) {
        if ([url isEqualToString:myLyricListURL]) {
            NSMyLricListModel * myLyricList = (NSMyLricListModel *)parserObject;
            if (!operation.isLoadingMore) {
                lyricesAry = [NSMutableArray arrayWithArray:myLyricList.myLyricList];
            }else{
                [lyricesAry addObject:myLyricList.myLyricList];
            }
        }
        if (!operation.isLoadingMore) {
            lyricCollecView.showsInfiniteScrolling = YES;
        }
        [lyricCollecView reloadData];
    }

}

#pragma mark -configureAppearance
-(void)configureUIAppearance
{
    
    
    //lyricCollecView
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    lyricCollecView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    lyricCollecView.autoresizesSubviews = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [lyricCollecView registerClass:[NSLyricCell class] forCellWithReuseIdentifier:lyricCellIdifity];
    [self.view addSubview:lyricCollecView];
    
    //constraints
    [lyricCollecView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    WS(wSelf);
    
    //refresh
    [lyricCollecView addDDPullToRefreshWithActionHandler:^{
        if (!wSelf) {
            return ;
        }else{
            [wSelf fetchMyLyricDataIsLoadingMore:NO];
        }
    }];
    
    //loadingMore
    [lyricCollecView addDDInfiniteScrollingWithActionHandler:^{
        if (!wSelf) {
            return ;
        }else{
            [wSelf fetchMyLyricDataIsLoadingMore:YES];
        }
    }];
    lyricCollecView.showsInfiniteScrolling = NO;
}

#pragma mark collectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return lyricesAry.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLyricCell * lyricCell = [collectionView dequeueReusableCellWithReuseIdentifier:lyricCellIdifity forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    lyricCell.myLyricModel = lyricesAry[row];
    return lyricCell;
}

#pragma mark collectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSMyLyricModel * mode = lyricesAry[row];
    NSString * lyric = mode.lyrics;
    [_delegate selectLyric:lyric];
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
