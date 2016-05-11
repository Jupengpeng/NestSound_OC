//
//  UIView+ILAdditions.h
//  iLight
//
//  Created by chang qin on 15/9/4.
//  Copyright (c) 2015年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (NSAdditions)
- (CGFloat)x;
- (CGFloat)y;
- (CGFloat)width;
- (CGFloat)height;

@property (nonatomic, strong) NSString *stringTag;

- (UIView *)viewWithStringTag:(NSString *)tag;

- (UIView *)findFirstResponder;

- (UIViewController *)nearestViewController;

- (void)removeAllSubviews;
@end
