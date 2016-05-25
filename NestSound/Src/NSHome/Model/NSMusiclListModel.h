//
//  NSMusiclListModel.h
//  NestSound
//
//  Created by 谢豪杰 on 16/5/23.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"
#import "NSMusicModel.h"

@interface NSMusiclListModel : NSBaseModel

@property (nonatomic,assign) int totalCount;
@property (nonatomic,strong) NSArray <NSMusicModel> * musicList;

@end
