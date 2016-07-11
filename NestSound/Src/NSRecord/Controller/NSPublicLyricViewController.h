//
//  NSPublicLyricViewController.h
//  NestSound
//
//  Created by 谢豪杰 on 16/5/11.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseViewController.h"

@interface NSPublicLyricViewController : NSBaseViewController

@property (nonatomic, copy) NSString *mp3File;
@property (nonatomic, copy) NSString *lyricDetail,*lyricImgUrl;
-(instancetype)initWithLyricDic:(NSMutableDictionary *)LyricDic_ withType:(BOOL)isLyric_;

@end
