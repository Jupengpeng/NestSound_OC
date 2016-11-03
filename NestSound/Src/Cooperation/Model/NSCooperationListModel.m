//
//  NSCooperationListModel.m
//  NestSound
//
//  Created by yinchao on 2016/10/31.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSCooperationListModel.h"

@implementation CooperationModel

- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"cooperationId":@"id",
             @"cooperationTitle":@"title",
             @"cooperationLyric":@"lyrics",
             @"requiement":@"requirement",
             @"commentNum":@"commentnum",
             @"createTime":@"createtime",
             @"workNum":@"worknum"};
}

@end



@implementation CooperationCommentModel

- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"nickName":@"nickname",
             @"comment":@"comment"};
}

@end


@implementation CooperationUser

- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"nickName":@"nickname",
             @"headerUrl":@"headurl",
             @"uId":@"uid"};
}

@end


@implementation MainCooperationListModel

- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"cooperationUser":@"userInfo",
             @"cooperationCommentList":@"commentList",
             @"cooperation":@"demandInfo"};
}

@end

@implementation NSCooperationListModel

- (NSDictionary *)modelKeyJSONKeyMapper {
//    return @{@"cooperationList":@"data",
//             @"commentList":@"data",
//             @"cooperationUser":@"data"};
    return @{@"mainCooperationList":@"data"};
}

@end
