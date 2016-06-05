//
//  NSUserModel.m
//  NestSound
//
//  Created by 谢豪杰 on 16/6/3.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSUserModel.h"

@implementation userModel
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"headerURL":@"headurl",
             @"loginToken":@"loginToken",
             @"userName":@"name",
             @"userID":@"userid"};
}

@end

@implementation NSUserModel
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"userDetail":@"data"};
}

@end
