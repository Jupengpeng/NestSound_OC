//
//  NSTool.m
//  NestSound
//
//  Created by yandi on 4/16/16.
//  Copyright © 2016 yinchao. All rights reserved.
//

#import "NSTool.h"
#include <sys/sysctl.h>
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
            requestURL = [requestURL stringByAppendingFormat:@"%@",[USERDEFAULT objectForKey:customPortKey]];
        }
        return requestURL;
    }
    requestURL = host;
    if (![NSTool isStringEmpty:port]) {
        requestURL = [requestURL stringByAppendingFormat:@"%@",port];
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
//+ (UIImage *)cutImage:(UIImage*)image scaledToSize:(CGSize)newSize2
//{
//    //压缩图片
//    CGSize newSize;
//    CGImageRef imageRef;
//    
//    if ((image.size.width / image.size.height) < (newSize2.width / newSize2.height)) {
//        newSize.width = image.size.width;
//        newSize.height = image.size.width * newSize2.height / newSize2.width;
//        
//        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, fabs(image.size.height - newSize.height) / 2, newSize.width, newSize.height));
//        
//    } else {
//        newSize.height = image.size.height;
//        newSize.width = image.size.height * newSize2.width / newSize2.height;
//        
//        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
//        
//    }
//    
//    return [UIImage imageWithCGImage:imageRef];
//    
//}


#pragma mark saveImage to Document
+(void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData * imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    
    NSString * fullPath = [LocalPath stringByAppendingPathComponent:imageName];
    NSFileManager * fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:fullPath]) {
        [fm removeItemAtPath:fullPath error:nil];
    }
    [imageData writeToFile:fullPath atomically:NO];
}

#pragma mark uploade image to Qiniu
+(NSString *)uploadPhotoWith:(NSString *)photoPath type:(BOOL)type_ token:(NSString *)token url:(NSString *)url
{
    NSString *  fileURL;

    __block NSString * file = fileURL;
         NSFileManager *fileManager = [NSFileManager defaultManager];
         if ([fileManager fileExistsAtPath:photoPath]) {
             QNUploadManager * upManager = [[QNUploadManager alloc] init];
             NSData * imageData = [NSData dataWithContentsOfFile:photoPath];
             [upManager putData:imageData key:nil token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                 
                  file = [NSString stringWithFormat:@"%@",[resp objectForKey:@"key"]];
                 
                 
             } option:nil];
         }
    
    return file;
}


