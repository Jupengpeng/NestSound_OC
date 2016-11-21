/******************************************************************************
*
* Shuidushi Software Inc.
* (c) Copyright 2014 Shuidushi Software, Inc.
* ALL RIGHTS RESERVED.
*
*******************************************************************************
*
*  File Name: ttMP3DecGlobal.h
*
*  File Description:TT MP3 decoder some global define 
*
*******************************Change History**********************************
* 
*    DD/MM/YYYY      Code Ver     Description       Author
*    -----------     --------     -----------       ------
*    30/June/2013      v1.0        Initial version   Kevin
*
*******************************************************************************/

#ifndef __TT_MP3DECGLOBAL_H__
#define __TT_MP3DECGLOBAL_H__

#include "TTTypedef.h"

#define Q4(A) (((A) >= 0) ? ((int)((A)*(1<<4)+0.5)) : ((int)((A)*(1<<4)-0.5)))
#define Q5(A) (((A) >= 0) ? ((int)((A)*(1<<5)+0.5)) : ((int)((A)*(1<<5)-0.5)))
#define Q6(A) (((A) >= 0) ? ((int)((A)*(1<<6)+0.5)) : ((int)((A)*(1<<6)-0.5)))
#define Q7(A) (((A) >= 0) ? ((int)((A)*(1<<7)+0.5)) : ((int)((A)*(1<<7)-0.5)))
#define Q8(A) (((A) >= 0) ? ((int)((A)*(1<<8)+0.5)) : ((int)((A)*(1<<8)-0.5)))
#define Q9(A) (((A) >= 0) ? ((int)((A)*(1<<9)+0.5)) : ((int)((A)*(1<<9)-0.5)))
#define Q10(A) (((A) >= 0) ? ((int)((A)*(1<<10)+0.5)) : ((int)((A)*(1<<10)-0.5)))
#define Q11(A) (((A) >= 0) ? ((int)((A)*(1<<11)+0.5)) : ((int)((A)*(1<<11)-0.5)))
#define Q12(A) (((A) >= 0) ? ((int)((A)*(1<<12)+0.5)) : ((int)((A)*(1<<12)-0.5)))
#define Q13(A) (((A) >= 0) ? ((int)((A)*(1<<13)+0.5)) : ((int)((A)*(1<<13)-0.5)))

#define Q14(A) (((A) >= 0) ? ((int)((A)*(1<<14)+0.5)) : ((int)((A)*(1<<14)-0.5)))
#define Q15(A) (((A) >= 0) ? ((int)((A)*(1<<15)+0.5)) : ((int)((A)*(1<<15)-0.5)))
#define Q16(A) (((A) >= 0) ? ((int)((A)*(1<<16)+0.5)) : ((int)((A)*(1<<16)-0.5)))
#define Q17(A) (((A) >= 0) ? ((int)((A)*(1<<17)+0.5)) : ((int)((A)*(1<<17)-0.5)))
#define Q18(A) (((A) >= 0) ? ((int)((A)*(1<<18)+0.5)) : ((int)((A)*(1<<18)-0.5)))
#define Q19(A) (((A) >= 0) ? ((int)((A)*(1<<19)+0.5)) : ((int)((A)*(1<<19)-0.5)))
#define Q20(A) (((A) >= 0) ? ((int)((A)*(1<<20)+0.5)) : ((int)((A)*(1<<20)-0.5)))
#define Q21(A) (((A) >= 0) ? ((int)((A)*(1<<21)+0.5)) : ((int)((A)*(1<<21)-0.5)))
#define Q22(A) (((A) >= 0) ? ((int)((A)*(1<<22)+0.5)) : ((int)((A)*(1<<22)-0.5)))
#define Q23(A) (((A) >= 0) ? ((int)((A)*(1<<23)+0.5)) : ((int)((A)*(1<<23)-0.5)))
#define Q24(A) (((A) >= 0) ? ((int)((A)*(1<<24)+0.5)) : ((int)((A)*(1<<24)-0.5)))
#define Q25(A) (((A) >= 0) ? ((int)((A)*(1<<25)+0.5)) : ((int)((A)*(1<<25)-0.5)))
#define Q26(A) (((A) >= 0) ? ((int)((A)*(1<<26)+0.5)) : ((int)((A)*(1<<26)-0.5)))
#define Q27(A) (((A) >= 0) ? ((int)((A)*(1<<27)+0.5)) : ((int)((A)*(1<<27)-0.5)))
#define Q28(A) (((A) >= 0) ? ((int)((A)*(1<<28)+0.5)) : ((int)((A)*(1<<28)-0.5)))
#define Q29(A) (((A) >= 0) ? ((int)((A)*(1<<29)+0.5)) : ((int)((A)*(1<<29)-0.5)))
#define Q30(A) (((A) >= 0) ? ((int)((A)*(1<<30)+0.5)) : ((int)((A)*(1<<30)-0.5)))
#define Q31(A) (((1.00 - (A))<0.00000001) ? ((int)0x7FFFFFFF) : (((A) >= 0) ? ((int)((A)*((unsigned int)(1<<31))+0.5)) : ((int)((A)*((unsigned int)(1<<31))-0.5))))

