//
//  NSRecommendCell.h
//  NestSound
//
//  Created by 谢豪杰 on 16/4/29.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>


@class NSMusicModel;
@class NSNew;
@interface NSRecommendCell : UICollectionViewCell


@property (nonatomic,strong) NSMusicModel * recommend;

@property (nonatomic,strong) NSNew * songNew;
@property (nonatomic,assign) BOOL isMusic;

@end
