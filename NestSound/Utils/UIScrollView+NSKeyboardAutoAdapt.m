//
//  UIScrollView+NSKeyboardHandler.m
//  MarketMan
//
//  Created by yandi on 15/8/26.
//  Copyright (c) 2016年 yinchao All rights reserved.
//

#import <objc/runtime.h>
#import "UIScrollView+NSKeyboardAutoAdapt.h"

@implementation UIScrollView (NSKeyboardAutoAdapt)
static char *autoAdaptKey;

- (void)setAutoAdaptKeyboard:(BOOL)autoAdaptKeyboard {
    
    if (autoAdaptKeyboard) {
        self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    objc_setAssociatedObject(self, &autoAdaptKey, @(autoAdaptKeyboard), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)autoAdaptKeyboard {
    return [objc_getAssociatedObject(self, &autoAdaptKey) boolValue];
}

#pragma mark -keyboardWillChanged.
- (void)keyboardWillChanged:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    
    // prepare scroll condition
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGRect endFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationOptions curve = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    UIView *firstResponder = [self findFirstResponder];
    CGRect convertRect = [self convertRect:firstResponder.frame toView:self.superview];
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:curve
                     animations:^{
                         if (CGRectGetHeight(screenBounds) == endFrame.origin.y) {
                             self.contentInset = UIEdgeInsetsZero;
                             [self scrollRectToVisible:convertRect animated:NO];
                         } else {
                             [self scrollRectToVisible:convertRect animated:NO];
                             self.contentInset = UIEdgeInsetsMake(0, 0, CGRectGetHeight(endFrame)-60, 0);
                         }
                     } completion:NULL];
}
@end
