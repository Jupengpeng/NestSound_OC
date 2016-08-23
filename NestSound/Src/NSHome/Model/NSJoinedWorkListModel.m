//
//  NSJoinedWorkListModel.m
//  NestSound
//
//  Created by 鞠鹏 on 16/8/19.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSJoinedWorkListModel.h"




@implementation NSJoinWorkCommentModel


-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"commentId":@"id",
             @"target_uid":@"target_uid",
             @"headerurl":@"headerurl",
             @"uid":@"uid",
             @"comment_type":@"comment_type",
             @"isread":@"isread",
             @"comment":@"comment",
             @"targetheaderurl":@"targetheaderurl",
             @"type":@"type",
             @"target_nickname":@"target_nickname",
             @"itemid":@"itemid",
             @"nickname":@"nickname",
             @"createdate":@"createdate"
             };
}

@end

//@implementation NSJoinWorkCommentDataListModel
//
//
//-(NSDictionary *)modelKeyJSONKeyMapper
//{
//    return @{@"joinerList":@"data",
//             @"code":@"code",
//             @"message":@"message"
//             };
//}
//
//@end




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
             @"workCommonList":@"listComment",
             @"mp3":@"mp3"
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
