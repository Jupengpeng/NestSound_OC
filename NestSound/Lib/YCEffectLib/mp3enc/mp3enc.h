#ifndef __MP3_ENC__
#define __MP3_ENC__
#include "lame.h"
class CMp3Encoder{
public:
	CMp3Encoder();
	virtual ~CMp3Encoder();

public:
	void init(int samplerate,int channel,int bitrate);
	int process(short *buffer_l,short *buffer_r,int size,unsigned char *mp3buf,int mp3BufSize);
	void destroy();
	int getFrameSize();
private:
	lame_global_flags			*m_lame;


};

#endif