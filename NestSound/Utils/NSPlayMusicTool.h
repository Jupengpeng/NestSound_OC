//
//  NSPlayMusicTool.h
//  NestSound
//
//  Created by apple on 15/11/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface NSPlayMusicTool : NSObject

//播放音乐
+ (AVPlayer *)playMusicWithUrl:(NSString *)musicUrl block:(void (^)(AVPlayerItem *item))block;


+ (AVPlayer *)playIdenticalMusicWithUrl:(NSString *)musicUrl block:(void (^)(AVPlayerItem *item))block;

//暂停音乐
+ (void)pauseMusicWithName:(NSString *)name;

//停止音乐
+ (void)stopMusicWithName:(NSString *)name;



@end
