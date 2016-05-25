//
//  NSDiscoverMusicListModel.h
//  NestSound
//
//  Created by 谢豪杰 on 16/5/23.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"
#import "NSIndexModel.h"




@interface NSDiscoverHotList : NSBaseModel

@property (nonatomic,assign) int totalCount;
@property (nonatomic,strong) NSArray <NSRecommend> * hotList;
@end

@interface NSDiscoverNewList : NSBaseModel
@property (nonatomic,assign) int totalCount;
@property (nonatomic,strong) NSArray <NSRecommend> * songList;
@end


@interface NSDiscoverMusicListModel : NSBaseModel

@property (nonatomic,strong) NSDiscoverNewList * SongList;
@property (nonatomic,strong) NSDiscoverHotList * HotList;

@end
