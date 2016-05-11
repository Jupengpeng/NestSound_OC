//
//  UIActionSheet+NSAdditions.m
//  YueDong
//
//  Created by Jing Li on 15/11/14.
//  Copyright © 2015年 yinchao All rights reserved.
//

#import "UIActionSheet+NSAdditions.h"

@interface UIActionSheet ()
<
UIActionSheetDelegate
>
@end

@implementation UIActionSheet (NSAdditions)
static char *clickBlockKey;
static char *sheetTitlesKey;

+ (UIActionSheet *)showWithTitle:(NSString *)title
                  cancelBtnTitle:(NSString *)cancelBtnTitle
                           click:(void(^)(NSString *clickBtnTitle))clickBlock
                  otherBtnTitles:(NSString *)otherBtnTitles,...NS_REQUIRES_NIL_TERMINATION {
    
    UIActionSheet *customActionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                                   delegate:nil
                                                          cancelButtonTitle:cancelBtnTitle destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    customActionSheet.delegate = customActionSheet;
    
    if (clickBlock) {
        
        customActionSheet.clickBlock = clickBlock;
    }
    
    va_list args;
    va_start(args, otherBtnTitles);
    
    if(cancelBtnTitle) {
        
        [customActionSheet.sheetTitles addObject:cancelBtnTitle];
    }
    
    for (NSString *destructTitle = otherBtnTitles; destructTitle != nil; destructTitle = va_arg(args,NSString*)) {
        
        if (destructTitle) {
            
            [customActionSheet addButtonWithTitle:destructTitle];
            [customActionSheet.sheetTitles addObject:destructTitle];
        }
    }
    
    va_end(args);
    
    return customActionSheet;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *clickTitle = [self.sheetTitles objectAtIndex:buttonIndex];
    
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

- (void)setSheetTitles:(NSMutableArray *)sheetTitles {
    
    objc_setAssociatedObject(self, &sheetTitlesKey, sheetTitles, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)sheetTitles {
    
    if (!objc_getAssociatedObject(self, &sheetTitlesKey)) {
        
        NSMutableArray *sheetTitlesArr = [NSMutableArray array];
        self.sheetTitles = sheetTitlesArr;
        
        return sheetTitlesArr;
    }
    
    return objc_getAssociatedObject(self, &sheetTitlesKey);
}
@end
