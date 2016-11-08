//
//  NSCooperationMessageViewController.h
//  NestSound
//
//  Created by yinchao on 16/10/28.
//  Copyright © 2016年 yinchao. All rights reserved.
//

typedef void(^NSCooperationMessageViewControllerBlock)(void);

#import "NSBaseViewController.h"

@interface NSCooperationMessageViewController : NSBaseViewController
@property (nonatomic, assign) int cooperationId;

@property (nonatomic,copy) NSCooperationMessageViewControllerBlock msgActBlock;

@end
