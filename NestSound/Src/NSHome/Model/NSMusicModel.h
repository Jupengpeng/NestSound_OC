//
//  NSMusicModel.h
//  NestSound
//
//  Created by 谢豪杰 on 16/5/23.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"

@protocol  NSMusicModel <NSObject>

@end

@interface NSMusicModel : NSBaseModel

@property (nonatomic,copy) NSString * titlePageUrl;
@property (nonatomic,copy) NSString * authorName;
@property (nonatomic,assign) int playCount;
@property (nonatomic,copy) NSString * workName;
@property (nonatomic,assign) long  itemId;
@property (nonatomic,assign) int type;
@property (nonatomic,assign) int status;
@end
