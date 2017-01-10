//
//  AyUtil.h
//  UAnYan
//
//  Created by CaoZhihui on 16/4/12.
//  Copyright © 2016年 Wyeth. All rights reserved.
//

#ifndef AyUtil_h
#define AyUtil_h

#include <stdio.h>

void str_to_hex(uint8_t *dest, const char *src, uint str_len);

void yuv420_2_rgb8888(uint8_t  *dst_ptr_,
                      const uint8_t  *y_ptr,
                      const uint8_t  *u_ptr,
                      const uint8_t  *v_ptr,
                      int32_t   width,
                      int32_t   height);

void YUV420p_to_RGB24(unsigned char *yuv420[3], unsigned char *rgb24, int width, int height);
void yuv420p_to_rgb24_2(unsigned char *yuvbuffer[3],unsigned char* rgbbuffer, int width,int height);

#endif /* AyUtil_h */
