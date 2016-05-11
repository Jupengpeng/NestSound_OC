//
//  UIImageView+ILAdditions.h
//  iLight
//
//  Created by chang qin on 15/9/8.
//  Copyright (c) 2015年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (NSAdditions)

- (void)setDDImageWithURLString:(NSString *)imageStr;
- (void)setDDImageWithURLString:(NSString *)imageStr placeHolderImage:(UIImage *)placeHolderImage;
@end
