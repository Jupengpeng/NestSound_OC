//
//  NSPreservePersonListModel.m
//  NestSound
//
//  Created by yinchao on 16/9/28.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSPreservePersonListModel.h"

@implementation NSPreservePersonListModel

- (NSDictionary *)modelKeyJSONKeyMapper {
    
    return @{@"preservePerList":@"data"};
}

@end


@implementation NSPreservePersonModel

- (NSDictionary *)modelKeyJSONKeyMapper {
    
    return @{@"userName":@"bq_username",
             @"userPhone":@"bq_phone",
             @"userId":@"bq_creditID"
             };
}

@end