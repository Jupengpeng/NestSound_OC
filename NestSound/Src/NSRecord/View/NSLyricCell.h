//
//  NSLyricCell.h
//  NestSound
//
//  Created by 谢豪杰 on 16/5/11.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NSMyLyricModel;
@interface NSLyricCell : UICollectionViewCell

@property (nonatomic,copy) NSString * lyricName;
@property (nonatomic,copy) NSString * authorName;
@property (nonatomic,copy) NSString * titlePageUrl;

@property (nonatomic,strong) NSMyLyricModel * myLyricModel;

@end
