//
//  UAnYanLog.h
//  UAnYan
//
//  Created by CaoZhihui on 16/3/17.
//  Copyright © 2016年 Wyeth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UAnYanLog : NSObject

+(UAnYanLog *)sharedInstance;

-(NSString *)getNetLibLogFilePath;

-(NSString *)getLogFilePath;

-(void)writeLog:(NSString *)log toFile:(NSString *)fullPath;

-(void)closeFile:(NSString *)fullPath;

-(void)closeAllFile;

@end
