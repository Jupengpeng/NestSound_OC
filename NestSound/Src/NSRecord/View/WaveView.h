//
//  WaveView.h
//  NestSound
//
//  Created by yintao on 16/8/5.
//  Copyright © 2016年 yinchao. All rights reserved.
//

typedef NS_ENUM(NSUInteger, WaveViewDrawRectStyle) {
    //局部创建显示
    WaveViewDrawRectStyleCreate,
    //局部变色
    WaveViewDrawRectStyleChangeColor,
    //显示不变色的全部
    WaveViewDrawRectStyleShowAll,
    //显示两边变色的全部
    WaveViewDrawRectStyleShowChangedAll,
    //清空画布
    WaveViewDrawRectStyleClearAll
};
#import <UIKit/UIKit.h>

@interface WaveView : UIView

//@property (nonatomic, strong) NSMutableArray *waveArray;
@property (nonatomic, assign) CGFloat desibelNum;
//@property (nonatomic, assign) NSInteger count;

@property (nonatomic, assign) CGFloat waveDistance;
@property (nonatomic, strong)UIView* realTimeView;
@property(assign,nonatomic)CGFloat distantKeyPath;

@property (nonatomic,strong) NSMutableArray *locationsArr;
@property (nonatomic,strong) NSMutableArray *heightArr;
//中间线x坐标
@property (nonatomic,assign) CGFloat originMiddleX;
@property (nonatomic,assign) WaveViewDrawRectStyle drawRectStyle;


//获取各个位置时的时间
@property (nonatomic,strong) NSMutableArray *timeArray;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)drawLine;
- (void)showAllWaves;

- (void)showAllChangedColorWaves;

- (void)createNewWaves;

- (void)changingWavesColor;

- (void)removeAllPath;
@end
