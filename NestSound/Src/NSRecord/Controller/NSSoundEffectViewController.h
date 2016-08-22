//
//  NSSoundEffectViewController.h
//  NestSound
//
//  Created by yinchao on 16/8/16.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseViewController.h"
#import "NSWaveformView.h"
@interface NSSoundEffectViewController : NSBaseViewController
@property (nonatomic, copy) NSString *musicTime;
@property (nonatomic, strong) NSMutableDictionary *parameterDic;
@property (nonatomic,assign) long lyricId;
@property (nonatomic, copy) NSString *mp3File;
@property (nonatomic,assign)BOOL isLyric;
@property (nonatomic, strong) NSString *mp3URL;
@property (nonatomic, strong) NSArray *waveArray;
@end
