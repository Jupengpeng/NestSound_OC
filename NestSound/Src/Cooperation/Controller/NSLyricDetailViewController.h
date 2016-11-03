//
//  NSLyricDetailViewController.h
//  NestSound
//
//  Created by yinchao on 16/10/27.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseViewController.h"

@class CooperationLyricModel;
typedef void(^returnLyric)(NSString *lyricTitle,long lyricId);

@interface NSLyricDetailViewController : NSBaseViewController

@property (nonatomic,copy) returnLyric lyricBlock;

@property (nonatomic,strong) CooperationLyricModel *lyricModel;

@end
