//
//  IMBaseModel.h
//  iMei
//
//  Created by yandi on 15/3/20.
//  Copyright (c) 2015年 yinchao. All rights reserved.
//

@interface NSBaseModel : NSObject
@property (nonatomic,assign) BOOL success;
@property (nonatomic,copy) NSString *message;
@property (nonatomic,assign) long code;
@property (nonatomic, copy) NSString *data;
- (NSDictionary *)modelKeyJSONKeyMapper;
- (instancetype)initWithJSONDict:(NSDictionary *)dict;
@end
