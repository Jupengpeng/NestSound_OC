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
    
//    [self.waveArray addObject:@(self.desibelNum)];
}

 
- (void)drawRect:(CGRect)rect{
    
    self.realTimeView = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width*10/400+self.waveDistance, 29 - self.desibelNum/2, 1.0f,self.desibelNum)];//21
    self.realTimeView.backgroundColor = [UIColor hexColorFloat:@"ffd00b"];
    [self.waveArray addObject:self.realTimeView];

//    self.count++;

    [self addSubview:self.realTimeView];
   
 }
/*
- (void)drawRect:(CGRect)rect {
    
    NSArray *numArray = [[self.waveArray reverseObjectEnumerator] allObjects];
    ／
    for (int i = 0; i < numArray.count; i++) {
        
        if (2 * i >= self.width) {
            
            if (i < self.width / 2) {
                
                UIBezierPath * path = [UIBezierPath bezierPath];
                
                [path moveToPoint:CGPointMake(self.width - 2 * i, self.height * 0.5)];
                
                [path addLineToPoint:CGPointMake(self.width - 2 * i, self.height * 0.5 - [numArray[i] doubleValue])];
                
                [path setLineWidth:1];
                
                [[UIColor hexColorFloat:@"ff833f"] setStroke];
                
                [[UIColor hexColorFloat:@"ff833f"] setFill];
                
                [path stroke];
                
                [self.waveArray addObject:path];
                //                    UIBezierPath * path1 = [UIBezierPath bezierPath];
                //
                //                    [path1 moveToPoint:CGPointMake(self.width - 2 * i, self.height * 0.5)];
                //
                //                    [path1 addLineToPoint:CGPointMake(self.width - 2 * i, self.height * 0.5 + ([numArray[i] doubleValue] * 0.7))];
                //
                //                    [path1 setLineWidth:1];
                //
                //                    [[UIColor hexColorFloat:@"ffbd99"] setStroke];
                //
                //                    [[UIColor hexColorFloat:@"ffbd99"] setFill];
                //
                //                    [path1 stroke];
                
            }
        } else {
            
            UIBezierPath * path = [UIBezierPath bezierPath];
            
            [path moveToPoint:CGPointMake(self.width - 2 * i, self.height * 0.5)];
            
            [path addLineToPoint:CGPointMake(self.width - 2 * i, self.height * 0.5 - [numArray[i] doubleValue])];
            
            [path setLineWidth:1];
            
            [[UIColor hexColorFloat:@"ff833f"] setStroke];
            
            [[UIColor hexColorFloat:@"ff833f"] setFill];
            
            [path stroke];
            
            [self.waveArray addObject:path];
            //                UIBezierPath * path1 = [UIBezierPath bezierPath];
            //
            //                [path1 moveToPoint:CGPointMake(self.width - 2 * i, self.height * 0.5)];
            //
            //                [path1 addLineToPoint:CGPointMake(self.width - 2 * i, self.height * 0.5 + ([numArray[i] doubleValue] * 0.7))];
            //
            //                [path1 setLineWidth:1];
            //
            //                [[UIColor hexColorFloat:@"ffbd99"] setStroke];
            //
            //                [[UIColor hexColorFloat:@"ffbd99"] setFill];
            //
            //                [path1 stroke];
            //
            //                UIBezierPath * centerPath = [UIBezierPath bezierPath];
            //
            //                [centerPath moveToPoint:CGPointMake(self.width, self.height * 0.5)];
            //
            //                [centerPath addLineToPoint:CGPointMake(self.width - 2 * i, self.height * 0.5)];
            //
            //                [centerPath setLineWidth:1];
            //
            //                [[UIColor hexColorFloat:@"ff833f"] setStroke];
            //
            //                [[UIColor hexColorFloat:@"ff833f"] setFill];
            //
            //                [centerPath stroke];
            
        }
    }
}
 */
- (void)removeAllPath {
    
    
    [self.waveArray removeAllObjects];
    [self removeAllSubviews];
    [self setNeedsDisplay];
}
@end
