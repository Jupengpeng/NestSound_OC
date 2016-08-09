//
//  WaveView.m
//  NestSound
//
//  Created by yintao on 16/8/5.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "WaveView.h"
NSUInteger ii=0;
@implementation WaveView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.waveArray = [NSMutableArray array];
        self.desibelNum=0;

        
    }
    return self;

}

- (void)drawLine {
    
    [self.waveArray addObject:@(self.desibelNum)];
    
}


- (void)drawRect:(CGRect)rect{
    if (self.desibelNum==0) {
        return;
    }
    self.realTimeView = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width*10/400+self.waveDistance, 21-self.desibelNum, 1.f,self.desibelNum)];
    
    self.realTimeView.backgroundColor = [UIColor hexColorFloat:@"ffd33f"];


    [self addSubview:self.realTimeView];
   
 }

- (void)removeAllPath {
    
    
    [self.waveArray removeAllObjects];
    [self removeAllSubviews];
    [self setNeedsDisplay];
}
@end
