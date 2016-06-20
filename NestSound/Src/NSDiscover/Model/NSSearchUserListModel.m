//
//  NSSearchUserListModel.m
//  NestSound
//
//  Created by Apple on 16/6/17.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSSearchUserListModel.h"

@implementation NSSearchUserListModel
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"searchUserList":@"data",@"searchMusicList":@"data"};
    
    
}
@end

@implementation NSSearchUserModel
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"userID":@"uid",
             @"type":@"type",
             @"nickName":@"nickname",
             @"headImageUrl":@"headurl"};

}

@end