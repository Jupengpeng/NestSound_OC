//
//  NSAccommpanyListModel.h
//  NestSound
//
//  Created by 谢豪杰 on 16/5/27.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"

@protocol NSAccommpanyModel <NSObject>
@end

@interface NSAccommpanyModel : NSBaseModel

@property (nonatomic,assign) long itemID;
@property (nonatomic,assign) int mp3Times;
@property (nonatomic,copy) NSString * mp3URL;
@property (nonatomic,copy) NSString * author;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * titleImageUrl;

@end

@interface NSAccommpanyListModel : NSBaseModel


@property (nonatomic,assign) int totalCount;
@property (nonatomic,strong) NSArray <NSAccommpanyModel> * accommpanyList;

@end
