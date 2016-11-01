//
//  NSCollectionCooperationListModel.m
//  NestSound
//
//  Created by yinchao on 2016/10/31.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSCollectionCooperationListModel.h"

@implementation CollectionCooperationModel

- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"cooperationId":@"id",
             @"cooperationTitle":@"title",
             @"status":@"status",
             @"nickName":@"nickname",
             @"headerUrl":@"headerurl",
             @"workNum":@"worknum",
             @"createTime":@"createtime",
             @"uId":@"uid"};
}

@end

@implementation NSCollectionCooperationListModel

- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"collectionList":@"data"};
}
@end
