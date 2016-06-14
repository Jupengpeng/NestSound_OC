//
//  NSCommentViewController.h
//  NestSound
//
//  Created by Apple on 16/5/25.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseViewController.h"

@interface NSCommentViewController : NSBaseViewController


@property (nonatomic, copy) NSString *musicName;

-(instancetype)initWithItemId:(long)itemid andType:(int)type_;

@end
