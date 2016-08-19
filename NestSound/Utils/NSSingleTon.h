//
//  NSSingleTon.h
//  NestSound
//
//  Created by yinchao on 16/8/19.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSSingleTon : NSObject
@property (nonatomic,copy) NSString *viewTag;
@property (nonatomic,assign) int controllersNum;
+ (NSSingleTon *)viewFrom;
@end
