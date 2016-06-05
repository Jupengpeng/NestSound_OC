//
//  NSSoundRecord.h
//  NestSound
//
//  Created by Apple on 16/5/21.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSSoundRecord;

@protocol NSSoundRecordDelegate <NSObject>

//播放结束后的代理方法
@optional
- (void)soundRecord:(NSSoundRecord *)record;

@end

@interface NSSoundRecord : NSObject

//开始录音
- (void)startRecorder;

//暂停录音
- (void)pauseRecorder;

//停止录音
- (void)stopRecorder;

//播放录音
- (void)playsound;

//暂停播放录音
- (void)pausePlaysound;

//停止播放录音
- (void)stopPlaysound;

//删除录音
- (void)removeSoundRecorder;

//获取分贝数
- (CGFloat)decibels;

@property (nonatomic, weak) id<NSSoundRecordDelegate> delegate;

@end
