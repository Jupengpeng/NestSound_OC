//
//  NSPreserveApplyMododel.m
//  NestSound
//
//  Created by yintao on 16/10/9.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSPreserveApplyModel.h"


@implementation NSPreserveProductInfoModel

- (NSDictionary *)modelKeyJSONKeyMapper {
    
    return @{@"productId":@"id",
             @"title":@"title",
             @"lyricAuthor":@"lyricAuthor",
             @"songAuthor":@"songAuthor",
             @"accompaniment":@"accompaniment",
             @"createTime":@"createTime",
             @"imageUrl":@"image",
             @"type":@"type"};
}

@end

@implementation NSPreservePersonInfoModel

- (NSDictionary *)modelKeyJSONKeyMapper {
    
    return @{@"cUserName":@"cUserName",
             @"cCardId":@"cCardId",
             @"cPhone":@"cPhone",
             @"cUid":@"cUid"};
}

@end

@implementation NSPreserveOrderPriceModel
- (NSDictionary *)modelKeyJSONKeyMapper {
    
    return @{@"orderPriceArray":@"orderPrice"};
}

@end

@implementation NSPreserveApplyModel

- (NSDictionary *)modelKeyJSONKeyMapper {
    
    
    return @{@"productInfoModel":@"productInfo",
             @"personInfoModel":@"personInfo",
             @"orderpriceModel":@"orderPrice"};
}

@end