#define MUL_14(A,B) (int)(((TTInt64)(A)*(TTInt64)(B)+(1<<13)) >> 14)
#define MUL_15(A,B) (int)(((TTInt64)(A)*(TTInt64)(B)+(1<<14)) >> 15)
#define MUL_16(A,B) (int)(((TTInt64)(A)*(TTInt64)(B)+(1<<15)) >> 16)
#define MUL_17(A,B) (int)(((TTInt64)(A)*(TTInt64)(B)+(1<<16)) >> 17)
#define MUL_18(A,B) (int)(((TTInt64)(A)*(TTInt64)(B)+(1<<17)) >> 18)
#define MUL_19(A,B) (int)(((TTInt64)(A)*(TTInt64)(B)+(1<<18)) >> 19)
#define MUL_20(A,B) (int)(((TTInt64)(A)*(TTInt64)(B)+(1 << 19)) >> 20)
#define MUL_21(A,B) (int)(((TTInt64)(A)*(TTInt64)(B)+(1 << 20)) >> 21)
#define MUL_22(A,B) (int)(((TTInt64)(A)*(TTInt64)(B)+(1 << 21)) >> 22)
#define MUL_23(A,B) (int)(((TTInt64)(A)*(TTInt64)(B)+(1 << 22)) >> 23)
#define MUL_24(A,B) (int)(((TTInt64)(A)*(TTInt64)(B)+(1 << 23)) >> 24)
#define MUL_25(A,B) (int)(((TTInt64)(A)*(TTInt64)(B)+(1 << 24)) >> 25)
#define MUL_26(A,B) (int)(((TTInt64)(A)*(TTInt64)(B)+(1 << 25)) >> 26)
#define MUL_27(A,B) (int)(((TTInt64)(A)*(TTInt64)(B)+(1 << 26)) >> 27)
#define MUL_28(A,B) (int)(((TTInt64)(A)*(TTInt64)(B)+(1 << 27)) >> 28)
#define MUL_29(A,B) (int)(((TTInt64)(A)*(TTInt64)(B)+(1 << 28)) >> 29)
#define MUL_30(A,B) (int)(((TTInt64)(A)*(TTInt64)(B)+(1 << 29)) >> 30)
#define MUL_31(A,B) (int)(((TTInt64)(A)*(TTInt64)(B)+(1 << 30)) >> 31)
#define MUL_32(A,B) (int)(((TTInt64)(A)*(TTInt64)(B)) >> 32)
#define MUL_33(A,B) (int)(((TTInt64)(A)*(TTInt64)(B)) >> 33)
#define MUL_34(A,B) (int)(((TTInt64)(A)*(TTInt64)(B)) >> 34)
#define MUL_35(A,B) (int)(((TTInt64)(A)*(TTInt64)(B)) >> 35)
#define MUL_36(A,B) (int)(((TTInt64)(A)*(TTInt64)(B)) >> 36) 

#endif //__TT_MP3DECGLOBAL_H__
