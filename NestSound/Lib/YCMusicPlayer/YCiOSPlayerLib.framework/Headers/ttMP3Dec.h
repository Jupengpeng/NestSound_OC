/******************************************************************************
*
* Shuidushi Software Inc.
* (c) Copyright 2014 Shuidushi Software, Inc.
* ALL RIGHTS RESERVED.
*
*******************************************************************************
*
*  File Name: ttMP3Dec.h
*
*  File Description:TT MP3 decoder APIs function header
*
*******************************Change History**********************************
* 
*    DD/MM/YYYY      Code Ver     Description       Author
*    -----------     --------     -----------       ------
*    30/June/2013      v1.0        Initial version   Kevin
*
*******************************************************************************/
#ifndef __TT_MP3DEC_H__
#define __TT_MP3DEC_H__

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#include "TTOsalConfig.h"
#include "TTAudio.h"

#define	TT_ERR_MP3_BASE			0x82010000
#define TTErrMP3InvFrame        (TT_ERR_MP3_BASE | 0x0001)	

/**
 * Get Audio codec API interface
 * \param pDecHandle [out] Return the ADPCM Decoder handle.
 * \retval TT_ERR_OK Succeeded.
 */
DLLEXPORT_C TTInt32 ttGetMP3DecAPI(TTAudioCodecAPI * pDecHandle);

typedef TTInt32 (*__GetMP3DecAPI)(TTAudioCodecAPI * pDecHandle);

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif //__TT_MP3DEC_H__
