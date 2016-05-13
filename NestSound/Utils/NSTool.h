//
//  NSTool.h
//  NestSound
//
//  Created by yandi on 4/16/16.
//  Copyright © 2016 yinchao. All rights reserved.
//

#import "AppDelegate.h"
#import <Foundation/Foundation.h>

@interface NSTool : NSObject

+ (NSString *)obtainHostURL;
+ (AppDelegate *)appDelegate;
+ (BOOL)isStringEmpty:(NSString *)targetString;
+ (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName;
+ (UIImage *)cutImage:(UIImage*)image scaledToSize:(CGSize)newSize2;
+ (NSString *)uploadPhotoWith:(NSString *)photoPath;
@end

