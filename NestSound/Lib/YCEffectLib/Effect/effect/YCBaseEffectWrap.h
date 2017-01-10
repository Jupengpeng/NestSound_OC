#ifndef __YINCHAO_BASE_EFFECT_H
#define __YINCHAO_BASE_EFFECT_H

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include "IAYMediaPlayer.h"
using namespace std;
extern "C"{
#include "sox.h"
};

class  CBaseEffectWrap
{
public:
	CBaseEffectWrap();
	CBaseEffectWrap(double sampleRate,int channels,int sampleBit);
	virtual ~CBaseEffectWrap();
	virtual int setEffectParams(int eYcEffect,const char*in_path,const char *out_path);
	virtual void doEffect();
	virtual void destroy();


public: 
	int  initEncodeInfo();
	int  initSignalInfo();
	void init();
private: 


	sox_format_t*					m_out;
	sox_format_t*					m_in;
	sox_effects_chain_t*			m_pEffectChain;
	sox_effect_t*					m_pEffect;
	sox_encodinginfo_t				m_sEncodeInfo;
	sox_signalinfo_t				m_sSignalInfo;
	double							m_sampleRate;
	int								m_channels;
	int								m_sampleBit;

};
#endif __YINCHAO_BASE_EFFECT_H
