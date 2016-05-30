//
//  NSAccommpanyListModel.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/27.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSAccommpanyListModel.h"


@implementation NSAccommpanyModel
-(NSDictionary *)modelKeyJSONKeyMapper
{

    return @{@"itemID":@"id",
             @"mp3URL":@"mp3",
             @"author":@"author",
             @"title":@"title",
             @"titleImageUrl":@"pic",
             @"mp3Times":@"mp3times"
             };
}
@end

@implementation NSAccommpanyListModel
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"accommpanyList":@"data"};

}


@end
