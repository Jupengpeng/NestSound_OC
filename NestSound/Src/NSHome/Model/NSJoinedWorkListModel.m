//
//  NSJoinedWorkListModel.m
//  NestSound
//
//  Created by 鞠鹏 on 16/8/19.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSJoinedWorkListModel.h"






@implementation NSJoinWorkCommentDataListModel


-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"joinerList":@"data",
             @"code":@"code",
             @"message":@"message"
             };
}

@end




@implementation NSJoinedWorkDetailModel


-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"jointime":@"jointime",
             @"author":@"author",
             @"userid":@"userid",
             @"zannum":@"zannum",
             @"pic":@"pic",
             @"title":@"title",
             @"commentnum":@"commentnum",
             @"looknum":@"looknum",
             @"fovnum":@"fovnum",
             @"itemid":@"itemid",
             @"headurl":@"headurl",
             @"nickname":@"nickname",
             @"workCommonList":@"listComment"
             };
}

@end


@implementation NSJoinedWorkListModel

-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"joinWorkList":@"data",

             @"resultMessage":@"message"
             };
}
@end
