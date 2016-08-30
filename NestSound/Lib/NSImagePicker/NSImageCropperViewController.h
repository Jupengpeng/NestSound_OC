//
//  NSImageCropperViewController.h
//  NestSound
//
//  Created by yintao on 16/8/30.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <UIKit/UIKit.h>


@class NSImageCropperViewController;

@protocol NSImageCropperDelegate <NSObject>

- (void)imageCropper:(NSImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage;
- (void)imageCropperDidCancel:(NSImageCropperViewController *)cropperViewController;

@end

@interface NSImageCropperViewController : UIViewController

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) id<NSImageCropperDelegate> delegate;
@property (nonatomic, assign) CGRect cropFrame;

- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio;


@end
