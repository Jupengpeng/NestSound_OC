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


@property (nonatomic,assign) WaveViewDrawRectStyle drawRectStyle;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)drawLine;
- (void)drawAllWaves;

- (void)removeAllPath;
@end
