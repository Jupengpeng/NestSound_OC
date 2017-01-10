#include "mp3enc.h"

CMp3Encoder::CMp3Encoder(){
	m_lame=NULL;


}
CMp3Encoder::~CMp3Encoder(){

}

void CMp3Encoder::init(int samplerate,int channel,int bitrate)
{
	if (m_lame != NULL) {
		lame_close(m_lame);
		m_lame = NULL;
	}
	m_lame = lame_init();
	lame_set_in_samplerate(m_lame, samplerate);
	lame_set_num_channels(m_lame, channel);//输入流的声道
	lame_set_out_samplerate(m_lame, samplerate);
	lame_set_brate(m_lame, bitrate);
	lame_set_quality(m_lame, 7);
	lame_init_params(m_lame);
}

int CMp3Encoder::process(short *buffer_l,short *buffer_r,int size,unsigned char *mp3buf,int mp3BufSize)
{
	if (m_lame==NULL)
	{
		return -1;
	}
	int result = lame_encode_buffer(m_lame,buffer_l,buffer_r,size,mp3buf,mp3BufSize);
	return result;
}

void CMp3Encoder::destroy()
{
	lame_close(m_lame);
	m_lame = NULL;

}

int CMp3Encoder::getFrameSize()
{
	return lame_get_framesize(m_lame);
}

