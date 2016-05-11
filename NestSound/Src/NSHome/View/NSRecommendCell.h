//
//  NSRecommendCell.h
//  NestSound
//
//  Created by 谢豪杰 on 16/4/29.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSRecommendCell : UICollectionViewCell

@property (nonatomic,copy)NSString * authorName;
@property (nonatomic,copy)NSString * workName;
@property (nonatomic,copy)NSString * playCount;
@property (nonatomic,copy)NSString * imgeUrl;
@property (nonatomic,copy)NSString * type;


@end
