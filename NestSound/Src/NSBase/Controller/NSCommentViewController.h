//
//  NSCommentViewController.h
//  NestSound
//
//  Created by Apple on 16/5/25.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseViewController.h"

typedef void(^NSCommentExecutedBlock)(void);

@interface NSCommentViewController : NSBaseViewController


@property (nonatomic, copy) NSString *musicName;

@property (nonatomic,copy) NSCommentExecutedBlock commentExecuteBlock;

-(instancetype)initWithItemId:(long)itemid andType:(int)type_;

@end
