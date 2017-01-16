#ifndef __AUDIO_MIX__
#define __AUDIO_MIX__


#include "STDataReaderItf.h"
#include "STFileReader.h"
#include "IAYMediaPlayer.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "ulu_common.h"
class CAudioMix{

public:
	CAudioMix();
	virtual ~CAudioMix();

public:
	virtual int setFilePath(int iAudioType,char*path);

	virtual int setAudioFormat(int iAudioType,AYMediaAudioFormat sFormat);

	virtual int setAudioVolume(int iAudioType,int volume);

	virtual int getMixSample(char*mixOut);

	virtual	void resetReader();
	
	virtual int getPlayerDuration(int *duration);

	virtual int getCurPlayPositon(int *positon);
	
	virtual int setStepSize(int recStepSize,int accStepSize);

	virtual int seekTo(int iPositon);

private:
	void  mixAudio(char*pOutBuffer,char*pRecordBuffer,char*pBackGroudBuffer,int bufferSize);
	int	  mono2stereo(short*pDstBuffer,short*pSrcBuffer,int inSize);
private:

	//file reader
	ISTDataReaderItf		*m_pRecodReader;
	ISTDataReaderItf		*m_pBackgroudReader;

	//step size
	int						m_iRecordStepSize;
	int						m_iBackGroudStepSize;

	unsigned int			m_recoderReadPos;
	unsigned int			m_backGroudReadPos;

	//format
	AYMediaAudioFormat		m_sRecordAudioFormat;
	AYMediaAudioFormat		m_sBackGroudAudioFormat;

	//buffer
	unsigned char			*m_pRecordBuffer;
	unsigned char           *m_pBackGroudBuffer;

	//
	int						m_iRecordBytesPerSec;
	int						m_iBackGroudBytesPerSec;

	//volume
	int						m_iRecordVolume;
	int						m_iBackGroudVolume; 
};


#endif 