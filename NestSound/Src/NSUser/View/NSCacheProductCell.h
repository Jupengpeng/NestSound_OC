//
//  NSCacheProductCell.h
//  NestSound
//
//  Created by yinchao on 2016/11/22.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NSAccommpanyModel;
@interface NSCacheProductCell : UITableViewCell
@property (nonatomic, strong) NSAccommpanyModel *accompanyModel;
@property (nonatomic, strong) UIButton *playBtn;
- (void)setupCacheLyricProductWithDictionary:(NSDictionary *)dic;
@end
