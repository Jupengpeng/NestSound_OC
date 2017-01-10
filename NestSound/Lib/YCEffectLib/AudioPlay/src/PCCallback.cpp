//
//  PCCallback.cpp
//  AudioPlayTest
//
//  Created by CaoZhihui on 2016/12/20.
//  Copyright © 2016年 Ulucu. All rights reserved.
//

#include "PCCallback.h"

YCCallback::YCCallback() {

}

YCCallback::~YCCallback() {

}

void YCCallback::OnPlayerNotify(void * pUserData, AY_STATUS status_code,int value, const char * msg) {
    printf("OnPlayerNotify...\n");
}
