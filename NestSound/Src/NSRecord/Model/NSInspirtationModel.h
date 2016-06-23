//
//  NSInspirtationModel.h
//  NestSound
//
//  Created by 谢豪杰 on 16/6/19.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"


@interface NSInspirtation : NSBaseModel
@property (nonatomic,assign) long itemID;
@property (nonatomic,assign) long userID;
@property (nonatomic,copy) NSString * spireContent;
@property (nonatomic,copy) NSString * pics;
@property (nonatomic,copy) NSString * audio;
@property (nonatomic,assign) NSTimeInterval  createDate;
@property (nonatomic,copy) NSString * audioDomain;
@property (nonatomic,copy) NSString * picDomain;

@end

@interface NSInspirtationModel : NSBaseModel

@property (nonatomic,strong) NSInspirtation * inspirtationModel;

@end

