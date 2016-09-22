//
//  NSUserDataModel.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/27.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSUserDataModel.h"



@implementation UserOtherModel
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"fansNum":@"fansnum",
             @"focusNum":@"gznum",
             @"pushFocusNum":@"focusnum",
             @"lyricsNum":@"lyricsnum",
             @"workNum":@"worknum",
             @"inspireNum":@"inspirenum",
             @"collectionNum":@"fovnum",
             @"isFocus":@"isFocus"
             };
}
@end

@implementation UserModel
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"fansNum":@"fansnum",
             @"focusNum":@"gznum",
             @"userId":@"uid",
             @"headerUrl":@"headurl",
             @"nickName":@"nickname",
             @"signature":@"signature",
             @"bgPic":@"bgpic"};
}

@end


@implementation UserDataModel
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"userModel":@"user"};

}

@end

@implementation MyMusicList
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"musicList":@"list"};

}
@end


@implementation NSUserDataModel
-(NSDictionary *)modelKeyJSONKeyMapper
{

    return @{@"userDataModel":@"data",
             @"myMusicList":@"data",
             @"userOtherModel":@"data"
             };
}


@end
