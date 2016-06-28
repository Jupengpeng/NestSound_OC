//
//  NSFansListModel.m
//  NestSound
//
//  Created by 谢豪杰 on 16/6/5.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSFansListModel.h"




@implementation NSFansListModel
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"fansListModel":@"data"};
}
@end


@implementation NSFansModel
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"fansID":@"fansid",
             @"userID":@"userid",
             @"status":@"status",
             @"fansSign":@"fansign",
             @"fansName":@"fansname",
             @"fansHeadURL":@"headurl"};

}

@end
