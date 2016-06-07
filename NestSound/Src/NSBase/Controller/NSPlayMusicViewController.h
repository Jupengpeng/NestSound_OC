//
//  NSPlayMusicViewController.h
//  NestSound
//
//  Created by Apple on 16/5/21.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSBaseViewController.h"
#import <AVFoundation/AVFoundation.h>
@class NSPlayMusicDetail;
@interface NSPlayMusicViewController : NSBaseViewController

+ (instancetype)sharedPlayMusic;

@property (nonatomic, weak) AVAudioPlayer *player;

@property (nonatomic,assign) long itemId;

@property (nonatomic,strong) NSPlayMusicDetail * musicDetail;

@end