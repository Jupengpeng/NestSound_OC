//
//  NSTool.m
//  NestSound
//
//  Created by yandi on 4/16/16.
//  Copyright © 2016 yinchao. All rights reserved.
//

#import "NSTool.h"

void swizzled_Method(Class class,SEL originalSelector,SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzeldMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didSwizzle = class_addMethod(class, originalSelector, method_getImplementation(swizzeldMethod), method_getTypeEncoding(swizzeldMethod));
    
    if (didSwizzle) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzeldMethod);
    }
}

BOOL debugMode = NO;
NSString *host = @"";
NSString *port = @"";

@implementation NSTool
static NSDateFormatter *dateFormatter;

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [[self class] configureHostURL];
        
        dateFormatter = [[NSDateFormatter alloc] init];
    });
}

#pragma mark + configureHostURL
+ (void)configureHostURL {
    
    if (debugMode) {
        
        if ([NSTool isStringEmpty:[USERDEFAULT objectForKey:customHostKey]]) {
            
#ifdef DEBUG
            host = debugHost;
            port = debugPort;
            
            [USERDEFAULT setValue:debugHost forKey:customHostKey];
            [USERDEFAULT setValue:debugPort forKey:customPortKey];
            [USERDEFAULT synchronize];
#else
            host = releaseHost;
            port = releasePort;
            
            [USERDEFAULT setValue:releaseHost forKey:customHostKey];
            [USERDEFAULT setValue:releasePort forKey:customPortKey];
            [USERDEFAULT synchronize];
#endif
        } else {
            
            host = [USERDEFAULT objectForKey:customHostKey];
            port = [USERDEFAULT objectForKey:customPortKey];
        }
        return ;
    }
#ifdef DEBUG
    host = debugHost;
    port = debugPort;
#else
    host = releaseHost;
    port = releasePort;
#endif
}

#pragma mark - obtainHostURL
+ (NSString *)obtainHostURL {
    
    NSString *requestURL = [USERDEFAULT objectForKey:customHostKey];
    if (![NSTool isStringEmpty:requestURL]) {
        if (![NSTool isStringEmpty:customPortKey]) {
            requestURL = [requestURL stringByAppendingFormat:@":%@",[USERDEFAULT objectForKey:customPortKey]];
        }
        return requestURL;
    }
    requestURL = host;
    if (![NSTool isStringEmpty:port]) {
        requestURL = [requestURL stringByAppendingFormat:@":%@",port];
    }
    return requestURL;
}

