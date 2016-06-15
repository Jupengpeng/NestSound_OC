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
static NSString *oldMusicUrl;
static AVPlayer *player;
static AVPlayerItem *musicItem;
@implementation NSPlayMusicTool

//播放音乐
+ (AVPlayer *)playMusicWithUrl:(NSString *)musicUrl block:(void (^)(AVPlayerItem *musicItem))block {
    
    if (![oldMusicUrl isEqualToString:musicUrl]) {
        
        [player pause];
        player = nil;
    }
    
    
    if (player == nil ) {
        
        musicItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:musicUrl]];
        
        player = [AVPlayer playerWithPlayerItem:musicItem];
        
        oldMusicUrl = musicUrl;
    }
    
    if (block) {
        
        block(musicItem);
    }
    
    [player play];
    
    return player;

}

//暂停音乐
+ (void)pauseMusicWithName:(NSString *)name {
    
    if (player) {
        
        [player pause];
    }
    
}

//停止音乐
+ (void)stopMusicWithName:(NSString *)name {
    
    if (player) {
        
        
    }
}

@end







