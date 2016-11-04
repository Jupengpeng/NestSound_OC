//
//  NSCooperationDetailModel.m
//  NestSound
//
//  Created by yintao on 2016/11/2.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSCooperationDetailModel.h"

@implementation NSCooperationDetailModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"completeList" : [CoWorkModel class],
             @"commentList" : [CommentModel class],
             @"userInfo" : @"userInfo" ,
             @"demandInfo":@"demandInfo"};
}
@end

@implementation UserinfoModel

@end


@implementation DemandinfoModel

@end


@implementation CoWorkModel


@end


@implementation CommentModel

@synthesize id = _id;

@end
