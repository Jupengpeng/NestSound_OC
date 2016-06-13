//
//  NSMyLricListModel.h
//  NestSound
//
//  Created by 谢豪杰 on 16/5/30.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"


@protocol  NSMyLyricModel <NSObject>
@end

@interface NSMyLyricModel : NSBaseModel
@property (nonatomic,assign) long itemId;
@property (nonatomic,assign) long lookNum;
@property (nonatomic,copy) NSString * author;
@property (nonatomic,copy) NSString * lyrics;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * titleImageUrl;


@end


@interface NSMyLricListModel : NSBaseModel

@property (nonatomic,strong) NSArray <NSMyLyricModel> * myLyricList;

@end