+(BOOL)isValidateMobile:(NSString *)mobile
{
    //cell number is 13， 15，18 begain，nine \d number
    NSString *phoneRegex = @"^((13[0-9])|(14[0-9])|(15[^4,\\D])|(18[0,0-9])|(17[0,6,7,8]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}


+(BOOL)compareWithUser:(long)userID
{
//    NSDictionary * userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSString * user = [NSString stringWithFormat:@"%ld",userID];
    if ([user isEqualToString:JUserID]) {
        return YES;
    }else{
        
        return NO;
    
    }
        
    
}

+(NSString *)encrytWithDic:(NSDictionary *)dic
{
    NSDictionary * dic1 = [[NSHttpClient client] encryptWithDictionary:@{@"data":dic} isEncrypt:YES];
    NSString * str =  [NSString stringWithFormat:@"data=%@",[dic1 objectForKey:requestData]];
    return str;
}

+(NSString *)stringFormatWithTimeLong:(long)times
{
    if (times) {
        NSString * minute;
        NSString * second;
        int seconds = times%60;
        long minutes = times/60;
        if (minutes/10 == 0) {
            minute = [NSString stringWithFormat:@"0%ld",minutes];
        }
        
        if (seconds/10 == 0) {
            second = [NSString stringWithFormat:@"0%d",seconds];
        }else{
            second = [NSString stringWithFormat:@"%d",seconds];
        }
        
        NSString * str = [NSString stringWithFormat:@"%@:%@",minute,second];
        return str;
    } else {
        return @"00:00";
    }
    
}

+ (NSString*)getMachine{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *name = malloc(size);
    sysctlbyname("hw.machine", name, &size, NULL, 0);
    
    NSString *machine = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
    
    free(name);
    
    if( [machine isEqualToString:@"i386"] || [machine isEqualToString:@"x86_64"] ) machine = @"ios_Simulator";
    else if( [machine isEqualToString:@"iPhone1,1"] ) machine = @"iPhone_1G";
    else if( [machine isEqualToString:@"iPhone1,2"] ) machine = @"iPhone_3G";
    else if( [machine isEqualToString:@"iPhone2,1"] ) machine = @"iPhone_3GS";
    else if( [machine isEqualToString:@"iPhone3,1"] ) machine = @"iPhone_4";
    else if ( [machine isEqualToString:@"iPhone4,1"]) machine = @"iPhone_4S";
    else if( [machine isEqualToString:@"iPod1,1"] ) machine = @"iPod_Touch_1G";
    else if( [machine isEqualToString:@"iPod2,1"] ) machine = @"iPod_Touch_2G";
    else if( [machine isEqualToString:@"iPod3,1"] ) machine = @"iPod_Touch_3G";
    else if( [machine isEqualToString:@"iPod4,1"] ) machine = @"iPod_Touch_4G";
    else if( [machine isEqualToString:@"iPad1,1"] ) machine = @"iPad_1";
    else if( [machine isEqualToString:@"iPad2,1"] ) machine = @"iPad_2";
    
    
    return machine;
}

+(CGFloat)getWidthWithContent:(NSString *)contentStr font:(UIFont *)font {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGSize size = [contentStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.width;
}

+(CGFloat)getHeightWithContent:(NSString *)contentStr width:(CGFloat)width font:(UIFont *)font lineOffset:(CGFloat)lineOffset{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    [dic setValue:@(lineOffset) forKey:NSBaselineOffsetAttributeName];
    CGSize size = [contentStr boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;

    return size.height
;
}

// data to jsonString
+ (NSString*)transformTOjsonStringWithObject:(id)object
{
    if (object == nil) {
        return @"";
    }
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        CHLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}


// calculate numberoflines

+ (CGFloat)numberOfTextIn:(UILabel *)label{
    // 获取单行时候的内容的size
    CGSize singleSize = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
    // 获取多行时候,文字的size
    CGSize textSize = [label.text boundingRectWithSize:CGSizeMake(label.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil].size;
    // 返回计算的行数
    return ceil( textSize.height / singleSize.height);
}

/** 通过行数, 返回更新时间 */
+ (NSString *)updateTimeForCreateTimeIntrval:(NSInteger)createTimeIntrval {
    // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 创建歌曲时间戳(后台返回的时间 一般是13位数字)
    NSTimeInterval createTime = createTimeIntrval/1000;
    // 时间差
    NSTimeInterval time = currentTime - createTime;
    
    if (time <60) {
        return @"刚刚";

    }
    //秒转分钟
    if (time<3600) {
        NSInteger minutes = time/60;
        return [NSString stringWithFormat:@"%ld分钟前",(long)minutes];

    }
    // 秒转小时
    NSInteger hours = time/3600;
    NSInteger days = time/3600/24;
    if (days<24 && days == 0) {
        return [NSString stringWithFormat:@"%ld小时前",(long)hours];
    }
    if (days == 1) {
        return @"昨天";
    }
    


    if (days < 7 && days > 1) {
        return [NSString stringWithFormat:@"%ld天前",(long)days];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM月dd日 HH:mm"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:createTime];

    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
//    //秒转天数
//    NSInteger days = time/3600/24;
//    if (days < 30) {
//        return [NSString stringWithFormat:@"%ld天前",(long)days];
//    }
//    //秒转月
//    NSInteger months = time/3600/24/30;
//    if (months < 12) {
//        return [NSString stringWithFormat:@"%ld月前",(long)months];
//    }
//    //秒转年
//    NSInteger years = time/3600/24/30/12;
//    return [NSString stringWithFormat:@"%ld年前",(long)years];
}

+ (NSArray *)getTagsFromTagString:(NSString *)tagString{
    
    NSMutableArray *tagArray =[NSMutableArray arrayWithArray: [tagString componentsSeparatedByString:@"/"]];
    [tagArray removeObject:@" "];
    return tagArray;
    
}

+ (BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)     {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                bCanRecord = granted;
            }];
        }
    }
    return bCanRecord;
}

@end

@implementation Memory

+(NSString *)getCacheSize
{
    
    NSFileManager * fm = [NSFileManager defaultManager];
   
    NSString * fileName;
    //获取cache
    //    if (![fm fileExistsAtPath:webPath]&&![fm fileExistsAtPath:cachePath]) {
    //        return @"0";
    //    }
    
    NSEnumerator * childFilesEnumerator = [[fm subpathsAtPath:LocalAccompanyPath] objectEnumerator];
    float folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject])!=nil) {
        NSString * fileAbsolutePath = [LocalAccompanyPath stringByAppendingPathComponent:fileName];
        folderSize+=[[fm attributesOfItemAtPath:fileAbsolutePath error:nil] fileSize];
    }
    
    
    folderSize = folderSize/(1024.0*1024.0);
    
    NSString * size = [NSString stringWithFormat:@"%0.2fM",folderSize];
    return size;
}

