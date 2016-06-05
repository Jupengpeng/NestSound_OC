//
//  NSSongListViewController.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/4.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSSongListViewController.h"
#import "NSSongViewController.h"
#import "NSSongListModel.h"
@interface NSSongListViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>{

    NSMutableArray * SongLists;
    
    UICollectionView * SongListColl;

    NSSongViewController * songVC;
    
    NSString * itemId;
    int currentPage;
    NSString * url;
}



@end

@implementation NSSongListViewController
 static NSString * cellId = @"SongListCell";

-(instancetype)initWithItemID:(NSString *)itemId_
{
    if (self = [super init]) {
        itemId = itemId_;
    }
    return self;


}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureUIAperance];
    

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self fetchSongList];
}

#pragma mark -configureUIAppearance
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
    
    [self.view addSubview:SongListColl];
    
    WS(wSelf);
    //refresh
    [SongListColl addPullToRefreshWithActionHandler:^{
        if (!wSelf) {
            return ;
        }else{
            [wSelf fetchSongListWithIsLoadingMore:NO];
        }
        
    }];
    //loadingMore
    [SongListColl addDDInfiniteScrollingWithActionHandler:^{
        if (!wSelf) {
            return ;
        }else{
            [wSelf fetchSongListWithIsLoadingMore:YES];
        }
    }];
    
    //hide infiniteView
    SongListColl.showsInfiniteScrolling = NO;

}

#pragma mark -fetchData
-(void)fetchSongList
{
    if (SongLists.count == 0) {
        [SongListColl setContentOffset:CGPointMake(0 , -60) animated:YES];
        [SongListColl performSelector:@selector(triggerPullToRefresh) withObject:self afterDelay:0.5];
    }
    

}

#pragma mark -fetchSongListIsLoadingMore
-(void)fetchSongListWithIsLoadingMore:(BOOL)isLoadingMore
{
    if (!isLoadingMore) {
        currentPage = 1;
        
    }else{
        ++currentPage;
    }
    NSDictionary * dic = @{@"page":[NSString stringWithFormat:@"%d",currentPage]};
    NSString * str = [NSTool encrytWithDic:dic];
    url = [songListURL  stringByAppendingString:str];
    self.requestType = NO;
    self.requestURL = url;
    

}


#pragma mark -actionFetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    
    if ([operation.urlTag isEqualToString:url]) {
    
        if (!parserObject.success) {
            NSSongListModel * songListModel = (NSSongListModel *)parserObject;
            if (!operation.isLoadingMore) {
                SongLists = [NSMutableArray  arrayWithArray:songListModel.SongList.songList];
            }else{
            
                if (songListModel.SongList.songList.count == 0) {
                    
                }else{
                    [SongLists addObjectsFromArray:songListModel.SongList.songList];
                }
            }
            [SongListColl reloadData];
            
            if (!operation.isLoadingMore) {
                [SongListColl.pullToRefreshView stopAnimating];
            }else{
                [SongListColl.infiniteScrollingView stopAnimating];
            }
            
        }
    }
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
//    songVC = [[NSSongViewController alloc] initWithSongListId:];
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
