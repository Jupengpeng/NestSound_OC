//
//  UIView+ILAdditions.m
//  iLight
//
//  Created by chang qin on 15/9/4.
//  Copyright (c) 2015年 yinchao. All rights reserved.
//

#import "UIView+NSAdditions.h"

@implementation UIView (NSAdditions)
static char ILStringTagKey;

- (CGFloat)x {
    return self.frame.origin.x;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (CGFloat)width {
    return CGRectGetWidth(self.bounds);
}

- (CGFloat)height {
    return CGRectGetHeight(self.bounds);
}

- (UIView *)viewWithStringTag:(NSString *)tag{
    
    UIView *targetView = nil;
    for (UIView *view in self.subviews) {
        
        if ([view.stringTag isEqualToString:tag]) {
            targetView = view;
            break;
        }else{
            targetView = [view viewWithStringTag:tag];
            if (targetView) {
                break;
            }
        }
    }
    
    return targetView;
}

- (UIView *)findFirstResponder{
    
    UIView *firstResponder = nil;
    if (self.isFirstResponder) {
        
        firstResponder = self;
    }else{
        
        for (UIView *view in self.subviews) {
            if (view.isFirstResponder) {
                firstResponder = view;
                break;
            }else{
                
                firstResponder = [view findFirstResponder];
                if (firstResponder) {
                    break;
                }
            }
        }
    }
    return firstResponder;
}

- (UIViewController *)nearestViewController {
    
    UIResponder *responder = self.nextResponder;
    while (responder) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            break;
        }else{
            responder = [responder nextResponder];
        }
    }
    
    return (UIViewController *)responder;
}

- (void)removeAllSubviews {
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

- (void)setStringTag:(NSString *)stringTag{
    
    objc_setAssociatedObject(self, &ILStringTagKey, stringTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)stringTag{
    
    return objc_getAssociatedObject(self, &ILStringTagKey);
}
@end
