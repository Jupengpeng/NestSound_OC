//
//  UAnYanLog.m
//  UAnYan
//
//  Created by CaoZhihui on 16/3/17.
//  Copyright © 2016年 Wyeth. All rights reserved.
//

#import "UAnYanLog.h"
#include <map>
#include <pthread.h>

static UAnYanLog *shareInstance = nil;

@interface UAnYanLog (){
    NSString                    *m_logFilePath;
    NSDateFormatter             *m_dateFormatter;
    NSFileHandle                *m_fileHandle;
    
    pthread_mutex_t             m_write_file_mutex;
    
    std::map<NSString *, NSFileHandle *> writeFileHandleMap;
}

@end

@implementation UAnYanLog

+(UAnYanLog *)sharedInstance{
    @synchronized(self){
        if(nil == shareInstance){
            shareInstance = [[self alloc] init];
            shareInstance->m_logFilePath = nil;
            [shareInstance initData];
        }
    }
    return shareInstance;
}

-(void)initData{
    pthread_mutex_init(&m_write_file_mutex, NULL);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    m_logFilePath = [NSString stringWithFormat:@"%@/sdk_data/", docDir];
    
    //若文件路径不存在则创建
    NSFileManager *fileManager = [NSFileManager defaultManager];//create instance of NSFileManager
    if(![fileManager fileExistsAtPath:m_logFilePath])
    {
        [fileManager createDirectoryAtPath:m_logFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    m_dateFormatter = [[NSDateFormatter alloc] init];
    [m_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSSS"];
}

-(NSString *)getNetLibLogFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *netLibLogFilePath = [NSString stringWithFormat:@"%@/sdk_data/", docDir];
    
    //若文件路径不存在则创建
    NSFileManager *fileManager = [NSFileManager defaultManager];//create instance of NSFileManager
    if(![fileManager fileExistsAtPath:netLibLogFilePath])
    {
        [fileManager createDirectoryAtPath:netLibLogFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return netLibLogFilePath;
}

-(NSString *)getLogFilePath{
    
    if (nil != m_logFilePath) {
        return m_logFilePath;
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    m_logFilePath = [NSString stringWithFormat:@"%@/sdk_data/", docDir];
    
    //若文件路径不存在则创建
    NSFileManager *fileManager = [NSFileManager defaultManager];//create instance of NSFileManager
    if(![fileManager fileExistsAtPath:m_logFilePath])
    {
        [fileManager createDirectoryAtPath:m_logFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return m_logFilePath;
}

-(void)writeLog:(NSString *)log toFile:(NSString *)fullPath{
    pthread_mutex_lock(&m_write_file_mutex);
    NSFileManager *fileManager = [NSFileManager defaultManager];//create instance of NSFileManager
    if(![fileManager fileExistsAtPath:fullPath])
    {
        [fileManager createFileAtPath:fullPath contents:nil attributes:nil];
    }
//    [log writeToFile:fullPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    //find mutex lock
    std::map<NSString *, NSFileHandle *>::iterator it = writeFileHandleMap.find(fullPath);
    
    NSFileHandle *currentFileHandle;
    
    if (it == writeFileHandleMap.end()) {
        currentFileHandle = [NSFileHandle fileHandleForUpdatingAtPath:fullPath];
        writeFileHandleMap[fullPath] = currentFileHandle;
        [currentFileHandle seekToEndOfFile];  //将节点跳到文件的末尾
    } else {
        currentFileHandle = it->second;
    }
    
    NSString *datestr = [m_dateFormatter stringFromDate:[NSDate date]];
    NSString *str = [NSString stringWithFormat:@"\n%@:%@",datestr,log];
    
    NSData* stringData  = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [currentFileHandle writeData:stringData]; //追加写入数据
    pthread_mutex_unlock(&m_write_file_mutex);
    
}

-(void)closeFile:(NSString *)fullPath{
    pthread_mutex_lock(&m_write_file_mutex);
    std::map<NSString *, NSFileHandle *>::iterator it = writeFileHandleMap.find(fullPath);
    if (it != writeFileHandleMap.end()) {
        NSFileHandle *currentFileHandle = it->second;
        if (nil != currentFileHandle) {
            [currentFileHandle closeFile];
        }
        it->second = nil;
        writeFileHandleMap.erase(fullPath);
    }
    pthread_mutex_unlock(&m_write_file_mutex);
}

-(void)closeAllFile{
    pthread_mutex_lock(&m_write_file_mutex);
    std::map<NSString *, NSFileHandle *>::iterator it = writeFileHandleMap.begin();
    for (; it != writeFileHandleMap.end(); ++it){
        NSFileHandle *currentFileHandle = it->second;
        [currentFileHandle closeFile];
    }
    
    if (writeFileHandleMap.size() > 0) {
        NSLog(@"writeFileMap size = %lu", writeFileHandleMap.size());
        writeFileHandleMap.clear();
    }
    pthread_mutex_unlock(&m_write_file_mutex);
}

@end
