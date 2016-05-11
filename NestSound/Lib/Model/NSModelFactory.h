//
//  MCModelFactory.h
//  MissCandy
//
//  Created by yandi on 15/3/19.
//  Copyright (c) 2015年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"

@interface NSModelFactory : NSObject
+ (NSBaseModel *)modelWithURL:(NSString *)url responseJson:(NSDictionary *)jsonDict;
@end
