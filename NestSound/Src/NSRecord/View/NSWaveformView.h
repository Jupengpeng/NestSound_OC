//
//  NSWaveformView.h
//  NestSound
//
//  Created by Apple on 16/6/22.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaveView.h"
@interface NSWaveformView : UIView

@property (nonatomic, assign) CGFloat num;
@property (nonatomic, strong) NSMutableArray *waveArray;
//时间
@property(strong,nonatomic)UIScrollView* timeScrollView;
@property(strong,nonatomic)UIImageView* timeImageView;
//@property(strong,nonatomic)NSMutableArray* labelArray;
@property(strong,nonatomic)WaveView* waveView;
@property(nonatomic,strong) UIView* middleLineV;
@property(assign,nonatomic)CGRect rect;
- (instancetype)initWithFrame:(CGRect)frame;
///////////////
//录音轨迹
@property(strong,nonatomic)UIScrollView* recordScrollView;
@property(strong,nonatomic)UIImageView* recordImageView;

//- (void)drawMusicWave;
//////////////
- (void)drawLine;

- (void)playerAllPath;

- (void)removeAllPath;

@end
