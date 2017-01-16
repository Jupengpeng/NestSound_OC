//
//  PCCallback.cpp
//  AudioPlayTest
//
//  Created by CaoZhihui on 2016/12/20.
//  Copyright © 2016年 Ulucu. All rights reserved.
//

#include "PCCallback.h"
#import "YCPlayPCMCallback.h"


YCCallback::YCCallback() {
    
}

YCCallback::~YCCallback() {
    
}

void YCCallback::OnPlayerNotify(void * pUserData, AY_STATUS status_code,int value, const char * msg) {
    
    YCPlayPCMCallback *callBack = [YCPlayPCMCallback sharedPlayMusic];
    NSString *msgNSstring = [[NSString alloc] initWithUTF8String:msg];
    callBack.PCMPlayerBlock(msgNSstring);
    
}
