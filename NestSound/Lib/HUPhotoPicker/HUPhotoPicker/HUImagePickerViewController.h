//
//  HUImagePickerViewController.h
//  PictureDemo
//
//  Created by mac on 16/3/30.
//  Copyright © 2016年 hujewelz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HUImagePickerViewControllerDelegate;
@interface HUImagePickerViewController : UINavigationController

@property (nonatomic, weak) id<UINavigationControllerDelegate, HUImagePickerViewControllerDelegate> delegate;
@property (nonatomic) NSInteger maxAllowSelectedCount;

@end


@protocol HUImagePickerViewControllerDelegate <NSObject>

@optional

- (void)imagePickerController:(HUImagePickerViewController *)picker didFinishPickingImages:(NSArray *)images;

@end