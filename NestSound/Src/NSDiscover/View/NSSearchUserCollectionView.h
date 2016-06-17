//
//  NSSearchUserCollectionView.h
//  NestSound
//
//  Created by Apple on 16/5/30.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NSSearchUserCollectionView;

@protocol NSSearchUserCollectionViewDelegate <NSObject>

- (void)searchUserCollectionView:(NSSearchUserCollectionView *)collectionView withUserID:(long)userID;

@end

@interface NSSearchUserCollectionView : UICollectionView

@property (nonatomic,strong) NSMutableArray * dataAry;

@property (nonatomic, weak) id<NSSearchUserCollectionViewDelegate> delegate1;

@end
