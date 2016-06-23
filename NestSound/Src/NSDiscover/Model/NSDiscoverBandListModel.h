//
//  NSDiscoverBandListModel.h
//  NestSound
//
//  Created by 谢豪杰 on 16/5/24.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"




@protocol NSBandMusic <NSObject>
@end

@interface NSBandMusic : NSBaseModel

@property (nonatomic,copy) NSString * author;
@property (nonatomic,copy) NSString * workName;
@property (nonatomic,copy) NSString * titleImageUrl;
@property (nonatomic,assign) NSTimeInterval  createDate;
@property (nonatomic,assign) long fovNum;
@property (nonatomic,assign) long lookNum;
@property (nonatomic,assign) long zanNum;
@property (nonatomic,assign) long itemId;


@end


@interface NSDiscoverBandListModel : NSBaseModel

@property (nonatomic,strong) NSArray <NSBandMusic>* BandLyricList;
@property (nonatomic,strong) NSArray <NSBandMusic> * BandMusicList;

@end
