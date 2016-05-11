//
//  UIImageView+ILAdditions.m
//  iLight
//
//  Created by chang qin on 15/9/8.
//  Copyright (c) 2015年 yinchao. All rights reserved.
//

#import "UIImageView+WebCache.h"

@implementation UIImageView (NSILAdditions)
static char *imageLoaded;

- (void)setDDImageWithURLString:(NSString *)imageStr {
    
    [self setDDImageWithURLString:imageStr placeHolderImage:nil];
}

- (void)setDDImageWithURLString:(NSString *)imageStr placeHolderImage:(UIImage *)placeHolderImage {
    
    if ([NSTool isStringEmpty:imageStr]) {
        
        self.image = placeHolderImage;
        return ;
    }
    WS(wSelf);
    [self sd_setImageWithURL:[NSURL URLWithString:imageStr]
            placeholderImage:placeHolderImage
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                       BOOL isLoaded = [objc_getAssociatedObject(imageStr, &imageLoaded) boolValue];
                       if (!isLoaded) {
                           wSelf.alpha = 0.;
                           objc_setAssociatedObject(imageStr, &imageLoaded, @(1), OBJC_ASSOCIATION_RETAIN);
                           [UIView animateWithDuration:.6 delay:0.
                                               options:UIViewAnimationOptionAllowUserInteraction
                                            animations:^{
                                                wSelf.alpha = 1.;
                                            } completion:NULL];
                       } else {
                           wSelf.image = image;
                       }
                   }];

}
@end
