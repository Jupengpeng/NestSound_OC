//
//  NSSearchUserCollectionView.m
//  NestSound
//
//  Created by Apple on 16/5/30.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSSearchUserCollectionView.h"
#import "NSSearchUserCollectionViewCell.h"
#import "NSSearchUserListModel.h"
@interface NSSearchUserCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation NSSearchUserCollectionView

static NSString * const identifier = @"identifierCell";

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    
    if (self) {
        
        self.backgroundColor = [UIColor hexColorFloat:@"f8f8f8"];
        
        self.delegate = self;
        
        self.dataSource = self;
        self.dataAry = [NSMutableArray array];
        [self registerClass:[NSSearchUserCollectionViewCell class] forCellWithReuseIdentifier:identifier];
        
    }
    
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _dataAry.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSSearchUserModel * user = _dataAry[indexPath.row];
    NSSearchUserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.searchUser = user;
    return cell;
}

-(void)setDataAry:(NSMutableArray *)dataAry
{
    _dataAry = dataAry;
    [self reloadData];
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate1 respondsToSelector:@selector(searchUserCollectionView:withUserID:)]) {
        NSSearchUserModel * user = _dataAry[indexPath.row];
        [self.delegate1 searchUserCollectionView:self withUserID:user.userID];
    }
}

@end