+(void)clearCache
{
    
    NSFileManager * fm = [NSFileManager defaultManager];
    NSString * fileName;
    NSEnumerator * childFilesEnumerator = [[fm subpathsAtPath:LocalAccompanyPath] objectEnumerator];
    //    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject])!=nil) {
        NSString * fileAbsolutePath = [LocalAccompanyPath stringByAppendingPathComponent:fileName];
        [fm removeItemAtPath:fileAbsolutePath error:nil];
    }
    
    
    
    //    [fm removeItemAtPath:webPath error:nil];
    //    [fm removeItemAtPath:cachePath error:nil];
    
    
}



@end

@implementation date
+(NSString *)datetoStringWithDate:(NSTimeInterval)date
{


    double d = date / 1000;
    NSDate * dat = [NSDate dateWithTimeIntervalSince1970:d];
    NSDateFormatter * fomatter = [[NSDateFormatter alloc] init];
    [fomatter setDateFormat:@"YYYY-MM-dd"];
    NSString * dateString = [fomatter stringFromDate:dat];
    return dateString;
}

//date to string format like "1992-12-05 12:33"
+(NSString *)datetoLongStringWithDate:(NSTimeInterval)date
{
    
    double d = date /1000;
    NSDate * dat = [NSDate dateWithTimeIntervalSince1970:d];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSString * currentTimeString = [formatter stringFromDate:dat];
    return currentTimeString;
}

+(NSString *)datetoLongLongStringWithDate:(NSTimeInterval)date
{
    
    double d = date /1000;
    NSDate * dat = [NSDate dateWithTimeIntervalSince1970:d];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString * currentTimeString = [formatter stringFromDate:dat];
    return currentTimeString;
}

//date to string formatLike "4月5日"

+(NSString *)datetoMonthStringWithDate:(NSTimeInterval)date
{
    double d = date /1000;
    NSDate * dat = [NSDate dateWithTimeIntervalSince1970:d];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY.MM.dd"];
    NSString * dateString = [formatter stringFromDate:dat];
    return dateString;
}

+(NSString *)datetoMonthStringWithDate:(NSTimeInterval)date format:(NSString *)format
{
    double d = date /1000;
    NSDate * dat = [NSDate dateWithTimeIntervalSince1970:d];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString * dateString = [formatter stringFromDate:dat];
    return dateString;
}


//get the time stamp
+(NSTimeInterval )getTimeStamp
{
    NSDate * date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval  timeStamp = [date timeIntervalSince1970];
   
    return timeStamp;
}
@end

@implementation Share

+(void)ShareWithTitle:(NSString *)title_ andShareUrl:(NSString *)shareUrl_ andShareImage:(NSString * )shareImage andShareText:(NSString *)shareText_ andVC:(UIViewController *)VC_
{
    
    [UMSocialData defaultData].extConfig.title = title_;
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeNone;
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
    [UMSocialData defaultData].extConfig.qqData.title = title_;
    [UMSocialData defaultData].extConfig.qzoneData.title = title_;
    if (shareImage.length == 0) {
        [UMSocialData defaultData].extConfig.qqData.shareImage = [UIImage imageNamed:@"2.0_placeHolder"];
        [UMSocialData defaultData].extConfig.qzoneData.shareImage = [UIImage imageNamed:@"2.0_placeHolder"];
        [UMSocialData defaultData].extConfig.wechatSessionData.shareImage = [UIImage imageNamed:@"2.0_placeHolder"];
        [UMSocialData defaultData].extConfig.wechatTimelineData.shareImage = [UIImage imageNamed:@"2.0_placeHolder"];
        
    }else{
    [UMSocialData defaultData].extConfig.qqData.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:shareImage]]];
         [UMSocialData defaultData].extConfig.qzoneData.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:shareImage]]];
        [UMSocialData defaultData].extConfig.wechatSessionData.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:shareImage]]];
        [UMSocialData defaultData].extConfig.wechatTimelineData.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:shareImage]]];
    }
    [UMSocialData defaultData].extConfig.qzoneData.url = shareUrl_;
    [UMSocialData defaultData].extConfig.qqData.url = shareUrl_;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url =  shareUrl_;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = shareUrl_;
   
    [UMSocialSnsService presentSnsIconSheetView:VC_ appKey:umAppKey shareText:shareText_ shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:shareImage]]]shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ,UMShareToQzone] delegate:nil];
    
}

+(BOOL)shareAvailableWeiXin
{
    if ([WXApi isWXAppInstalled]&&[WXApi isWXAppSupportApi]) {
        return YES;
    }else{
        return NO;
    }
}


+(BOOL)shareAvailableQQ
{
    if ([QQApiInterface isQQInstalled]&&[QQApiInterface isQQSupportApi]) {
        return YES;
    }else{
        return NO;
    }
}

+(BOOL)shareAvailableSina
{

    return YES;
}

@end
