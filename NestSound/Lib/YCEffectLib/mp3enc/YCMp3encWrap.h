#ifndef __MP3_ENC_WRAP__
#define __MP3_ENC_WRAP__
#include "AudioMix.h"
#include "mp3enc.h"
#include "ulu_log.h"
class CYCMp3encWrap {
public:
	CYCMp3encWrap(const char* recpath,AYMediaAudioFormat recFormat,int recordVolume,const char *accpath,AYMediaAudioFormat accFormat,int accVolume);
	virtual ~CYCMp3encWrap();


public:
	int saveMp3(const char*mp3path);

private:
	CAudioMix     *m_pAudioMix;
	CMp3Encoder   *m_pMp3Encoder;

};


#endif 