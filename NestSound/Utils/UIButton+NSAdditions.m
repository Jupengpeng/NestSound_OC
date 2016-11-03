
//  UIButton+ILAdditions.m
//  iLight
//
//  Created by chang qin on 15/9/4.
//  Copyright (c) 2015年 yinchao. All rights reserved.
//

#import "UIButton+NSAdditions.h"

@implementation UIButton (NSAdditions)
static char *actionBlockKey;

+ (instancetype)buttonWithType:(UIButtonType)buttonType configure:(void(^)(UIButton *btn))configureBlock action:(void(^)(UIButton *btn))actionBlock {
    UIButton *btn = [UIButton buttonWithType:buttonType];
    if (configureBlock) {
        configureBlock(btn);
    }
    objc_setAssociatedObject(btn, &actionBlockKey, actionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [btn addTarget:btn action:@selector(actionCallBlock:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark - clickForce
- (void)clickForce{
    
    void (^actionBlock) (UIButton *btn) = objc_getAssociatedObject(self, &actionBlockKey);
    if (actionBlock) {
        actionBlock(self);
    }
}

#pragma mark -actionCallBlock
- (void)actionCallBlock:(UIButton *)btn {
    void (^actionBlock) (UIButton *btn) = objc_getAssociatedObject(self, &actionBlockKey);
    if (actionBlock) {
        actionBlock(btn);
    }
}
@end
