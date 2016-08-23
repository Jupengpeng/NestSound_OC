//
//  NSNSStarMusicianModel.h
//  NestSound
//
//  Created by 鞠鹏 on 16/8/17.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"



/**
 *  音乐人 详情 部分
 */
@interface NSMusicianModel : NSBaseModel



@property (nonatomic, assign) NSInteger musicianId;

@property (nonatomic, copy) NSString *introduction;

@property (nonatomic, copy) NSString *pic;

@property (nonatomic, copy) NSString *musicianDescription;

@property (nonatomic, copy) NSString *ability;

@property (nonatomic, copy) NSString *name;


@end


@protocol  NSWorklistModel<NSObject>
@end

@interface NSWorklistModel : NSBaseModel


@property (nonatomic, assign) NSInteger sort;

@property (nonatomic, assign) NSInteger workId;

@property (nonatomic, copy) NSString *pic;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger mp3time;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *mp3;


@end

@interface NSMusicianDataModel : NSBaseModel


@property (nonatomic,strong) NSMusicianModel *musicianModel;


@end

@interface NSWorklistDataModel : NSBaseModel

@property (nonatomic,strong) NSArray<NSWorklistModel> *workList;



@end


@interface NSStarMusicianModel : NSBaseModel


@property (nonatomic,strong) NSMusicianDataModel *musicianData;

@property (nonatomic,strong) NSWorklistDataModel *worklistData;


@end





