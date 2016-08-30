//
//  NSAccompanyListViewController.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/8.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSAccompanyListViewController.h"
#import "NSAccompanyListHeaderView.h"
#import "NSAccompanyTableCell.h"
#import "NSAccommpanyListModel.h"
#import "NSWriteMusicViewController.h"
#import "NSPlayMusicTool.h"
#import "NSAccompanyCategoryCell.h"
#import "NSAccompanyCategoryViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface NSAccompanyListViewController ()
<
UICollectionViewDataSource,
UICollectionViewDelegate
>
{
    
    UICollectionView *accompanyCollection;
    int currentPage;
    NSString * newUrl;
    NSString * hotUrl;
    
}

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) NSMutableArray * simpleSingAry;

@property (nonatomic, strong) NSMutableArray * accompanyCategoryAry;
@end


static NSString * const accompanyCellIditify = @"NSAccompanyCollectionCell";
@implementation NSAccompanyListViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureUIAppearance];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"2.0_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftClick:)];
    [self fetchAccompanyData];
}

- (void)leftClick:(UIBarButtonItem *)barButtonItem {
    
    [NSSingleTon viewFrom].viewTag = @"";
    
    [NSPlayMusicTool pauseMusicWithName:nil];
    
    [NSPlayMusicTool stopMusicWithName:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -fetchData
-(void)fetchAccompanyData
{
    if (self.accompanyCategoryAry.count == 0) {

        [accompanyCollection setContentOffset:CGPointMake(0, -60) animated:YES];
        [accompanyCollection performSelector:@selector(triggerPullToRefresh) withObject:nil afterDelay:0.5];
    }
    
}

#pragma mark -fetchAccommpanyListDataIsLoadMore
-(void)fetchAccompanyListDataWithIsLoadingMore:(BOOL)isLoadingMore{


    if (!isLoadingMore) {
        currentPage = 1;
           self.requestParams = @{kIsLoadingMore :@(NO)};
    }else{
        ++currentPage;
        self.requestParams = @{kIsLoadingMore:@(YES)};
    }
    self.requestType = YES;
    NSDictionary * dic = @{@"page":[NSString stringWithFormat:@"%d",currentPage]};
    NSString * str = [NSTool encrytWithDic:dic];
        newUrl = [accompanyListURL stringByAppendingString:str];
        self.requestURL = newUrl;
   
}


#pragma mark - overrride FetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if (requestErr) {
        
    } else {
        if (!parserObject.success) {
            
            NSAccommpanyListModel* listModel = (NSAccommpanyListModel *)parserObject;
            if (!operation.isLoadingMore) {
                [accompanyCollection.pullToRefreshView stopAnimating];
                if (listModel.simpleCategoryList.simpleCategory.count) {
                    self.accompanyCategoryAry = [NSMutableArray arrayWithArray:listModel.simpleCategoryList.simpleCategory];
                }
                if (listModel.simpleList.simpleSingList.itemID) {
                    [self.simpleSingAry removeAllObjects];
                    [self.simpleSingAry addObject: listModel.simpleList.simpleSingList];
                }
                
//                
            }else{
                [accompanyCollection.infiniteScrollingView stopAnimating];
                [self.accompanyCategoryAry addObjectsFromArray:listModel.simpleCategoryList.simpleCategory];
                
            }
            
            [accompanyCollection reloadData];
        }
    }
}

#pragma mark configureUIAppearance
-(void)configureUIAppearance
{
    //nav
    self.title = @"原唱伴奏";
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    accompanyCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) collectionViewLayout:layout];
    
    accompanyCollection.delegate = self;
    
    accompanyCollection.dataSource = self;
    
    accompanyCollection.showsVerticalScrollIndicator = NO;
    
    accompanyCollection.alwaysBounceVertical = YES;
    
    [accompanyCollection registerClass:[NSAccompanyCategoryCell class] forCellWithReuseIdentifier:accompanyCellIditify];
    
    accompanyCollection.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    
    [self.view addSubview:accompanyCollection];
    
    
    
    WS(Wself);
    //refresh
    [accompanyCollection addDDPullToRefreshWithActionHandler:^{
        if (!Wself) {
            return ;
        }else{
            [Wself fetchAccompanyListDataWithIsLoadingMore:NO];
        }
    }];
    //loadingMore
    [accompanyCollection addDDInfiniteScrollingWithActionHandler:^{
        if (!Wself) {
            return ;
        }
        [Wself fetchAccompanyListDataWithIsLoadingMore:YES];
    }];
    accompanyCollection.showsInfiniteScrolling = NO;
    
}



#pragma mark - sing no accompany
-(void)doSingNoAccompany
{
    NSWriteMusicViewController * writeMusicVC =[[NSWriteMusicViewController alloc] initWithItemId:108 andMusicTime:300 andHotMp3:@"http://audio.yinchao.cn/empty_hot_temp.mp3"];
    [self.navigationController pushViewController:writeMusicVC animated:YES];

}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return section ? self.accompanyCategoryAry.count : self.simpleSingAry.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSAccompanyCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:accompanyCellIditify forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        
        cell.simpleSing = self.simpleSingAry[indexPath.row];
    } else {
        cell.accompanyCategory = self.accompanyCategoryAry[indexPath.row];
    }
    
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section) {
        
        NSSimpleCategoryModel * accompany = self.accompanyCategoryAry[indexPath.item];
        
        NSAccompanyCategoryViewController *accompanyCategoryListVC = [[NSAccompanyCategoryViewController alloc] initWithCategoryId:accompany.categoryId andCategoryName:accompany.categoryName];
        if (self.aid.length) {
            accompanyCategoryListVC.aid = self.aid;
            
        }
        [self.navigationController pushViewController:accompanyCategoryListVC animated:YES];
    } else {
        NSSimpleSingModel *simpleSing = self.simpleSingAry[indexPath.section];
        if ([[NSSingleTon viewFrom].viewTag isEqualToString:@"writeView"]) {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[NSSingleTon viewFrom].controllersNum] animated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"clearRecordNotification" object:nil userInfo:@{@"accompanyId":@(simpleSing.itemID),@"accompanyTime":[NSNumber numberWithLong:simpleSing.playTimes],@"accompanyUrl":simpleSing.playUrl}];
        } else {
            
            NSWriteMusicViewController * writeMusicVC =[[NSWriteMusicViewController alloc] initWithItemId:simpleSing.itemID andMusicTime:simpleSing.playTimes andHotMp3:simpleSing.playUrl];
            [NSSingleTon viewFrom].controllersNum = 2;
            if (self.aid.length) {
                writeMusicVC.aid = self.aid;

            }
            [self.navigationController pushViewController:writeMusicVC animated:YES];
        
        }
        
    }
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return CGSizeMake(ScreenWidth - 30, ScreenHeight/4);
        
    } else {
        
        CGFloat W = (ScreenWidth - 50) / 3;
        return CGSizeMake(W, W);
        
    }
    
}
#pragma mark -collectionView LayOut
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(10, 15, 10, 15);
    }
    return UIEdgeInsetsMake(0, 15, 0, 15);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
    
}


- (NSMutableArray *)simpleSingAry {
    if (!_simpleSingAry) {
        self.simpleSingAry = [NSMutableArray arrayWithCapacity:1];
    }
    return _simpleSingAry;
}
- (NSMutableArray *)accompanyCategoryAry {
    if (!_accompanyCategoryAry) {
        self.accompanyCategoryAry = [NSMutableArray arrayWithCapacity:1];
    }
    return _accompanyCategoryAry;
}
@end
