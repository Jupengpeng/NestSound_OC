//
//  NSDiscoverMoreLyricModel.h
//  NestSound
//
//  Created by 谢豪杰 on 16/6/16.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSMyMusicModel.h"
#import "NSCooperateProductModel.h"
@interface NSDiscoverMoreLyricModel : NSBaseModel

@property (nonatomic,strong) NSArray <NSMyMusicModel> * moreLyricList;
@property (nonatomic,strong) NSArray <NSCooperateProductModel> * cooperateProduct;
@end
