//
//  NSCooperateProductModel.h
//  NestSound
//
//  Created by yintao on 2016/10/26.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"

@protocol NSCooperateProductModel <NSObject>


@end

@interface NSCooperateProductModel : NSBaseModel
@property (nonatomic,assign) long lyricerId;
@property (nonatomic,copy) NSString *lyricerName;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,assign) long itemid;
@property (nonatomic,copy) NSString *musicianName;
@property (nonatomic,assign) long musicianUid;
@property (nonatomic,copy) NSString *pic;
@property (nonatomic,assign) long looknum;
@property (nonatomic,assign) long fovnum;
@property (nonatomic,assign) long zannum;
@end
