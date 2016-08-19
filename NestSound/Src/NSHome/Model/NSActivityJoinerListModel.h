//
//  NSActivityJoinerListModel.h
//  NestSound
//
//  Created by 鞠鹏 on 16/8/19.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"

@protocol NSActivityJoinerDetailModel <NSObject>


@end


@interface NSActivityJoinerDetailModel : NSBaseModel


@property (nonatomic, assign) NSInteger joinerId;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *descr;

@property (nonatomic, copy) NSString *headurl;


@end


@interface NSActivityJoinerListModel : NSBaseModel

@property (nonatomic,strong) NSArray<NSActivityJoinerDetailModel> *joinerList;

@property (nonatomic,assign) int totalCount;

@end


