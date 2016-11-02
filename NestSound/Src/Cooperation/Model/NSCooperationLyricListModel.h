//
//  NSCooperationLyricListModel.h
//  NestSound
//
//  Created by yinchao on 2016/11/1.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"


@protocol CooperationLyricListModel <NSObject>

@end

@interface CooperationLyricListModel : NSBaseModel
@property (nonatomic,assign) long lyricId;
@property (nonatomic,assign) long createTime;
@property (nonatomic,assign) int isOpened;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *lyric;
@property (nonatomic,copy) NSString *author;
@end

@interface NSCooperationLyricListModel : NSBaseModel
@property (nonatomic, strong) NSArray <CooperationLyricListModel> *cooperationLyricList;
@end
