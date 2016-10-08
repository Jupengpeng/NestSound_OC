//
//  NSPreserveDetailListModel.m
//  NestSound
//
//  Created by yinchao on 16/10/8.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSPreserveDetailListModel.h"

@implementation NSProductModel

- (NSDictionary *)modelKeyJSONKeyMapper {
    
    return @{@"productId":@"id",
             @"productTitle":@"title",
             @"lyricAuthor":@"lyricAuthor",
             @"songAuthor":@"songAuthor",
             @"accompaniment":@"accompaniment",
             @"createTime":@"createTime",
             @"productImg":@"image",
             @"preserveTime":@"preserveDate",
             @"preserveNo":@"preserveID",
             @"type":@"type"};
}

@end


@implementation NSProductListModel

- (NSDictionary *)modelKeyJSONKeyMapper {
    
    return @{@"productModel":@"productInfo"};
}

@end

@implementation NSPersonModel

- (NSDictionary *)modelKeyJSONKeyMapper {
    
    return @{@"userPhone":@"cPhone",
             @"userName":@"cUserName",
             @"userIDNo":@"cCardId",
             @"userIdentity":@"c_sort_id"};
}

@end

@implementation NSPersonListModel

- (NSDictionary *)modelKeyJSONKeyMapper {
    
    return @{@"personModel":@"personInfo"};
}

@end


@implementation NSPreserveResultModel

- (NSDictionary *)modelKeyJSONKeyMapper {
    
    return @{@"certificateURL":@"certUrl",
             @"status":@"statu",
             @"preserveId":@"id"};
}

@end

@implementation NSPreserveDetailListModel

- (NSDictionary *)modelKeyJSONKeyMapper {
    
    return @{@"productModel":@"data",
             @"personModel":@"data",
             @"preserveResultModel":@"data"};
}

@end
