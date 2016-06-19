//
//  NSInspirtationModel.m
//  NestSound
//
//  Created by 谢豪杰 on 16/6/19.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSInspirtationModel.h"

@implementation NSInspirtationModel
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"inspirtationModel":@"data"};
}
@end

@implementation NSInspirtation
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"itemID":@"itemid",
@"userID":@"userid",@"spireContent":@"spirecontent",@"pics":@"pics",@"audio":@"audio",@"createDate":@"createdate",@"audioDomain":@"audiodomain",@"picDomain":@"picdomain"};
}
@end