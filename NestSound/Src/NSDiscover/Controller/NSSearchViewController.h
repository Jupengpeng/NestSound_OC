//
//  NSSearchViewController.h
//  NestSound
//
//  Created by Apple on 16/5/30.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseViewController.h"
@class NSSearchViewController;

@protocol NSSearchViewControllerDelegate <NSObject>

//歌曲
- (void)searchMusicViewController:(NSSearchViewController *)searchVC withItemId:(long)itemID withType:(int)type;

//歌词
- (void)searchLyricViewController:(NSSearchViewController *)searchVC withItemId:(long)itemID;

//用户
- (void)searchViewController:(NSSearchViewController *)searchVC withUserID:(long)userID;

@end

@interface NSSearchViewController : NSBaseViewController

- (void)fetchData:(NSString *)name;

@property (nonatomic, weak) id<NSSearchViewControllerDelegate> delegate1;

@end
