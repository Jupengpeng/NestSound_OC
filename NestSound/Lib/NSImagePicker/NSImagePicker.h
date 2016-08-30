//
//  NSImagePicker.h
//  NestSound
//
//  Created by yintao on 16/8/30.
//  Copyright © 2016年 yinchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum ImagePickerType
{
    ImagePickerCamera = 0,
    ImagePickerPhoto = 1
}ImagePickerType;
@class NSImagePicker;
@protocol NSImagePickerDelegate <NSObject>

- (void)imagePicker:(NSImagePicker *)imagePicker didFinished:(UIImage *)editedImage;
- (void)imagePickerDidCancel:(NSImagePicker *)imagePicker;
@end
@interface NSImagePicker : NSObject
+ (instancetype) sharedInstance;
//scale 裁剪框的高宽比 0~1.5 默认为1
- (void)showImagePickerWithType:(ImagePickerType)type InViewController:(UIViewController *)viewController Scale:(double)scale;
//代理
@property (nonatomic, assign) id<NSImagePickerDelegate> delegate;

@end
