//
//  NSDicoverLyricListModel.h
//  NestSound
//
//  Created by 谢豪杰 on 16/5/24.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"
#import "NSMusicModel.h"



@interface NSLyricListModel : NSBaseModel


@property (nonatomic,strong) NSArray <NSMusicModel> * lyricList;

@end

@interface NSHotLyricListModel : NSBaseModel

@property (nonatomic,strong) NSArray <NSMusicModel> * hotLyricList;
@end

@interface NSDicoverLyricListModel : NSBaseModel

@property (nonatomic,strong) NSLyricListModel * LyricList;
@property (nonatomic,strong) NSHotLyricListModel * HotLyricList;

@end
