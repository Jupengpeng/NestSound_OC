//
//  NSPublicLyricViewController.h
//  NestSound
//
//  Created by 谢豪杰 on 16/5/11.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseViewController.h"


typedef void(^dicBlock)(NSDictionary*);
@interface NSPublicLyricViewController : NSBaseViewController
@property (nonatomic,assign) long lyricId;
@property (nonatomic, copy) NSString *mp3File;
@property (nonatomic,assign)BOOL isLyric;
@property (nonatomic, copy) NSString *mp3URL;

/**
 *  活动
 */
@property (nonatomic,copy) NSString *aid;
-(instancetype)initWithLyricDic:(NSMutableDictionary *)LyricDic_ withType:(BOOL)isLyric_;

@end
