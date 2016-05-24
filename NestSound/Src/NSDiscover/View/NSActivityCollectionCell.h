//
//  NSActivityCollectionCell.h
//  NestSound
//
//  Created by 谢豪杰 on 16/5/8.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>


@class NSActivity;
@interface NSActivityCollectionCell : UICollectionViewCell

@property (nonatomic,copy) NSString * imageUrl;

@property (nonatomic,copy) NSString * date;

@property (nonatomic,copy) NSString * state;

@property (nonatomic,copy) NSActivity * activityModel;

@end
