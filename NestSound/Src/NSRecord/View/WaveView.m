//
//  WaveView.m
//  NestSound
//
//  Created by yintao on 16/8/5.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "WaveView.h"

@interface WaveView ()


@end

@implementation WaveView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
//        self.waveArray = [NSMutableArray array];
        self.desibelNum=0;
        self.locationsArr = [[NSMutableArray alloc] init];
        self.heightArr = [[NSMutableArray alloc] init];
    }
    return self;

}

- (void)drawLine {
    
//    [self.waveArray addObject:@(self.desibelNum)];
}

 


- (void)drawRect:(CGRect)rect{
    

    
    CGContextRef context = UIGraphicsGetCurrentContext();


    switch (self.drawRectStyle) {
        case WaveViewDrawRectStyleCreate:
        {
            
            //    self.realTimeView = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width*10/400+self.waveDistance, 29 - self.desibelNum/2, 1.0f,self.desibelNum)];//21
            //    self.realTimeView.backgroundColor = [UIColor hexColorFloat:@"ffd00b"];
            //    [self.waveArray addObject:self.realTimeView];
            
            //        [self addSubview:self.realTimeView];
            
            [self.locationsArr addObject:@(self.frame.size.width*10/800.0f +self.waveDistance)];
            [self.heightArr addObject:@(self.desibelNum)];
            
            //    for (NSInteger i = 0; i < (self.waveArray.count<=100)?self.waveArray.count :100;i++ ) {
            NSInteger showCount = (self.locationsArr.count<=100)?self.locationsArr.count :100;
            NSInteger startIndex = self.locationsArr.count - showCount;
            
            
            
            for (NSInteger i = 0; i < showCount;i++ ) {
                
                CGFloat location = [self.locationsArr[startIndex + i] floatValue];
                CGFloat height = [self.heightArr[startIndex + i] floatValue];
                
                CGContextAddRect(context, CGRectMake(location, 29 - height/2.0f, 1, height));
                [[UIColor hexColorFloat:@"ffd00b"] setFill];
                
                CGContextFillPath(context);
            }
        }
            break;
        case WaveViewDrawRectStyleShowAll:
        {
            for (NSInteger i = 0; i < self.locationsArr.count ;i++ ) {
                
                CGFloat location = [self.locationsArr[ i] floatValue];
                CGFloat height = [self.heightArr[ i] floatValue];
                
                CGContextAddRect(context, CGRectMake(location, 29 - height/2.0f, 1, height));
                [[UIColor lightGrayColor] setFill];
                
                CGContextFillPath(context);
            }
            self.drawRectStyle = WaveViewDrawRectStyleCreate;
        }
            break;
        case WaveViewDrawRectStyleChangeColor:
        {
            for (NSInteger i = 0; i < self.locationsArr.count ;i++ ) {
                
                CGFloat location = [self.locationsArr[ i] floatValue];
                CGFloat height = [self.heightArr[ i] floatValue];
                
                CGContextAddRect(context, CGRectMake(location, 29 - height/2.0f, 1, height));
                if (location <= (self.frame.size.width*10/800.0f +self.waveDistance)) {
                    [[UIColor hexColorFloat:@"ffd00b"] setFill];

                }else{
                    [[UIColor lightGrayColor] setFill];
                }
              
                CGContextFillPath(context);
            }
        }
            break;
        case WaveViewDrawRectStyleClearAll:
        {
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextClearRect(context, self.bounds);
            
            CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
            CGContextFillRect(context, self.bounds);
        }
            
            break;
            
        default:
            break;
    }
    
  
  
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
    
    
//    [self.waveArray removeAllObjects];
    [self.locationsArr removeAllObjects];
    [self.heightArr removeAllObjects];
    [self removeAllSubviews];
    self.drawRectStyle = WaveViewDrawRectStyleClearAll;
    [self setNeedsDisplay];
}
@end
