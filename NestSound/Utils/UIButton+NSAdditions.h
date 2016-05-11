//
//  UIButton+ILAdditions.h
//  iLight
//
//  Created by chang qin on 15/9/4.
//  Copyright (c) 2015年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (NSAdditions)

- (void)clickForce;
+ (instancetype)buttonWithType:(UIButtonType)buttonType configure:(void(^)(UIButton *btn))configureBlock action:(void(^)(UIButton *btn))actionBlock;
@end
