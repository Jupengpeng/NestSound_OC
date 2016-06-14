//
//  NSQiniuModel.m
//  NestSound
//
//  Created by 谢豪杰 on 16/6/14.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSQiniuModel.h"

@implementation NSQiniuModel

-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"fileName":@"filename",@"token":@"token",@"QiniuDomain":@"domain_qiliu"};

}

@end

@implementation QiniuDetail
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"qiniuDetail":@"data"};
}
@end