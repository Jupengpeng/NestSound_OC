//
//  NSCooperateProductModel.m
//  NestSound
//
//  Created by yintao on 2016/10/26.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSCooperateProductModel.h"

@implementation NSCooperateProductModel
- (NSDictionary *)modelKeyJSONKeyMapper {
    
    return @{@"lyricerId":@"lUid",
             @"lyricerName":@"lUsername",
             @"title":@"title",
             @"itemid":@"itemid",
             @"musicianName":@"wUsername",
             @"musicianUid":@"wUid",
             @"pic":@"pic",
             @"looknum":@"looknum",
             @"fovnum":@"fovnum",
             @"zannum":@"zannum"};
}
@end
