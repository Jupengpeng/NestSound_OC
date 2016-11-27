//
//  NSLocalProductViewController.h
//  NestSound
//
//  Created by yinchao on 2016/11/22.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseViewController.h"

typedef NS_ENUM(NSUInteger, LocalOrCache) {
    
    LocalProduct = 1,
    
    AccompanyCache = 2,
    
};

@interface NSLocalProductViewController : NSBaseViewController
@property (nonatomic,assign) LocalOrCache viewFrom;
@end
