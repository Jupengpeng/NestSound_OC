//
//  UluInternalProtocolDefine.h
//  UlucuPlayer
//
//  Created by CaoZhihui on 16/7/19.
//  Copyright © 2016年 HuiDian. All rights reserved.
//

#ifndef UluInternalProtocolDefine_h
#define UluInternalProtocolDefine_h

#import <Foundation/Foundation.h>
#import <CoreAudio/CoreAudioTypes.h> // for UluAudioWaveProtocol

//底层播放库视频数据加载委托
@protocol UluPLLDelegate <NSObject>

- (void)startLoading;
- (void)finishLoading;

@end


//声波渲染协议
@protocol UluAudioWaveProtocol <NSObject>

//set audio format
- (void)setAudioFormat:(AudioStreamBasicDescription)audioFormat;

// audioData = AudioQueueBufferRef->mAudioData; byteSize = AudioQueueBufferRef->mAudioDataByteSize
- (void)audioQueueBuffer:(void *)audioData size:(UInt32)byteSize;

//已转换过的数据所调接口
- (void)audioBuffer:(float *)buffer frames:(UInt32)frames;

@end


#endif /* UluInternalProtocolDefine_h */
