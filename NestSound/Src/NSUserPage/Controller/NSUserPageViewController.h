//
//  NSUserPageViewController.h
//  NestSound
//
//  Created by yandi on 16/4/24.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseViewController.h"

typedef NS_ENUM(NSUInteger, Who) {
    
    Myself,
    
    Other,
    
};

@interface NSUserPageViewController : NSBaseViewController

@property (nonatomic, assign) Who who;

@end
