//
//  NSUserWorkListController.h
//  NestSound
//
//  Created by 鞠鹏 on 16/8/23.
//  Copyright © 2016年 yinchao. All rights reserved.
//

typedef void(^NSUserWorkListControllerSubmitWorkBlock)(void);

#import "NSBaseViewController.h"

@interface NSUserWorkListController : NSBaseViewController

/**
 *   0 -> 歌曲 1 - > 歌词
 */
@property (nonatomic,copy) NSString *workType;

@property (nonatomic,copy) NSString *activityId;

@property (nonatomic,copy) NSUserWorkListControllerSubmitWorkBlock submitBlock;

@end
