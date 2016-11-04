//
//  NSLoginViewController.h
//  NestSound
//
//  Created by 谢豪杰 on 16/5/30.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseViewController.h"

typedef void(^resetMyAndCollectionCooperation)(BOOL isReset);

@interface NSLoginViewController : NSBaseViewController

@property (nonatomic,assign) BOOL isHidden;

@property (nonatomic,copy) resetMyAndCollectionCooperation lonigBlock;
@end
