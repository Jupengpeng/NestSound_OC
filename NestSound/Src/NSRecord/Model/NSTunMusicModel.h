//
//  NSTunMusicModel.h
//  NestSound
//
//  Created by 谢豪杰 on 16/6/19.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseModel.h"

@interface TunMusicMoel : NSBaseModel
@property (nonatomic,copy) NSString * oldPath;
@property (nonatomic,copy) NSString * MusicPath;
@end

@interface NSTunMusicModel : NSBaseModel
@property (nonatomic,strong) TunMusicMoel * tunMusicModel;
@end
