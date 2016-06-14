//
//  NSMessageListModel.m
//  NestSound
//
//  Created by 谢豪杰 on 16/5/25.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSMessageListModel.h"



@implementation messageCountModel
-(NSDictionary *)modelKeyJSONKeyMapper
{
    return @{@"commentCount":@"commentnum",
             @"upvoteCount":@"zannum",
             @"collecCount":@"fovnum",
             @"systemCount":@"sysmsg"};

}

@end



@implementation NSMessageListModel

-(NSDictionary *)modelKeyJSONKeyMapper
{

    return @{@"messageCount":@"data",@"code":@"code"};
    
}

@end
