//
//  AyUtil.c
//  UAnYan
//
//  Created by CaoZhihui on 16/4/12.
//  Copyright © 2016年 Wyeth. All rights reserved.
//

#include "AyUtil.h"
#include <ctype.h>
#include "yuv2rgb565_table.h"
#include <stdlib.h>

void str_to_hex(uint8_t *dest, const char *src, uint str_len)
{
    unsigned char h1, h2;
    uint8_t s1,s2;
    int i;
    
    for (i = 0; i < str_len/2; i++)
    {
        h1 = src[2*i];
        h2 = src[2*i+1];
        
        s1 = toupper(h1) - 0x30;
        if (s1 > 9)
            s1 -= 7;
        
        s2 = toupper(h2) - 0x30;
        if (s2 > 9)
            s2 -= 7;
        
        dest[i] = s1*16 + s2;
    }
}

#define UpAlign4(n) (((n) + 3) & ~3)
#define UpAlign8(n) (((n) + 7) & ~7)

int rgb565_to_rgbx8888(const void * psrc, int w, int h, void * pdst)
{
    int srclinesize = UpAlign4(w * 2);
    int dstlinesize = UpAlign4(w * 4);
    
    const unsigned char  * psrcline;
    const unsigned short * psrcdot;
    unsigned char  * pdstline;
    unsigned char  * pdstdot;
    
    int i,j;
    
    if (!psrc || !pdst || w <= 0 || h <= 0) {
        printf("rgb565_to_rgbx8888 : parameter error\n");
        return -1;
    }
    
    psrcline = (const unsigned char *)psrc;
    pdstline = (unsigned char *)pdst;
    for (i=0; i<h; i++) {
        psrcdot = (const unsigned short *)psrcline;
        pdstdot = pdstline;
        for (j=0; j<w; j++) {
            pdstdot++;
            *pdstdot++ = (unsigned char)(((*psrcdot) >> 0 ) << 3);
            *pdstdot++ = (unsigned char)(((*psrcdot) >> 5 ) << 2);
            *pdstdot++ = (unsigned char)(((*psrcdot) >> 11) << 3);
            psrcdot++;
        }
        psrcline += srclinesize;
        pdstline += dstlinesize;
    }
    
    return 0;
}

