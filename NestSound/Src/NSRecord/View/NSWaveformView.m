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

//@property (nonatomic, strong) NSMutableArray *nums;

@property (nonatomic, assign, getter=isPlayer) BOOL player;

@end

@implementation NSWaveformView


//- (NSMutableArray *)nums {
//    
//    if (!_nums) {
//        
//        _nums = [NSMutableArray array];
//    }
//    
//    return _nums;
//}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.rect = frame;
        
        self.backgroundColor = [UIColor whiteColor];
        UIView* upLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
        upLine.backgroundColor = [UIColor hexColorFloat:@"ffd507"];
        
        [self addSubview:upLine];
        
        self.timeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.rect.size.width/GRIDNUM, 20)];
        self.timeScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 1, self.rect.size.width, TIMELINENUM)];
        
        
        self.timeScrollView.bounces=NO;
        self.timeScrollView.scrollEnabled=YES;
        self.timeScrollView.showsHorizontalScrollIndicator=NO;
        self.timeScrollView.alwaysBounceHorizontal=NO;;
        self.timeScrollView.alwaysBounceVertical=NO;;
        self.timeScrollView.decelerationRate=0.0;

        self.timeScrollView.backgroundColor = [UIColor clearColor];
        self.timeScrollView.contentSize = CGSizeMake(self.rect.size.width*500, 0);
        [self addSubview:self.timeScrollView];
        [self.timeScrollView addSubview:self.timeImageView];
        
        self.waveView = [[WaveView alloc]initWithFrame:CGRectMake(0, 20.4, self.rect.size.width*20, 60)];
        [self.timeScrollView addSubview:self.waveView];
        
        
        UIView* middleLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMidY(self.waveView.frame), self.rect.size.width, 0.4)];
        middleLine.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:middleLine];
        
        
        UIView* downLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 0.5)];
        downLine.backgroundColor = [UIColor hexColorFloat:@"ffd507"];
        
        [self addSubview:downLine];
        
        int a = 5*self.rect.size.width/ScreenWidth;
        self.middleLineV = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/10 * a, 20.5, 0.5,self.rect.size.height-20.3)];
        _middleLineV.backgroundColor = [UIColor redColor];
        [self addSubview:_middleLineV];
        
        
        //self.labelArray = [NSMutableArray arrayWithCapacity:10];
        
        NSString* str=nil;
        UIView* upLine2=nil;
        UIView* upLine3=nil;
        
        int j=0,k,x=0,y;
        y = 5*self.rect.size.width/ScreenWidth;
        k = 5*self.rect.size.width/ScreenWidth;
        for (int i = 0; i<TIME_LONG; ++i) {
            
            UILabel* label=nil;
            @autoreleasepool {
                label = [[UILabel alloc]initWithFrame:CGRectMake(0+ScreenWidth/10*i, 3, ScreenWidth/10, 10)];//此处最终要除以10,不是11
                upLine2 = [[UIView alloc]initWithFrame:CGRectMake(0+ScreenWidth/GRIDNUM*i, 20, ScreenWidth/GRIDNUM, 0.3)];
                upLine2.backgroundColor = [UIColor lightGrayColor];
                x = ScreenWidth/20*i;
                if (i%2 ==0) {
                    upLine3 = [[UIView alloc]initWithFrame:CGRectMake(x, 10, 0.5, 9)];
                    
                }else{
                    upLine3 = [[UIView alloc]initWithFrame:CGRectMake(x, 17, 0.5, 2)];
                    
                }
                
                if (i<y) {
                    str = [NSString stringWithFormat:@"-%02d:%02d",j,k];
                    k--;
                    
                }else{
                    //正规
                    
                    if ((i-y)%60 == 0 && (i-y)!=0) {
                        ++j;
                    }
                    
                    str = [NSString stringWithFormat:@"%02d:%02d",j,(i-y)%60];
                    
                    
                    
                }
                if (upLine3) {
                    upLine3.backgroundColor = [UIColor lightGrayColor];
                }
                
                
                label.font = [UIFont fontWithName:@"Helvetica" size:10];
                [label setTextColor:[UIColor lightGrayColor]];
                label.text = str;
                //[self.labelArray addObject:label];
                
                [self.timeScrollView addSubview:upLine2];
                [self.timeScrollView addSubview:upLine3];
                
                [self.timeScrollView addSubview:label];
                
            }
            
        }
        
        
        
        
    }
    
    return self;
    
}

- (void)drawLine {
    
//    [self.nums addObject:@(self.num)];
    
}



