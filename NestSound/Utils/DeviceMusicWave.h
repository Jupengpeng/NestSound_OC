//
//  DeviceMusicWave.h
//  DeviceMusicWave
//
//  Created by liuxw
//  Copyright (c) 2016年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#define MAX_RECORD_DURATION 60.0
#define WAVE_UPDATE_FREQUENCY   0.1
#define SILENCE_VOLUME   45.0
#define SOUND_METER_COUNT  6
#define HUD_SIZE  320.0

@class DeviceMusicWave;
@protocol DeviceMusicWavedelete <NSObject>
@optional
- (void)recordWaveView:(DeviceMusicWave *)waveView voiceRecorded:(NSString *)recordPath length:(float)recordLength;

@end

@interface DeviceMusicWave : UIView<AVAudioRecorderDelegate>
@property(weak, nonatomic) id<DeviceMusicWavedelete> delegate;
- (void)startForFilePath:(NSString *)filePath;
- (void)commitRecording;

@end