void yuv420_2_rgb8888(uint8_t  *dst_ptr_,
                      const uint8_t  *y_ptr,
                      const uint8_t  *u_ptr,
                      const uint8_t  *v_ptr,
                      int32_t   width,
                      int32_t   height)
{
    uint32_t *tables = yuv2rgb565_table;
//    void *dst_565_ptr_ = malloc(width * height * 4);
    uint32_t *dst_565_ptr = (uint32_t *)dst_ptr_;
    int32_t   y_span = width;
    int32_t   uv_span = width>>1;
    int32_t   dst_span = width<<2;
    dst_span >>= 2;
    
    height -= 1;
    while (height > 0)
    {
        height -= width<<16;
        height += 1<<16;
        while (height < 0)
        {
            /* Do 2 column pairs */
            uint32_t uv, y0, y1;
            
            uv  = READUV(*u_ptr++,*v_ptr++);
            y1  = uv + READY(y_ptr[y_span]);
            y0  = uv + READY(*y_ptr++);
            FIXUP(y1);
            FIXUP(y0);
            STORE(y1, dst_565_ptr[dst_span]);
            STORE(y0, *dst_565_ptr++);
            y1  = uv + READY(y_ptr[y_span]);
            y0  = uv + READY(*y_ptr++);
            FIXUP(y1);
            FIXUP(y0);
            STORE(y1, dst_565_ptr[dst_span]);
            STORE(y0, *dst_565_ptr++);
            height += (2<<16);
        }
        if ((height>>16) == 0)
        {
            /* Trailing column pair */
            uint32_t uv, y0, y1;
            
            uv = READUV(*u_ptr,*v_ptr);
            y1 = uv + READY(y_ptr[y_span]);
            y0 = uv + READY(*y_ptr++);
            FIXUP(y1);
            FIXUP(y0);
            STORE(y0, dst_565_ptr[dst_span]);
            STORE(y1, *dst_565_ptr++);
        }
        dst_565_ptr += dst_span*2-width;
        y_ptr   += y_span*2-width;
        u_ptr   += uv_span-(width>>1);
        v_ptr   += uv_span-(width>>1);
        height = (height<<16)>>16;
        height -= 2;
    }
    if (height == 0)
    {
        /* Trail row */
        height -= width<<16;
        height += 1<<16;
        while (height < 0)
        {
            /* Do a row pair */
            uint32_t uv, y0, y1;
            
            uv  = READUV(*u_ptr++,*v_ptr++);
            y1  = uv + READY(*y_ptr++);
            y0  = uv + READY(*y_ptr++);
            FIXUP(y1);
            FIXUP(y0);
            STORE(y1, *dst_565_ptr++);
            STORE(y0, *dst_565_ptr++);
            height += (2<<16);
        }
        if ((height>>16) == 0)
        {
            /* Trailing pix */
            uint32_t uv, y0;
            
            uv = READUV(*u_ptr++,*v_ptr++);
            y0 = uv + READY(*y_ptr++);
            FIXUP(y0);
            STORE(y0, *dst_565_ptr++);
        }
    }
    
//    //rgb565 to rgbx8888
//    rgb565_to_rgbx8888(dst_565_ptr_, width, height, dst_ptr_);
//    free(dst_565_ptr_);
//    dst_565_ptr = NULL;
}

void YUV420p_to_RGB24(unsigned char *yuv420[3], unsigned char *rgb24, int width, int height)
{
    //  int begin = GetTickCount();
    int R,G,B,Y,U,V;
    int x,y;
    int nWidth = width>>1; //色度信号宽度
    for (y=0; y < height; y++) {
        for (x=0; x < width; x++) {
            
            Y = *(yuv420[0] + y*width + x);
            U = *(yuv420[1] + ((y>>1)*nWidth) + (x>>1));
            V = *(yuv420[2] + ((y>>1)*nWidth) + (x>>1));
            
//            R = Y + 1.402*(V-128);
//            G = Y - 0.34414*(U-128) - 0.71414*(V-128);
//            B = Y + 1.772*(U-128);
            
//            R = (Y + (359 * V)) >> 8;
//            G = (Y - (88 * U) - (183 * V)) >> 8;
//            B = (Y + (454 * U)) >> 8;
            
//            R = Y + 1.28033*(V-128);
//            G = Y - 0.21482*(U-128) - 0.38059*(V-128);
//            B = Y + 2.12798*(U-128);
            
            B = 1.164*(Y - 16)                   + 2.018*(U - 128);
            
            G = 1.164*(Y - 16) - 0.813*(V - 128) - 0.391*(U - 128);
            
            R = 1.164*(Y - 16) + 1.596*(V - 128);
            


            
            //防止越界
            if (R>255)R=255;
            if (R<0)R=0;
            if (G>255)G=255;
            if (G<0)G=0;
            if (B>255)B=255;
            if (B<0)B=0;
            /**
             *vertical conver
            *(rgb24 + ((height-y-1)*width + x)*3) = B;
            *(rgb24 + ((height-y-1)*width + x)*3 + 1) = G;
            *(rgb24 + ((height-y-1)*width + x)*3 + 2) = R;
             */
            
            *(rgb24 + (y*width + x)*3) = B;
            *(rgb24 + (y*width + x)*3 + 1) = G;
            *(rgb24 + (y*width + x)*3 + 2) = R;
        }//for
    }//for
}


static long int crv_tab[256];
static long int cbu_tab[256];
static long int cgu_tab[256];
static long int cgv_tab[256];
static long int tab_76309[256];
static unsigned char clp[1024];   //for clip in CCIR601

