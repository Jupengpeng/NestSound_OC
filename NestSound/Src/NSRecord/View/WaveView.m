//
//  WaveView.m
//  NestSound
//
//  Created by yintao on 16/8/5.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "WaveView.h"
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
    
    
}


- (void)drawRect:(CGRect)rect{
    if (self.desibelNum==0) {
        return;
    }
    self.realTimeView = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width*10/400+self.waveDistance, 29.4 - self.desibelNum/2, 1.2f,self.desibelNum)];//21
    self.realTimeView.backgroundColor = [UIColor hexColorFloat:@"ffd00b"];
    [self.waveArray addObject:self.realTimeView];

    self.count++;

    [self addSubview:self.realTimeView];
   
 }

- (void)removeAllPath {
    
    
    [self.waveArray removeAllObjects];
    [self removeAllSubviews];
    [self setNeedsDisplay];
}
@end
