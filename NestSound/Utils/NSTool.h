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

extern void swizzled_Method(Class class,SEL originalSelector,SEL swizzledSelector);

+ (NSString *)obtainHostURL;
+ (AppDelegate *)appDelegate;
+ (BOOL)isStringEmpty:(NSString *)targetString;
+ (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName;
+ (UIImage *)cutImage:(UIImage*)image scaledToSize:(CGSize)newSize2;
+ (NSString *)uploadPhotoWith:(NSString *)photoPath;

@end
//cache include ：accompany，record file ，music file
@interface Memory : NSObject

+(NSString *)getCacheSize;

+(void)clearCache;

@end
//date to string formate like "1992-12-05"；
@interface date : NSObject
+(NSString *)datetoStringWithDate:(NSDate *)date;
+(NSString *)datetoLongStringWithDate:(NSDate *)date;
@end
