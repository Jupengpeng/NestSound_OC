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
@interface NSMusicSayViewController()
<UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
>
{
    UICollectionView * musicSayList;
    NSMutableArray * musicSayAry;
    long itemId;
    
}
@end
static NSString * const musicSayCellId = @"musicSayCellId";
@implementation NSMusicSayViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)configureUIAppearance
{
    UICollectionViewFlowLayout * layOut = [[UICollectionViewFlowLayout alloc] init];
    musicSayList = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layOut];
    musicSayList.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:musicSayList];
    
}


#pragma mark -fetchData
-(void)fetchMusicSayListDataIsLoadingMore:(BOOL)isLoadingMore
{
    

}

#pragma mark -actionFetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    
    if (parserObject.success) {
        if (!operation.isLoadingMore) {
            if ([operation.urlTag isEqualToString:@"1"]) {
                
            }
        }else{
        
            
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
    int i;
    if (  i ==1) {
        NSPlayMusicViewController * playVC = [NSPlayMusicViewController sharedPlayMusic];
        playVC.itemId = itemId;
        [self.navigationController pushViewController: playVC animated:YES];
    }else{
        NSH5ViewController * eventVC =[[NSH5ViewController alloc] init];
        eventVC.h5Url = @"url";
        [self.navigationController pushViewController:eventVC animated:YES];
    
    }

}

@end
