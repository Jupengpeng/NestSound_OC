//
//  XiangQuToastManager.h
//  XiangQu
//
//  Created by yandi on 14/10/29.
//  Copyright (c) 2014年 yinchao. All rights reserved.
//

#import "MBProgressHUD.h"


@interface NSToastManager : NSObject
+ (instancetype)manager;

// toast
- (void)showtoast:(NSString *)toastStr;

// progress
- (void)hideprogress;
- (void)showprogress;

@end