#pragma mark - appDelegate
+ (AppDelegate *)appDelegate {
    
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

#pragma mark - isStringEmpty
+ (BOOL)isStringEmpty:(NSString *)targetString {
    
    if (![targetString isKindOfClass:[NSString class]]) {
        targetString = targetString.description;
    }
    if ([targetString isEqualToString:@"(null)"]) {
        return YES;
    }
    if ([targetString isEqualToString:@"<null>"]) {
        return YES;
    }
    if ([targetString isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([targetString isEqualToString:@"(null)(null)"]) {
        return YES;
    }
    if ([[targetString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}

#pragma mark cutImage With size
+ (UIImage *)cutImage:(UIImage*)image scaledToSize:(CGSize)newSize2
{
    //压缩图片
    CGSize newSize;
    CGImageRef imageRef = nil;
    
    if ((image.size.width / image.size.height) < (newSize2.width / newSize2.height)) {
        newSize.width = image.size.width;
        newSize.height = image.size.width * newSize2.height / newSize2.width;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, fabs(image.size.height - newSize.height) / 2, newSize.width, newSize.height));
        
    } else {
        newSize.height = image.size.height;
        newSize.width = image.size.height * newSize2.width / newSize2.height;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
        
    }
    
    return [UIImage imageWithCGImage:imageRef];
}


#pragma mark saveImage to Document
+(void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData * imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    
    NSString * fullPath = [LocalPath stringByAppendingPathComponent:imageName];
    [imageData writeToFile:fullPath atomically:NO];
}

#pragma mark uploade image to Qiniu
+(NSString *)uploadPhotoWith:(NSString *)photoPath
{
    NSString *  imageURL;
    
    
    __block  NSString * image = imageURL;
    NSString * token;
    [NSHttpClient client];
    
    

    [[NSHttpClient client]

      requestWithURL:@"qiniuUrl"
     
      paras:nil success:^(NSURLSessionDataTask *operation, NSObject *parserObject) {
         NSFileManager *fileManager = [NSFileManager defaultManager];
         if ([fileManager fileExistsAtPath:photoPath]) {
             QNUploadManager * upManager = [[QNUploadManager alloc] init];
             NSData * imageData = [NSData dataWithContentsOfFile:photoPath];
             [upManager putData:imageData key:nil token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                 
                   image = [NSString stringWithFormat:@"%@",[resp objectForKey:@"key"]];
                 
                 
             } option:nil];
         }
         
         
    } failure:^(NSURLSessionDataTask *operation, NSError *requestErr) {
        NSLog(@"%@",requestErr);
    }];
    return imageURL;
}

@end

@implementation Memory

+(NSString *)getCacheSize
{
    
    NSFileManager * fm = [NSFileManager defaultManager];
    NSString *webPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/Temp"];
    
    NSString *cachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/musicCache"];
    NSString * fileName;
    //获取cache
    //    if (![fm fileExistsAtPath:webPath]&&![fm fileExistsAtPath:cachePath]) {
    //        return @"0";
    //    }
    
    NSEnumerator * childFilesEnumerator = [[fm subpathsAtPath:webPath] objectEnumerator];
    float folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject])!=nil) {
        NSLog(@"file%@",fileName);
        NSString * fileAbsolutePath = [webPath stringByAppendingPathComponent:fileName];
        folderSize+=[[fm attributesOfItemAtPath:fileAbsolutePath error:nil] fileSize];
    }
    
    NSEnumerator * childFilesEnumerator1 = [[fm subpathsAtPath:cachePath] objectEnumerator];
    
    while ((fileName = [childFilesEnumerator1 nextObject])!=nil) {
        NSString * fileAbsolutePath1 = [cachePath stringByAppendingPathComponent:fileName];
        folderSize+=[[fm attributesOfItemAtPath:fileAbsolutePath1 error:nil] fileSize];
    }
    folderSize = folderSize/(1024.0*1024.0);
    
    NSString * size = [NSString stringWithFormat:@"%0.2fM",folderSize];
    return size;
}

+(void)clearCache
{
    NSString *webPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/Temp"];
    NSString *cachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/musicCache"];
    NSFileManager * fm = [NSFileManager defaultManager];
    NSString * fileName;
    NSEnumerator * childFilesEnumerator = [[fm subpathsAtPath:webPath] objectEnumerator];
    //    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject])!=nil) {
        NSLog(@"file%@",fileName);
        NSString * fileAbsolutePath = [webPath stringByAppendingPathComponent:fileName];
        [fm removeItemAtPath:fileAbsolutePath error:nil];
    }
    
    NSEnumerator * childFilesEnumerator1 = [[fm subpathsAtPath:cachePath] objectEnumerator];
    
    while ((fileName = [childFilesEnumerator1 nextObject])!=nil) {
        NSString * fileAbsolutePath1 = [cachePath stringByAppendingPathComponent:fileName];
        [fm removeItemAtPath:fileAbsolutePath1 error:nil];
    }
    
    
    //    [fm removeItemAtPath:webPath error:nil];
    //    [fm removeItemAtPath:cachePath error:nil];
    
    
}

@end

@implementation date

+(NSString *)datetoStringWithDate:(NSDate *)date
{
    NSDateFormatter * fomatter = [[NSDateFormatter alloc] init];
    [fomatter setDateFormat:@"YYYY-MM-dd"];
    NSString * dateString = [fomatter stringFromDate:date];
    return dateString;
}

//date to string format like "1992-12-05 12:33"
+(NSString *)datetoLongStringWithDate:(NSDate *)date
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSString * currentTimeString = [formatter stringFromDate:date];
    return currentTimeString;
}

//date to string formatLike "4月5日"

+(NSString *)datetoMonthStringWithDate:(NSDate *)date
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM月dd日"];
    NSString * dateString = [formatter stringFromDate:date];
    return dateString;
}
@end
