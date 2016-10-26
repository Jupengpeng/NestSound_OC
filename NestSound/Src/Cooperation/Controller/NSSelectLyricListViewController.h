//
//  NSSelectLyricListViewController.h
//  NestSound
//
//  Created by yinchao on 16/10/26.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseViewController.h"

@protocol NSSelectLyricListViewControllerDelegate <NSObject>
-(void)selectLyric:(NSString *)lyricId withLyricTitle:(NSString *)LyricTitle;

@end

@interface NSSelectLyricListViewController : NSBaseViewController

@property (nonatomic, assign) id <NSSelectLyricListViewControllerDelegate> delegate;

@end
