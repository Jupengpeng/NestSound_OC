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
#import "NSActivityListModel.h"
#import "NSLyricDetailModel.h"
@implementation NSModelFactory
+ (NSBaseModel *)modelWithURL:(NSString *)url responseJson:(NSDictionary *)jsonDict {
    
  
    if ([url isEqualToString:indexURL]) {
        NSLog(@"jsonDict%@",jsonDict);
        return [[NSIndexModel alloc] initWithJSONDict:jsonDict];
        
    }else if ([url isEqualToString:dicoverActivityURL]){
    
        return [[NSActivityListModel alloc] initWithJSONDict:jsonDict];
    }else if([url isEqualToString:dicoverMusicURL]){
        return [[NSDiscoverMusicListModel alloc] initWithJSONDict:jsonDict];
    }else if ([url isEqualToString:@"123"]){
    
        return [[NSDicoverLyricListModel alloc] initWithJSONDict:jsonDict];
    }else if ([url isEqualToString:lyricDetailURL]){
        
        return [[NSLyricDetailModel alloc] initWithJSONDict:jsonDict];
    
    }
    
        return [[NSBaseModel alloc] initWithJSONDict:jsonDict];
    
}





@end
