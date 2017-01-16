//
//  NSSoundEffectViewController.h
//  NestSound
//
//  Created by yinchao on 16/8/16.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseViewController.h"
#import "NSWaveformView.h"
@class CoWorkModel;

@interface NSSoundEffectViewController : NSBaseViewController
@property (nonatomic, assign) CGFloat musicTime;
@property (nonatomic, strong) NSMutableDictionary *parameterDic;
@property (nonatomic,assign) long lyricId;
@property (nonatomic, copy) NSString *mp3File;
@property (nonatomic,assign) BOOL isLyric;
@property (nonatomic, strong) NSString *mp3URL;
@property (nonatomic, strong) NSMutableArray *locationArr;
@property (nonatomic, strong) NSArray *heightArray;


@property (nonatomic,copy) NSString *recordPCMPath;
@property (nonatomic,copy) NSString *accompanyPCMPath;
//歌曲成品
@property (nonatomic,strong) CoWorkModel *coWorkModel;

@property (nonatomic,strong) NSMutableDictionary *totalTimeLocDict;

@end
