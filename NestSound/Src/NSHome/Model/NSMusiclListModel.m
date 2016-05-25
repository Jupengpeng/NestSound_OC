//
//  NSMusiclListModel.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/23.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSMusiclListModel.h"



@implementation NSMusiclListModel

-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"musicList":@"data"};
}

@end
