//
//  NSCooperationDetailViewController.h
//  NestSound
//
//  Created by yinchao on 16/10/25.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseViewController.h"

@interface NSCooperationDetailViewController : NSBaseViewController

//是否为我发起的合作作品 yes = 我的

@property (nonatomic,assign) BOOL isMyCoWork;

@property (nonatomic,strong) NSString *detailTitle;

@end
