//
//  NSAccommpanyListModel.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/27.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSAccommpanyListModel.h"


@implementation NSAccommpanyModel
-(NSDictionary *)modelKeyJSONKeyMapper
{

    return @{@"itemID":@"id",
             @"mp3URL":@"mp3",
             @"author":@"author",
             @"title":@"title",
             @"titleImageUrl":@"pic",
             @"mp3Times":@"mp3times",
             @"useTime":@"usenum"
             };
}
@end

@implementation NSAccommpanyListModel
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"accommpanyList":@"data",
             @"simpleList":@"data",
             @"simpleCategoryList":@"data"};

}


@end

@implementation NSSimpleListModel

- (NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"simpleSingList":@"simplesing"};
}

@end


@implementation NSSimpleSingModel

- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"itemID":@"id",
             @"author":@"author",
             @"playUrl":@"mp3",
             @"title":@"title",
             @"titleImageUrl":@"pic",
             @"playTimes":@"mp3times"};
}

@end


@implementation NSSimpleCategoryListModel

- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"simpleCategory":@"list"};
}

@end

@implementation NSSimpleCategoryModel

- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"categoryName":@"categoryname",
             @"categoryId":@"id",
             @"categoryPic":@"categorypic"};
}

@end


