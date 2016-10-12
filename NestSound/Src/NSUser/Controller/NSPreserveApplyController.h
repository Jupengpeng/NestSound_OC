//
//  NSPreserveApplyController.h
//  NestSound
//
//  Created by yintao on 16/9/13.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseViewController.h"

@interface NSPreserveApplyController : NSBaseViewController

@property (nonatomic,assign) long itemUid;

//1= 歌词 2= 歌曲
@property (nonatomic,copy) NSString *sortId;

@end
