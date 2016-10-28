//
//  NSLyricDetailViewController.h
//  NestSound
//
//  Created by yinchao on 16/10/27.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseViewController.h"


typedef void(^returnLyric)(NSString *lyricTitle,NSString*lyricId);

@interface NSLyricDetailViewController : NSBaseViewController

@property (nonatomic,copy) returnLyric lyricBlock;
//- (void)returnLyricWithBlock:(returnLyric)block;
//- (instancetype)initWithBlock:(returnLyric)block;
@end
