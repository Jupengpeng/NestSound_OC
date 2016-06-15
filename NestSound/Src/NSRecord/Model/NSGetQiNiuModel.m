//
//  NSGetQiNiuModel.m
//  NestSound
//
//  Created by 谢豪杰 on 16/6/15.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSGetQiNiuModel.h"

@implementation qiNiu
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"fileName":@"filename",
             @"token":@"token",
             @"qiNIuDomain":@"domain_qiliu"};

}
@end

@implementation NSGetQiNiuModel
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"qiNIuModel":@"data"};
}


@end
