//
//  NSMusicSayViewController.m
//  NestSound
//
//  Created by 谢豪杰 on 16/6/2.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSMusicSayViewController.h"
#import "NSMusicSayCollectionViewCell.h"
#import "NSMusiclListModel.h"
#import "NSPlayMusicViewController.h"
#import "NSH5ViewController.h"
#import "NSMusicSayListMode.h"
@interface NSMusicSayViewController()
<UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
>
{
    UICollectionView * musicSayList;
    NSMutableArray * musicSayAry;
    long itemId;
<<<<<<< HEAD
    int i;
    
=======
    NSString * url ;
<<<<<<< HEAD
    int currentPage;
=======
>>>>>>> fd1704484d6437ed3eebc82ceb41745bcc9d9980
>>>>>>> 9a4ffa7e21e543d211c78fe42f5f4fc18d901660
}
@end
static NSString * const musicSayCellId = @"musicSayCellId";
@implementation NSMusicSayViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self configureUIAppearance];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self fetchMusicSayData];
}

-(void)fetchMusicSayData{
    if (musicSayAry.count == 0) {
        [musicSayList setContentOffset:CGPointMake(0, -60) animated:YES];
        [musicSayList performSelector:@selector(triggerPullToRefresh) withObject:nil afterDelay:0.5];
    }
}

-(void)configureUIAppearance
{
    UICollectionViewFlowLayout * layOut = [[UICollectionViewFlowLayout alloc] init];
    musicSayList = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layOut];
    musicSayList.dataSource = self;
    musicSayList.delegate = self;
    musicSayList.backgroundColor = [UIColor whiteColor];
    musicSayList.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:musicSayList];
    
    WS(wSelf);
    //refresh
    [musicSayList addPullToRefreshWithActionHandler:^{
        if (!wSelf) {
            return ;
        }else{
            [wSelf fetchMusicSayListDataIsLoadingMore:NO];
        }
        
    }];
    
    //loadingMore
    [musicSayList addDDInfiniteScrollingWithActionHandler:^{
        if (!wSelf) {
            return ;
        }else{
            [wSelf fetchMusicSayListDataIsLoadingMore:YES];
        }
    }];
    
    //hide infitView
    musicSayList.showsInfiniteScrolling = NO;
    
}

#pragma mark -fetchData
-(void)fetchMusicSayListDataIsLoadingMore:(BOOL)isLoadingMore
{
    
    if (!isLoadingMore) {
        currentPage = 1 ;
    }else{
    
        ++currentPage;
    }

    NSDictionary * dic = @{@"page":[NSString stringWithFormat:@"%d",currentPage]};
    NSString * str = [NSTool encrytWithDic:dic];
    url = [yueShuoURL stringByAppendingString:str];
    self.requestType = YES;
    self.requestURL = url;
    
}

#pragma mark -actionFetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    
    if (parserObject.success) {
        if ([operation.urlTag isEqualToString:url]) {
            NSMusiclListModel * musicSaylist = (NSMusiclListModel *)parserObject;
            if (!operation.isLoadingMore) {
                musicSayAry = [NSMutableArray arrayWithArray:musicSaylist.musicList];
            }else
            {
                [musicSayAry addObjectsFromArray:musicSaylist.musicList];
            }
            
            
        }
    }else{
    
        [[NSToastManager manager ] showtoast:@"亲，您网络飞出去玩了"];
    }
    
    
}


#pragma mark -collectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return musicSayAry.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
//    NSMusicSay * mm =
    NSMusicSayCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:musicSayCellId forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[NSMusicSayCollectionViewCell alloc] init];
        
    }
//    cell.musicSay = ;
    return cell;
}


#pragma mark -collectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (i == 1) {
        NSPlayMusicViewController * playVC = [NSPlayMusicViewController sharedPlayMusic];
        playVC.itemId = itemId;
        [self.navigationController pushViewController: playVC animated:YES];
    }else{
        NSH5ViewController * eventVC =[[NSH5ViewController alloc] init];
        eventVC.h5Url = @"url";
        [self.navigationController pushViewController:eventVC animated:YES];
    
    }

}

#pragma mark - UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(ScreenWidth -30, 200);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(15, 0, 0, 15);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
@end
