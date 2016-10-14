//
//  WaveView.h
//  NestSound
//
//  Created by yintao on 16/8/5.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaveView : UIView

@property (nonatomic, strong) NSMutableArray *waveArray;
@property (nonatomic, assign) CGFloat desibelNum;
//@property (nonatomic, assign) NSInteger count;

@property (nonatomic, assign) CGFloat waveDistance;
@property (nonatomic, strong)UIView* realTimeView;
@property(assign,nonatomic)CGFloat distantKeyPath;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)drawLine;
- (void)removeAllPath;
@end
