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
<UICollectionViewDataSource,UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
>
{
    UICollectionView * musicSayList;
    NSMutableArray * musicSayAry;
    long itemId;
    int i;
    
    NSString * url ;

    int currentPage;
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
    
    self.navigationController.title = @"乐说";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout * layOut = [[UICollectionViewFlowLayout alloc] init];
    musicSayList = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layOut];
    musicSayList.dataSource = self;
    musicSayList.delegate = self;
    musicSayList.backgroundColor = [UIColor whiteColor];
    musicSayList.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:musicSayList];
    [musicSayList registerClass:[NSMusicSayCollectionViewCell class] forCellWithReuseIdentifier:musicSayCellId];
    WS(wSelf);
    //refresh
    [musicSayList addDDPullToRefreshWithActionHandler:^{
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
        self.requestParams = @{kIsLoadingMore:@(NO)};
    }else{
    
        ++currentPage;
        self.requestParams = @{kIsLoadingMore:@(YES)};
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
    if (requestErr) {
        
    } else {
        if (!parserObject.success) {
            if ([operation.urlTag isEqualToString:url]) {
                NSMusicSayListMode * musicSaylist = (NSMusicSayListMode *)parserObject;
                if (!operation.isLoadingMore) {
                    [musicSayList.pullToRefreshView stopAnimating];
                    musicSayAry = [NSMutableArray arrayWithArray:musicSaylist.musicSayList];
                }else
                {
                    [musicSayList.infiniteScrollingView stopAnimating];
                    [musicSayAry addObjectsFromArray:musicSaylist.musicSayList];
                }
                
            }
            [musicSayList reloadData];
        }else{
            
            [[NSToastManager manager ] showtoast:@"亲，您网络飞出去玩了"];
        }
        
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

    NSInteger row = indexPath.row;
    NSMusicSay * mm = musicSayAry[row];
    NSMusicSayCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:musicSayCellId forIndexPath:indexPath];
    cell.musicSay = mm;
    
    return cell;

}




#pragma mark -collectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger row = indexPath.row;
    NSMusicSay * mm = musicSayAry[row];
    if (mm.type == 1) {
        NSPlayMusicViewController * playVC = [NSPlayMusicViewController sharedPlayMusic];
        playVC.itemUid = itemId;
        playVC.geDanID = 0;
        playVC.from = @"yueshuo";
#warning  songListArr
//        playVC.songAry =
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
    
    return UIEdgeInsetsMake(10, 15, 0, 15);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
@end
