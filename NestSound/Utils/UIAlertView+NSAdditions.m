//
//  UIAlertView+NSAdditions.m
//  YueDong
//
//  Created by yandi on 15/12/9.
//  Copyright © 2015年 yinchao All rights reserved.
//

#import "UIAlertView+NSAdditions.h"
static NSString *LEFT_ACTION_ASS_KEY = @"com.cancelbuttonaction";
static NSString *RIGHT_ACTION_ASS_KEY = @"com.otherbuttonaction";
@interface UIAlertView ()
<
UIAlertViewDelegate
>
@end

@implementation UIAlertView (NSAdditions)
static char *clickBlockKey;
static char *alertTitlesKey;
-(id)initWithTitle:(NSString *)     title
           message:(NSString *)     message
   leftButtonTitle:(NSString *)     leftButtonTitle
  leftButtonAction:(void (^)(void)) leftButtonAction
  rightButtonTitle:(NSString*)      rightButtonTitle
 rightButtonAction:(void (^)(void)) rightButtonAction
{
    if((self = [self initWithTitle:title
                           message:message
                          delegate:self
                 cancelButtonTitle:leftButtonTitle
                 otherButtonTitles:rightButtonTitle, nil]))
    {
        // We might get nil for one or both block inputs.  To
        
        
        // Since this is a catogory, we cant add properties in the usual way.
        // Instead we bind the delegate block to the pointer to self.
        // We use copy to invoke block_copy() to ensure the block is copied off the stack to the heap
        // so that it is still in scope when the delegate callback is invoked.
        if (leftButtonAction)
        {
            objc_setAssociatedObject(self, (__bridge const void *)(LEFT_ACTION_ASS_KEY), leftButtonAction, OBJC_ASSOCIATION_COPY_NONATOMIC);
        }
        
        if (rightButtonAction)
        {
            objc_setAssociatedObject(self, (__bridge const void *)(RIGHT_ACTION_ASS_KEY), rightButtonAction, OBJC_ASSOCIATION_COPY_NONATOMIC);
        }
        
        if (!leftButtonAction && !rightButtonAction)
        {
            self.delegate = nil;
        }
    }
    return self;
}

+ (UIAlertView *)showWithTitle:(NSString *)title
                       message:(NSString *)message
                cancelBtnTitle:(NSString *)cancelBtnTitle
                         click:(void(^)(NSString *clickBtnTitle))clickBlock
                otherBtnTitles:(NSString *)otherBtnTitles,...NS_REQUIRES_NIL_TERMINATION {
    
    UIAlertView *customAlertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelBtnTitle otherButtonTitles:otherBtnTitles, nil];
    customAlertView.delegate = customAlertView;
    [customAlertView show];
    if (clickBlock) {
        
        customAlertView.clickBlock = clickBlock;
    }
    
    va_list args;
    va_start(args, otherBtnTitles);
    
    if(cancelBtnTitle) {
        
        [customAlertView.alertTitles addObject:cancelBtnTitle];
    }
    
    for (NSString *destructTitle = otherBtnTitles; destructTitle != nil; destructTitle = va_arg(args,NSString*)) {
        
        if (destructTitle) {
            
            [customAlertView addButtonWithTitle:destructTitle];
            [customAlertView.alertTitles addObject:destructTitle];
        }
    }
    va_end(args);
    return customAlertView;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex  {
    
    NSString *clickTitle = [self.alertTitles objectAtIndex:buttonIndex];
    if ([clickTitle isEqualToString:@"更新"]) {
        if (self.clickBlock) {
            
            self.clickBlock(clickTitle);
        }
    }
    
}

#pragma mark - setter & getter
- (void)setClickBlock:(void (^)(NSString *))clickBlock {
    
    objc_setAssociatedObject(self, &clickBlockKey, clickBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(NSString *))clickBlock {
    
    return objc_getAssociatedObject(self, &clickBlockKey);
}

- (void)setAlertTitles:(NSMutableArray *)alertTitles {
    
    objc_setAssociatedObject(self, &alertTitlesKey, alertTitles, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)alertTitles {
    
    if (!objc_getAssociatedObject(self, &alertTitlesKey)) {
        
        NSMutableArray *alertTitlesArr = [NSMutableArray array];
        self.alertTitles = alertTitlesArr;
        
        return alertTitlesArr;
    }
    
    return objc_getAssociatedObject(self, &alertTitlesKey);
}

@end
