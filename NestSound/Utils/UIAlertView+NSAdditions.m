//
//  UIAlertView+NSAdditions.m
//  YueDong
//
//  Created by yandi on 15/12/9.
//  Copyright © 2015年 yinchao All rights reserved.
//

#import "UIAlertView+NSAdditions.h"

@interface UIAlertView ()
<
UIAlertViewDelegate
>
@end

@implementation UIAlertView (NSAdditions)
static char *clickBlockKey;
static char *alertTitlesKey;

+ (UIAlertView *)showWithTitle:(NSString *)title
                       message:(NSString *)message
                cancelBtnTitle:(NSString *)cancelBtnTitle
                         click:(void(^)(NSString *clickBtnTitle))clickBlock
                otherBtnTitles:(NSString *)otherBtnTitles,...NS_REQUIRES_NIL_TERMINATION {
    
    UIAlertView *customAlertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelBtnTitle otherButtonTitles:nil, nil];
    customAlertView.delegate = customAlertView;
    
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
    
    if (self.clickBlock) {
        
        self.clickBlock(clickTitle);
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
