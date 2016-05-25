//
//  NSComposeView.m
//  NestSound
//
//  Created by Apple on 16/5/18.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import "NSComposeView.h"
#import "NSComposeButton.h"

@interface NSComposeView ()

@property (nonatomic, strong) NSMutableArray *composeBtns;

@end

@implementation NSComposeView

- (NSMutableArray *)composeBtns {
    
    if (!_composeBtns) {
        
        _composeBtns = [NSMutableArray array];
    }
    
    return _composeBtns;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        UIGraphicsBeginImageContext(window.size);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        [window.layer renderInContext:context];
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        image = [image applyBlurWithRadius:8 tintColor:[UIColor colorWithWhite:0.11 alpha:0.73] saturationDeltaFactor:1.8 maskImage:nil];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        
        [self addSubview:imageView];
        
        
        [self addChildBtn];
        
        
        
    }
    
    return self;
}


- (void)addChildBtn {
    
    NSArray *iconArray = @[@"2.0_plus_lyric", @"2.0_plus_song", @"2.0_plus_record"];
    
    NSArray *titleArray = @[@"歌词", @"歌曲", @"灵感记录"];
    
    CGFloat margin = 30;
    
    for (int i = 0; i < titleArray.count; i++) {
        
        NSComposeButton *composebtn = [[NSComposeButton alloc] init];
        
        [composebtn setTitle:titleArray[i] forState:UIControlStateNormal];
        
        [composebtn setImage:[UIImage imageNamed:iconArray[i]] forState:UIControlStateNormal];
        
        [composebtn addTarget:self action:@selector(composeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        composebtn.x = margin * i + BtnW * i + margin;
        
        composebtn.y = ScreenHeight;
        
        composebtn.tag = i;
        
        [self addSubview:composebtn];
        
        [self.composeBtns addObject:composebtn];
    }
}

- (void)startAnimation {
    
    [self.composeBtns enumerateObjectsUsingBlock:^(NSComposeButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
        
        animation.toValue = [NSValue valueWithCGPoint:CGPointMake(obj.centerX ,ScreenHeight * 0.75 - 60)];
        
        animation.springBounciness = 10;
        
        animation.springSpeed = 20;
        
        animation.beginTime = CACurrentMediaTime() + idx * 0.025;
        
        [obj pop_addAnimation:animation forKey:nil];
        
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSArray *temp = [self.composeBtns reverseObjectEnumerator].allObjects;
    
    [temp enumerateObjectsUsingBlock:^(NSComposeButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
        
        animation.toValue = [NSValue valueWithCGPoint:CGPointMake(obj.centerX ,ScreenHeight + 60)];
        
        animation.springSpeed = 20;
        
        animation.beginTime = CACurrentMediaTime() + idx * 0.025;
        
        [obj pop_addAnimation:animation forKey:nil];
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self removeFromSuperview];
    });
    
}

- (void)composeBtnClick:(UIButton *)btn {
    
   
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.composeBtns enumerateObjectsUsingBlock:^(NSComposeButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
            if (btn == obj) {
                
                obj.transform = CGAffineTransformMakeScale(2.0, 2.0);
                
                obj.alpha = 0.5;
            } else {
                
                obj.transform = CGAffineTransformMakeScale(0.5, 0.5);
                
                obj.alpha = 0.5;
                
            }
        }];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            [self.composeBtns enumerateObjectsUsingBlock:^(NSComposeButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                obj.transform = CGAffineTransformIdentity;
                
                obj.alpha = 1;
                
            }];
            
        }];
        
        if ([self.delegate respondsToSelector:@selector(composeView:withComposeButton:)]) {
            
            [self.delegate composeView:self withComposeButton:btn];
        }
        
    }];
    
}

@end

                 


                 
                 
                 
                 
                 
                 
                 
                 
                 
                 
