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
#import "NSActivityListModel.h"
@implementation NSModelFactory
+ (NSBaseModel *)modelWithURL:(NSString *)url responseJson:(NSDictionary *)jsonDict {
    

    if ([url isEqualToString:indexURL]) {
        NSLog(@"jsonDict%@",jsonDict);
        return [[NSIndexModel alloc] initWithJSONDict:jsonDict];
        
    }else if ([url isEqualToString:dicoverActivityURL]){
    
        return [[NSActivityListModel alloc] initWithJSONDict:jsonDict];
    }else if([url isEqualToString:dicoverMusicURL]){
        return [[NSDiscoverMusicListModel alloc] initWithJSONDict:jsonDict];
    }
    
        return [[NSBaseModel alloc] initWithJSONDict:jsonDict];
    
}
@end
