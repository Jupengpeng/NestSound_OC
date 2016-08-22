//
//  NSAccompanyCategoryViewController.h
//  NestSound
//
//  Created by yinchao on 16/8/13.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseViewController.h"

@interface NSAccompanyCategoryViewController : NSBaseViewController

/**
 *  活动id
 */
@property (nonatomic,copy) NSString *aid;

//-(instancetype)initWithItemId:(long)itemID_ andMusicTime:(long)musicTime andHotMp3:(NSString *)hotMp3;
- (instancetype)initWithCategoryId:(long)categoryId andCategoryName:(NSString *)categoryName;
@end
