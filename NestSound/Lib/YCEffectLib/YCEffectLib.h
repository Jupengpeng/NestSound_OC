//
//  YCEffectLib.h
//  NestSound
//
//  Created by 鞠鹏 on 2017/1/11.
//  Copyright © 2017年 yinchao. All rights reserved.
//

#ifndef YCEffectLib_h
#define YCEffectLib_h


#include <stdio.h>
#include <unistd.h>
#include <pthread.h>
#include <time.h>
#include <sys/time.h>
#include <string.h>
#include <stdlib.h>

#define ULU_Sprintf snprintf

#if 0

#define _logtimeFormat "%04d-%02d-%02d %02d:%02d:%02d.%03d"
#define SECOND_DIGIT 10000000000ll
static void logtimeToString(unsigned long long time, char *szTime, unsigned int nSize)
{/*eg.time = 1362037895,080*/
    struct tm tm1;
    time_t time1;
    unsigned int mmsec = 0;
    memset( szTime, 0x00, nSize);
    mmsec = time/SECOND_DIGIT >0 ? time %1000 : 0;
    time1 = (time_t)( time/SECOND_DIGIT >0 ? time /1000: time);
    
#ifdef _WIN32
    tm1 = *localtime(&time1);
#else
    localtime_r(&time1, &tm1 );
#endif //WIN32
    ULU_Sprintf(szTime, nSize ,_logtimeFormat, tm1.tm_year/*since +1900*/+1900, tm1.tm_mon, tm1.tm_mday, tm1.tm_hour, tm1.tm_min,tm1.tm_sec,mmsec);
    // 		tm1.tm_year+1900, tm1.tm_mon+1, tm1.tm_mday,
    // 		tm1.tm_hour, tm1.tm_min,tm1.tm_sec,mmsec);
}

#define _logTime(sz) \
{\
struct timeval t;\
unsigned long long ret = 0;\
if (gettimeofday(&t, NULL) == 0) \
{\
ret = t.tv_sec ;\
ret = ret * 1000 + t.tv_usec / 1000;\
}\
logtimeToString(ret, sz, sizeof(sz));\
}

#define _logTime(sz) \
{\
struct timeval t;\
unsigned long long ret = 0;\
if (gettimeofday(&t, NULL) == 0) \
{\
ret = t.tv_sec ;\
ret = ret * 1000 + t.tv_usec / 1000;\
}\
logtimeToString(ret, sz, sizeof(sz));\
}

#define U_Player_Log(fmt, ...) \
{ \
char szTime[255]; \
_logTime(szTime); \
printf("##Audio PLAY TEST##   %s %s\n", szTime, [[NSString stringWithFormat:fmt, ##__VA_ARGS__] UTF8String]); \
}


#else
#define U_Player_Log(...) {}
#endif

#if 0 //DEBUG //print function name
#define PRINT_FUNCTION_NAME NSLog(@"##########FUNCTION NAME:%s, in FILE:%s, LINE:%d#########", __FUNCTION__, __FILE__, __LINE__)
#else
#define PRINT_FUNCTION_NAME {}
#endif



#endif /* YCEffectLib_h */
