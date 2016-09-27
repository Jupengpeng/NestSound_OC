//
//  NSAccommpanyListModel.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/27.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSAccommpanyListModel.h"


@implementation NSAccommpanyModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.titleImageUrl forKey:@"titleImageUrl"];
    [aCoder encodeObject:self.mp3URL forKey:@"mp3URL"];
    [aCoder encodeInt:self.mp3Times forKey:@"mp3Times"];
    [aCoder encodeInteger:self.itemID forKey:@"itemID"];
    [aCoder encodeObject:self.author forKey:@"author"];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.titleImageUrl = [aDecoder decodeObjectForKey:@"titleImageUrl"];
        self.mp3URL = [aDecoder decodeObjectForKey:@"mp3URL"];
        self.mp3Times = [aDecoder decodeIntForKey:@"mp3Times"];
        self.itemID = [aDecoder decodeIntForKey:@"itemID"];
        self.author = [aDecoder decodeObjectForKey:@"author"];
    }
    return self;
}

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

- (instancetype)init{
    self = [super init];
    if (self) {
        self.simpleCategoryList =[[NSSimpleCategoryListModel alloc]init];
        self.simpleList = [[NSSimpleListModel alloc]init];
    }
    return self;
}

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
    [aCoder encodeObject:self.playUrl forKey:@"playUrl"];
    [aCoder encodeInteger:self.playTimes forKey:@"playTimes"];
    [aCoder encodeInteger:self.itemID forKey:@"itemID"];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.titleImageUrl = [aDecoder decodeObjectForKey:@"titleImageUrl"];
        self.playUrl = [aDecoder decodeObjectForKey:@"playUrl"];
        self.playTimes = [aDecoder decodeIntForKey:@"playTimes"];
        self.itemID = [aDecoder decodeIntForKey:@"itemID"];
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


