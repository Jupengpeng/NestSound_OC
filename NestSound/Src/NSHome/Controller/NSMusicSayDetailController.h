//
//  NSMusicSayDetailController.h
//  NestSound
//
//  Created by yintao on 16/9/22.
//  Copyright © 2016年 yinchao. All rights reserved.
//

/**
 *  越说详情
 */

#import "NSBaseViewController.h"

@interface NSMusicSayDetailController : NSBaseViewController

@property (nonatomic,copy) NSString *itemUid;

@property (nonatomic,copy) NSString *detailStr;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *picUrl;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *contentUrl;
@end
