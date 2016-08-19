//
//  NSActivityJoinerListModel.m
//  NestSound
//
//  Created by 鞠鹏 on 16/8/19.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSActivityJoinerListModel.h"

@implementation NSActivityJoinerDetailModel


-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"joinerId":@"id",
             @"nickname":@"nickname",
             @"descr":@"descr",
             @"headurl":@"headurl"
             };
}



@end



@implementation NSActivityJoinerListModel

-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"joinerList":@"data",
             @"code":@"code",
             @"message":@"message"
             };
}


@end