void init_yuv420p_table()
{
    long int crv,cbu,cgu,cgv;
    int i,ind;
    
    crv = 104597; cbu = 132201;  /* fra matrise i global.h */
    cgu = 25675;  cgv = 53279;
    
    for (i = 0; i < 256; i++)
    {
        crv_tab[i] = (i-128) * crv;
        cbu_tab[i] = (i-128) * cbu;
        cgu_tab[i] = (i-128) * cgu;
        cgv_tab[i] = (i-128) * cgv;
        tab_76309[i] = 76309*(i-16);
    }
    
    for (i = 0; i < 384; i++)
        clp[i] = 0;
    ind = 384;
    for (i = 0;i < 256; i++)
        clp[ind++] = i;
    ind = 640;
    for (i = 0;i < 384; i++)
        clp[ind++] = 255;
}

/**
 内存分布
 w
 +--------------------+
 |Y0Y1Y2Y3...         |
 |...                 |   h
 |...                 |
 |                    |
 +--------------------+
 |U0U1      |
 |...       |   h/2
 |...       |
 |          |
 +----------+
 |V0V1      |
 |...       |  h/2
 |...       |
 |          |
 +----------+
 w/2
 */
void yuv420p_to_rgb24_2(unsigned char *yuvbuffer[3],unsigned char* rgbbuffer, int width,int height)
{
    int y1, y2, u, v;
    unsigned char *py1, *py2;
    int i, j, c1, c2, c3, c4;
    unsigned char *d1, *d2;
    unsigned char *src_u, *src_v;
    static int init_yuv420p = 0;
    
    /**
     void yuv420p_to_rgb24(unsigned char* yuvbuffer,unsigned char* rgbbuffer, int width,int height)
     
     src_u = yuvbuffer + width * height;   // u
     src_v = src_u + width * height / 4;  // v
     
     py1 = yuvbuffer;   // y
     */
    
    src_u = yuvbuffer[1];   // u
    src_v = yuvbuffer[2];  // v
    
    py1 = yuvbuffer[0];   // y
    
    py2 = py1 + width;
    d1 = rgbbuffer;
    d2 = d1 + 3 * width;
    
    if (init_yuv420p == 0)
    {
        init_yuv420p_table();
        init_yuv420p = 1;
    }
    
    for (j = 0; j < height; j += 2)
    {
        for (i = 0; i < width; i += 2)
        {
            u = *src_u++;
            v = *src_v++;
            
            c1 = crv_tab[v];
            c2 = cgu_tab[u];
            c3 = cgv_tab[v];
            c4 = cbu_tab[u];
            
            //up-left
            y1 = tab_76309[*py1++];
            *d1++ = clp[384+((y1 + c1)>>16)];
            *d1++ = clp[384+((y1 - c2 - c3)>>16)];
            *d1++ = clp[384+((y1 + c4)>>16)];
            
            //down-left
            y2 = tab_76309[*py2++];
            *d2++ = clp[384+((y2 + c1)>>16)];
            *d2++ = clp[384+((y2 - c2 - c3)>>16)];
            *d2++ = clp[384+((y2 + c4)>>16)];
            
            //up-right
            y1 = tab_76309[*py1++];
            *d1++ = clp[384+((y1 + c1)>>16)];
            *d1++ = clp[384+((y1 - c2 - c3)>>16)];
            *d1++ = clp[384+((y1 + c4)>>16)];
            
            //down-right
            y2 = tab_76309[*py2++];
            *d2++ = clp[384+((y2 + c1)>>16)];
            *d2++ = clp[384+((y2 - c2 - c3)>>16)];
            *d2++ = clp[384+((y2 + c4)>>16)];
        }
        d1  += 3*width;
        d2  += 3*width;
        py1 += width;
        py2 += width;
    }
}