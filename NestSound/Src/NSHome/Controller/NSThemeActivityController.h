//
//  ThemeActivityController.h
//  NestSound
//
//  Created by 鞠鹏 on 16/8/15.
//  Copyright © 2016年 yinchao. All rights reserved.
//

/**
 *  定制工坊 ——> 专题活动
 */

#import "NSBaseViewController.h"

@interface NSThemeActivityController : NSBaseViewController

/**
 *  活动id
 */
@property (nonatomic,copy) NSString *aid;

/**
 *  类型  0 -> 歌曲 1 -> 歌词
 */
@property (nonatomic,copy) NSString *type;


@property (nonatomic,assign) BOOL needRefresh;

@end
