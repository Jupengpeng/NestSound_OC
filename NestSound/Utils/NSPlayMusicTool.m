//
//  NSPlayMusicTool.m
//  NestSound
//
//  Created by apple on 15/11/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "NSPlayMusicTool.h"
#import <AVFoundation/AVFoundation.h>

@interface NSPlayMusicTool ()

@end

static NSMutableDictionary *_players;

@implementation NSPlayMusicTool

+ (void)initialize {

    _players = [NSMutableDictionary dictionary];

}

//播放音乐
+ (AVAudioPlayer *)playMusicWithName:(NSString *)name {
    
    AVAudioPlayer *player = _players[name];
    
    if (player == nil) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
        
        NSURL *url = [NSURL fileURLWithPath:path];
        
        player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        
        [_players setObject:player forKey:name];
        
    }
    
    [player play];
    
    return player;

}

//暂停音乐
+ (void)pauseMusicWithName:(NSString *)name {
    
    AVAudioPlayer *player = _players[name];
    
    if (player) {
        
        [player pause];
    }

}

//停止音乐
+ (void)stopMusicWithName:(NSString *)name {
    
    AVAudioPlayer *player = _players[name];
    
    if (player) {
        
        [player stop];
    }
}

@end







