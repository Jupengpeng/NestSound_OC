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
@protocol NSMusicianDetailModel <NSObject>
@end

@interface NSMusicianDetailModel : NSBaseModel


@property (nonatomic, assign) NSInteger musicianId;

@property (nonatomic, copy) NSString *pic;

@property (nonatomic, copy) NSString *sort;

@property (nonatomic, copy) NSString *ability;

@property (nonatomic, copy) NSString *name;


@end


@interface NSMusicianListModel : NSBaseModel


@property (nonatomic,strong) NSArray<NSMusicianDetailModel> *musicianList;

@end


/**
 *  音乐人 详情 部分
 */

@interface NSMusiciaDetailModel : NSBaseModel


@property (nonatomic,strong) NSArray<NSMusicianDetailModel> *musicianList;

@end

@interface musician : NSBaseModel


@property (nonatomic,strong) NSArray<NSMusicianDetailModel> *musicianList;

@end



@interface worklist : NSBaseModel


@property (nonatomic,strong) NSArray<NSMusicianDetailModel> *musicianList;

@end






