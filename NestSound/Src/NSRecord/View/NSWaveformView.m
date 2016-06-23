//
//  NSWaveformView.m
//  NestSound
//
//  Created by Apple on 16/6/22.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSWaveformView.h"

@interface NSWaveformView ()

//@property (nonatomic, strong) NSMutableArray* paths;

@property (nonatomic, strong) NSMutableArray *nums;

@property (nonatomic, assign, getter=isPlayer) BOOL player;

@end

@implementation NSWaveformView

//- (NSMutableArray *)paths {
//    
//    if (!_paths) {
//        
//        _paths = [NSMutableArray array];
//    }
//    
//    return _paths;
//}

- (NSMutableArray *)nums {
    
    if (!_nums) {
        
        _nums = [NSMutableArray array];
    }
    
    return _nums;
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *TopLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 1)];
        TopLineView.backgroundColor = [UIColor hexColorFloat:@"ffd507"];
        [self addSubview:TopLineView];
        
        UIView *DownLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, 1)];
        DownLineView.backgroundColor = [UIColor hexColorFloat:@"ffd507"];
        [self addSubview:DownLineView];
        
    }
    return self;
}

- (void)drawLine {
    
    [self.nums addObject:@(self.num)];
    
}

- (void)drawRect:(CGRect)rect {
    
    NSArray *numArray = [[self.nums reverseObjectEnumerator] allObjects];
//    
    if (self.player) {
//
//        for (int i = 0; i < numArray.count; i++) {
//            
//            if (2 * i >= self.width) {
//                
//                if (i < self.width / 2) {
//                    
//                    UIBezierPath * path = [UIBezierPath bezierPath];
//                    
//                    [path moveToPoint:CGPointMake(self.width - 2 * i, self.height * 0.5)];
//                    
//                    [path addLineToPoint:CGPointMake(self.width - 2 * i, self.height * 0.5 - [numArray[i] doubleValue])];
//                    
//                    [path setLineWidth:1];
//                    
//                    [[UIColor hexColorFloat:@"ff833f"] setStroke];
//                    
//                    [[UIColor hexColorFloat:@"ff833f"] setFill];
//                    
//                    [path stroke];
//                    
//                    
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
//                    
//                }
//            } else {
//                
//                UIBezierPath * path = [UIBezierPath bezierPath];
//                
//                [path moveToPoint:CGPointMake(self.width - 2 * i, self.height * 0.5)];
//                
//                [path addLineToPoint:CGPointMake(self.width - 2 * i, self.height * 0.5 - [numArray[i] doubleValue])];
//                
//                [path setLineWidth:1];
//                
//                [[UIColor hexColorFloat:@"ff833f"] setStroke];
//                
//                [[UIColor hexColorFloat:@"ff833f"] setFill];
//                
//                [path stroke];
//                
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
//                
//            }
//        }
//        
    } else {
    
        for (int i = 0; i < numArray.count; i++) {
            
            if (2 * i >= self.width * 0.5) {
                
                if (i < self.width * 0.5 / 2) {
                    
                    UIBezierPath * path = [UIBezierPath bezierPath];
                    
                    [path moveToPoint:CGPointMake(self.width * 0.5 - 2 * i, self.height * 0.5)];
                    
                    [path addLineToPoint:CGPointMake(self.width * 0.5 - 2 * i, self.height * 0.5 - [numArray[i] doubleValue])];
                    
                    [path setLineWidth:1];
                    
                    [[UIColor hexColorFloat:@"ff833f"] setStroke];
                    
                    [[UIColor hexColorFloat:@"ff833f"] setFill];
                    
                    [path stroke];
                    
                    
                    UIBezierPath * path1 = [UIBezierPath bezierPath];
                    
                    [path1 moveToPoint:CGPointMake(self.width * 0.5 - 2 * i, self.height * 0.5)];
                    
                    [path1 addLineToPoint:CGPointMake(self.width * 0.5 - 2 * i, self.height * 0.5 + ([numArray[i] doubleValue] * 0.7))];
                    
                    [path1 setLineWidth:1];
                    
                    [[UIColor hexColorFloat:@"ffbd99"] setStroke];
                    
                    [[UIColor hexColorFloat:@"ffbd99"] setFill];
                    
                    [path1 stroke];
                    
                }
                
            } else {
                
                UIBezierPath * path = [UIBezierPath bezierPath];
                
                [path moveToPoint:CGPointMake(self.width * 0.5 - 2 * i, self.height * 0.5)];
                
                [path addLineToPoint:CGPointMake(self.width * 0.5 - 2 * i, self.height * 0.5 - [numArray[i] doubleValue])];
                
                [path setLineWidth:1];
                
                [[UIColor hexColorFloat:@"ff833f"] setStroke];
                
                [[UIColor hexColorFloat:@"ff833f"] setFill];
                
                [path stroke];
                
                UIBezierPath * path1 = [UIBezierPath bezierPath];
                
                [path1 moveToPoint:CGPointMake(self.width * 0.5 - 2 * i, self.height * 0.5)];
                
                [path1 addLineToPoint:CGPointMake(self.width * 0.5 - 2 * i, self.height * 0.5 + ([numArray[i] doubleValue] * 0.7))];
                
                [path1 setLineWidth:1];
                
                [[UIColor hexColorFloat:@"ffbd99"] setStroke];
                
                [[UIColor hexColorFloat:@"ffbd99"] setFill];
                
                [path1 stroke];
                
                UIBezierPath * centerPath = [UIBezierPath bezierPath];
                
                [centerPath moveToPoint:CGPointMake(self.width * 0.5, self.height * 0.5)];
                
                [centerPath addLineToPoint:CGPointMake(self.width * 0.5 - 2 * i, self.height * 0.5)];
                
                [centerPath setLineWidth:1];
                
                [[UIColor hexColorFloat:@"ff833f"] setStroke];
                
                [[UIColor hexColorFloat:@"ff833f"] setFill];
                
                [centerPath stroke];
                
            }
        }
    }
    
    
}

- (void)playerAllPath {
    
//    self.player = YES;
//
//    [self setNeedsDisplay];
}


- (void)removeAllPath {
    
    self.player = NO;
    
    [self.nums removeAllObjects];
    
    [self setNeedsDisplay];
}


@end
