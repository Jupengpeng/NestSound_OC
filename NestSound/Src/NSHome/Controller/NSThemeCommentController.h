//
//  NSThemeCommentController.h
//  NestSound
//
//  Created by 鞠鹏 on 16/8/15.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseViewController.h"

@interface NSThemeCommentController : NSBaseViewController

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic, assign) BOOL canScroll;

/**
 *  活动id
 */
@property (nonatomic,copy) NSString *aid;

/**
 *  类型  0 -> 歌曲 1 -> 歌词
 */
@property (nonatomic,copy) NSString *type;

@property (nonatomic,assign) int sort;

@property (nonatomic,assign) int page;

@end
