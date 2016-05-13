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
    [self configureUIAppearance];
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



#pragma mark collectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return activityAry.count;

}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSActivityCollectionCell * activityCell = [collectionView dequeueReusableCellWithReuseIdentifier:activityCellIdentity forIndexPath:indexPath];
    activityCell.state = @"1";
    activityCell.date = @"5月1日~5月6日";
    activityCell.imageUrl = @"http://7xru8x.com2.z0.glb.qiniucdn.com/%E5%A6%88%E5%A6%88-%E6%B4%BB%E5%8A%A8-0002.png";
    return activityCell;

}

#pragma mark collectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSH5ViewController * eventVC = [[NSH5ViewController alloc] init];
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
