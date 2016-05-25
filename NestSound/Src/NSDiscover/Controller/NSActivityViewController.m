//
//  NSActivityViewController.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/8.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSActivityViewController.h"
#import "NSActivityCollectionCell.h"
#import "NSH5ViewController.h"
#import "NSActivityListModel.h"
@interface NSActivityViewController ()<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
>
{
    UICollectionView * activityColl;
    NSMutableArray * activityAry;

}

@end

static NSString * const activityCellIdentity  = @"activityCellIdentity";

@implementation NSActivityViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchData];
}



#pragma makr -configureUIAppearance
-(void)configureUIAppearance
{
    
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    
    //activityColl
    activityColl = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    activityColl.dataSource = self;
    activityColl.delegate = self;
    activityColl.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
    [activityColl registerClass:[NSActivityCollectionCell class] forCellWithReuseIdentifier:activityCellIdentity];
    [self.view addSubview:activityColl];
    
    //constaints
    [activityColl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    
}

#pragma  mark -fetchData
-(void)fetchData
{
    self.requestType = YES;
    self.requestParams = nil;
    NSDictionary * dic = @{@"name":@"what"};
    NSDictionary * dic1 = [[NSHttpClient client] encryptWithDictionary:@{@"data":dic} isEncrypt:YES];
    NSString * str = [NSString stringWithFormat:@"data=%@",[dic1 objectForKey:requestData]];
    self.requestURL = [dicoverActivityURL stringByAppendingString:str];
}

#pragma mark -actiontFetchData
-(void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(NSBaseModel *)parserObject error:(NSError *)requestErr
{
    if (!parserObject.success) {
        NSActivityListModel * activityListModel = (NSActivityListModel *)parserObject;
        activityAry = [NSMutableArray arrayWithArray:activityListModel.ActivityList];
    }
    [self configureUIAppearance];

}

#pragma mark collectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return activityAry.count;

}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSActivityCollectionCell * activityCell = [collectionView dequeueReusableCellWithReuseIdentifier:activityCellIdentity forIndexPath:indexPath];
    activityCell.activityModel = activityAry[indexPath.row];
    return activityCell;

}

#pragma mark collectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSH5ViewController * eventVC = [[NSH5ViewController alloc] init];
    NSActivity * activity = activityAry[indexPath.row];
    eventVC.h5Url = activity.activityUrl;
    [self.navigationController pushViewController:eventVC animated:YES];

}



#pragma mark UICollectionViewDelegateFlowLayout
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{

    return 10;
    
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 15, 0, 15);
}

@end
