//
//  PCCallback.h
//  AudioPlayTest
//
//  Created by CaoZhihui on 2016/12/20.
//  Copyright © 2016年 Ulucu. All rights reserved.
//

#ifndef PCCallback_h
#define PCCallback_h
#include "IAYMediaPlayer.h"
#include <stdio.h>

class YCCallback : public IAYMediaPlayerCallback{
    
public:
    YCCallback();
    virtual ~YCCallback();
    
public:
    virtual void OnPlayerNotify(void * pUserData, AY_STATUS status_code,int value, const char * msg);
};

#endif /* PCCallback_hpp */