/*- (void)drawRect:(CGRect)rect {
 
 NSArray *numArray = [[self.nums reverseObjectEnumerator] allObjects];
 
 if (self.player) {
 /*for (int i = 0; i < numArray.count; i++) {
 
 if (2 * i >= self.width) {
 
 if (i < self.width / 2) {
 
 UIBezierPath * path = [UIBezierPath bezierPath];
 
 [path moveToPoint:CGPointMake(self.width - 2 * i, self.height * 0.5)];
 
 [path addLineToPoint:CGPointMake(self.width - 2 * i, self.height * 0.5 - [numArray[i] doubleValue])];
 
 [path setLineWidth:1];
 
 [[UIColor hexColorFloat:@"ff833f"] setStroke];
 
 [[UIColor hexColorFloat:@"ff833f"] setFill];
 
 [path stroke];
 
 
 UIBezierPath * path1 = [UIBezierPath bezierPath];
 
 [path1 moveToPoint:CGPointMake(self.width - 2 * i, self.height * 0.5)];
 
 [path1 addLineToPoint:CGPointMake(self.width - 2 * i, self.height * 0.5 + ([numArray[i] doubleValue] * 0.7))];
 
 [path1 setLineWidth:1];
 
 [[UIColor hexColorFloat:@"ffbd99"] setStroke];
 
 [[UIColor hexColorFloat:@"ffbd99"] setFill];
 
 [path1 stroke];
 
 }
 } else {
 
 UIBezierPath * path = [UIBezierPath bezierPath];
 
 [path moveToPoint:CGPointMake(self.width - 2 * i, self.height * 0.5)];
 
 [path addLineToPoint:CGPointMake(self.width - 2 * i, self.height * 0.5 - [numArray[i] doubleValue])];
 
 [path setLineWidth:1];
 
 [[UIColor hexColorFloat:@"ff833f"] setStroke];
 
 [[UIColor hexColorFloat:@"ff833f"] setFill];
 
 [path stroke];
 
 UIBezierPath * path1 = [UIBezierPath bezierPath];
 
 [path1 moveToPoint:CGPointMake(self.width - 2 * i, self.height * 0.5)];
 
 [path1 addLineToPoint:CGPointMake(self.width - 2 * i, self.height * 0.5 + ([numArray[i] doubleValue] * 0.7))];
 
 [path1 setLineWidth:1];
 
 [[UIColor hexColorFloat:@"ffbd99"] setStroke];
 
 [[UIColor hexColorFloat:@"ffbd99"] setFill];
 
 [path1 stroke];
 
 UIBezierPath * centerPath = [UIBezierPath bezierPath];
 
 [centerPath moveToPoint:CGPointMake(self.width, self.height * 0.5)];
 
 [centerPath addLineToPoint:CGPointMake(self.width - 2 * i, self.height * 0.5)];
 
 [centerPath setLineWidth:1];
 
 [[UIColor hexColorFloat:@"ff833f"] setStroke];
 
 [[UIColor hexColorFloat:@"ff833f"] setFill];
 
 [centerPath stroke];
 
 }
 }
 
 } else {
 
 /*for (int i = 0; i < numArray.count; i++) {
 
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
 
 //[[UIColor hexColorFloat:@"ff833f"] setStroke];
 
 //[[UIColor hexColorFloat:@"ff833f"] setFill];
 
 [[UIColor hexColorFloat:@"ffd33f"] setStroke];
 
 [[UIColor hexColorFloat:@"ffd33f"] setFill];
 [path stroke];
 
 UIBezierPath * path1 = [UIBezierPath bezierPath];
 
 [path1 moveToPoint:CGPointMake(self.width * 0.5 - 2 * i, self.height * 0.5)];
 
 [path1 addLineToPoint:CGPointMake(self.width * 0.5 - 2 * i, self.height * 0.5 + ([numArray[i] doubleValue] * 0.7))];
 
 [path1 setLineWidth:1];
 
 //[[UIColor hexColorFloat:@"ffbd99"] setStroke];
 
 //[[UIColor hexColorFloat:@"ffbd99"] setFill];
 [[UIColor hexColorFloat:@"ffd33f"] setStroke];
 
 [[UIColor hexColorFloat:@"ffd33f"] setFill];
 [path1 stroke];
 
 UIBezierPath * centerPath = [UIBezierPath bezierPath];
 
 [centerPath moveToPoint:CGPointMake(self.width * 0.5, self.height * 0.5)];
 
 [centerPath addLineToPoint:CGPointMake(self.width * 0.5 - 2 * i, self.height * 0.5)];
 
 [centerPath setLineWidth:0.2];
 
 //[[UIColor hexColorFloat:@"ff833f"] setStroke];
 
 //[[UIColor hexColorFloat:@"ff833f"] setFill];
 [[UIColor hexColorFloat:@"ffd33f"] setStroke];
 
 [[UIColor hexColorFloat:@"ffd33f"] setFill];
 
 [centerPath stroke];
 
 }
 }
 }
 
 
 }*/

- (void)playerAllPath {
    
    //    self.player = YES;
    //
    //    [self setNeedsDisplay];
}


- (void)removeAllPath {
    
    //self.player = NO;
    
    //[self.nums removeAllObjects];
    
    //[self setNeedsDisplay];
}


@end
