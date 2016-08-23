//
//  NSMusicianListModel.h
//  NestSound
//
//  Created by 鞠鹏 on 16/8/20.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"


/**
 *  音乐人列表部分
 */
@protocol NSMusicianListDetailModel <NSObject>
@end

@interface NSMusicianListDetailModel : NSBaseModel


@property (nonatomic, assign) NSInteger musicianId;

@property (nonatomic, copy) NSString *pic;

@property (nonatomic, copy) NSString *sort;

@property (nonatomic, copy) NSString *ability;

@property (nonatomic, copy) NSString *name;


@end


@interface NSMusicianListModel : NSBaseModel


@property (nonatomic,strong) NSArray<NSMusicianListDetailModel> *musicianList;

@end











