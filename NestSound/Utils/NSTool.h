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
+(NSString *)uploadPhotoWith:(NSString *)photoPath type:(BOOL)type_ token:(NSString *)token url:(NSString *)url;
+(BOOL) isValidateMobile:(NSString *)mobile;
+(BOOL)compareWithUser:(long)userID;
+(NSString *)encrytWithDic:(NSDictionary *)dic;
+(NSString *)stringFormatWithTimeLong:(long)times;
+(NSString *)getMachine;
+(CGFloat)getWidthWithContent:(NSString *)contentStr font:(UIFont *)font;
+(CGFloat)getHeightWithContent:(NSString *)contentStr width:(CGFloat)width font:(UIFont *)font lineOffset:(CGFloat)lineOffset;

// data to jsonString
+ (NSString*)transformTOjsonStringWithObject:(id)object;


+ (CGFloat)numberOfTextIn:(UILabel *)label;
+ (NSString *)updateTimeForCreateTimeIntrval:(NSInteger)createTimeIntrval;

+ (NSArray *)getTagsFromTagString:(NSString *)tagString;

+ (BOOL)canRecord;

@end

//cache include ：accompany，record file
@interface Memory : NSObject
+(NSString *)getCacheSize;
+(void)clearCache;
@end

@interface date : NSObject
+(NSString *)datetoStringWithDate:(NSTimeInterval)date;
+(NSString *)datetoLongStringWithDate:(NSTimeInterval)date;
+(NSString *)datetoLongLongStringWithDate:(NSTimeInterval)date;
+(NSString *)datetoMonthStringWithDate:(NSTimeInterval)date;
+(NSString *)datetoMonthStringWithDate:(NSTimeInterval)date format:(NSString *)format;

+(NSTimeInterval)getTimeStamp;
@end

@interface Share : NSObject
+(void)ShareWithTitle:(NSString *)title_ andShareUrl:(NSString *)shareUrl_ andShareImage:(NSString *)shareImage andShareText:(NSString *)shareText_ andVC:(UIViewController *)VC_;;
+(BOOL)shareAvailableWeiXin;
+(BOOL)shareAvailableQQ;
+(BOOL)shareAvailableSina;
@end

@interface image : NSObject
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
@end

@interface attributedString : NSObject
+ (NSMutableAttributedString*)getMutableAttributedString:(NSString*)string textColor:(UIColor *)color length:(NSInteger)num;

@end
