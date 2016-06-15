//
//  MCModelFactory.m
//  MissCandy
//
//  Created by yandi on 15/3/19.
//  Copyright (c) 2015年 yinchao. All rights reserved.
//

#import "NSModelFactory.h"
#import "NSIndexModel.h"
#import "NSDiscoverMusicListModel.h"
#import "NSDicoverLyricListModel.h"
#import "NSDiscoverBandListModel.h"
#import "NSActivityListModel.h"
#import "NSLyricDetailModel.h"
#import "NSMusicSayListMode.h"
#import "NSSongListModel.h"
#import "NSSingListModel.h"
#import "NSUserModel.h"
#import "NSUserDataModel.h"
#import "NSUpvoteMessageListModel.h"
#import "NSMessageListModel.h"
#import "NSAccommpanyListModel.h"
#import "NSMyLricListModel.h"
#import "NSCommentMessageListModel.h"
#import "NSSystemMessageListModel.h"
#import "NSPlayMusicDetailModel.h"
#import "NSCommentListModel.h"
@implementation NSModelFactory
+ (NSBaseModel *)modelWithURL:(NSString *)url responseJson:(NSDictionary *)jsonDict {
    
  
    if ([url isEqualToString:indexURL]) {
        NSLog(@"jsonDict%@",jsonDict);
        return [[NSIndexModel alloc] initWithJSONDict:jsonDict];
        
    }else if ([url isEqualToString:dicoverActivityURL]){
    
        return [[NSActivityListModel alloc] initWithJSONDict:jsonDict];
    }else if([url isEqualToString:dicoverMusicURL]){
        return [[NSDiscoverMusicListModel alloc] initWithJSONDict:jsonDict];
    }else if ([url isEqualToString:discoverBandURL]){
        return [[NSDiscoverBandListModel alloc] initWithJSONDict:jsonDict];
    }else if ([url isEqualToString:dicoverLyricURL]){
    
        return [[NSDicoverLyricListModel alloc] initWithJSONDict:jsonDict];
    }else if ([url isEqualToString:lyricDetailURL]){
        
        return [[NSLyricDetailModel alloc] initWithJSONDict:jsonDict];
    
    }else if ([url isEqualToString:yueShuoURL]){
    
        return [[NSMusicSayListMode alloc] initWithJSONDict:jsonDict];
    }else if ([url isEqualToString:SongListURL]){
    
        return [[NSSongListModel alloc] initWithJSONDict:jsonDict];
    
    }else if ([url isEqualToString:songListURL]){
    
        return [[NSSingListModel alloc] initWithJSONDict:jsonDict];
    }else if ([url isEqualToString:loginURl]){
        return [[NSUserModel alloc] initWithJSONDict:jsonDict];
    }else if ([url isEqualToString:upvoteMessageURL]){
        return [[NSUpvoteMessageListModel alloc] initWithJSONDict:jsonDict];
    }else if ([url isEqualToString:messageURL]){
        return [[NSMessageListModel alloc] initWithJSONDict:jsonDict];
    }else if ([url isEqualToString:accompanyListURL]){
        return [[NSAccommpanyListModel alloc] initWithJSONDict:jsonDict];
    }else if ([url isEqualToString:myLyricListURL]){
        return [[NSMyLricListModel alloc] initWithJSONDict:jsonDict];
    }else if ([url isEqualToString:collectMessageURL]){
        return [[NSUpvoteMessageListModel alloc] initWithJSONDict:jsonDict];
    }else if ([url isEqualToString:commentMessageURL]){
        return [[NSCommentMessageListModel alloc] initWithJSONDict:jsonDict];
    }else if ([url isEqualToString:systemMessageURL]){
        return [[NSSystemMessageListModel alloc] initWithJSONDict:jsonDict];
    }else if ([url isEqualToString:playMusicURL]){
        return [[NSPlayMusicDetailModel alloc] initWithJSONDict:jsonDict];
    }else if ([url isEqualToString:userCenterURL]){
    
        return [[NSUserDataModel alloc] initWithJSONDict:jsonDict];
    
    }else if ([url isEqualToString:commentURL]){
        return [[NSCommentListModel alloc] initWithJSONDict:jsonDict];
    
    }else if ([url isEqualToString:otherCenterURL]){
        return [[NSUserDataModel alloc] initWithJSONDict:jsonDict];
    }
        return [[NSBaseModel alloc] initWithJSONDict:jsonDict];
    
}





@end
