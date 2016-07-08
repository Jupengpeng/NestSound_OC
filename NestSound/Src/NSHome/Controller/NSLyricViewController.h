//
//  NSLyricViewController.h
//  NestSound
//
//  Created by Apple on 16/5/5.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseViewController.h"

typedef NS_ENUM(NSUInteger, Whose) {
    
    My,
    
    His,
    
};


@interface NSLyricViewController : NSBaseViewController

@property (nonatomic, assign) Whose who;

-(instancetype)initWithItemId:(long) itemId_;


@end
