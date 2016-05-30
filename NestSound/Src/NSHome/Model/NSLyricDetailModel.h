//
//  NSLyricDetailModel.h
//  NestSound
//
//  Created by 谢豪杰 on 16/5/26.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"

@interface LyricDetailModel : NSBaseModel

@property (nonatomic,assign) int commentNum;
@property (nonatomic,assign) int fovNum;
@property (nonatomic,assign) int zanNum;
@property (nonatomic,assign) int isCollect;
@property (nonatomic,assign) int isZan;
@property (nonatomic,assign) int status;
@property (nonatomic,assign) long itemId;
@property (nonatomic,assign) long simpleId;
@property (nonatomic,assign) long userId;
@property (nonatomic,strong) NSDate * createDate;
@property (nonatomic,copy) NSString * author;
@property (nonatomic,copy) NSString * lyrics;
@property (nonatomic,copy) NSString * shareUrl;
@property (nonatomic,copy) NSString * titleImageUrl;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * headerUrl;

@end

@interface NSLyricDetailModel : NSBaseModel

@property (nonatomic,strong) LyricDetailModel * lryicDetailModel;
@end
