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

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.titleImageUrl forKey:@"titleImageUrl"];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.titleImageUrl = [aDecoder decodeObjectForKey:@"titleImageUrl"];
    }
    return self;
}
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
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.categoryPic forKey:@"categoryPic"];
    [aCoder encodeObject:self.categoryName forKey:@"categoryname"];
    [aCoder encodeInteger:self.categoryId forKey:@"categoryId"];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.categoryPic = [aDecoder decodeObjectForKey:@"categoryPic"];
        self.categoryName = [aDecoder decodeObjectForKey:@"categoryname"];
        self.categoryId = [aDecoder decodeIntegerForKey:@"categoryId"];
    }
    return self;
}
- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"categoryName":@"categoryname",
             @"categoryId":@"id",
             @"categoryPic":@"categorypic"};
}

@end


