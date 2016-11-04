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

@property (nonatomic, weak) UIButton *playOrPauseBtn;

@property (nonatomic,strong) AVPlayer *player;

@property (nonatomic,assign) long itemUid;

@property (nonatomic,strong) NSPlayMusicDetail * musicDetail;
@property (nonatomic,copy) NSString * from;
@property (nonatomic,assign) int geDanID;
@property (nonatomic,strong) NSMutableArray * songAry;
@property (nonatomic,assign) NSInteger songID;
@property (nonatomic,assign) long isShow;

//合作成品
@property (nonatomic,assign) BOOL isCoWork;

- (void)playMusicUrl:(NSString *)musicUrl;

@end
