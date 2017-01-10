#include "YCBaseEffectWrap.h"

CBaseEffectWrap::CBaseEffectWrap(double sampleRate,int channels,int sampleBit)
{
	m_sampleRate = sampleRate;
	m_channels = channels;
	m_sampleBit =sampleBit;
	memset(&m_sSignalInfo,0,sizeof(m_sSignalInfo));
	memset(&m_sEncodeInfo,0,sizeof(m_sEncodeInfo));
	m_in =NULL;
	m_out=NULL;
	m_pEffectChain=NULL;
	init();
}
CBaseEffectWrap::CBaseEffectWrap()
{


}
CBaseEffectWrap::~CBaseEffectWrap()
{

}

void CBaseEffectWrap::doEffect(){
	if (m_pEffectChain!=NULL)
	{
		sox_flow_effects(m_pEffectChain, NULL, NULL);
	}

}

void CBaseEffectWrap::destroy()
{
	if (m_pEffectChain!=NULL)
	{
		sox_delete_effects_chain(m_pEffectChain);
	}
	sox_quit();
}

void CBaseEffectWrap::init()
{
	initEncodeInfo();
	initSignalInfo();
}

int CBaseEffectWrap::initEncodeInfo()
{
	do 
	{
		m_sEncodeInfo.encoding = SOX_ENCODING_SIGN2;
		m_sEncodeInfo.bits_per_sample =m_sampleBit;
		return 1;
	} while (0);
	return 0;
}

int CBaseEffectWrap::initSignalInfo()
{
	do{
		m_sSignalInfo.rate = m_sampleRate;
		m_sSignalInfo.channels = m_channels;
		m_sSignalInfo.precision =m_sampleBit;
		return 1;
	}while(0);
	return 0;
}

int CBaseEffectWrap::setEffectParams(int eYcEffect,const char*in_path,const char *out_path)
{

	char * args[10];
	sox_init();

	m_in = sox_open_read(in_path, &m_sSignalInfo, &m_sEncodeInfo, "raw");
	if (m_in==NULL)
	{
		return 1;
	}
	m_out = sox_open_write(out_path, &m_sSignalInfo, NULL, "raw", NULL, NULL);
	if (m_out==NULL)
	{
		return 1;
	}
	m_pEffectChain = sox_create_effects_chain(&m_sEncodeInfo, &m_sEncodeInfo);


	//set input params
	m_pEffect = sox_create_effect(sox_find_effect("input"));
	args[0] = (char *)m_in;
	sox_effect_options(m_pEffect, 1, args);
	sox_add_effect(m_pEffectChain, m_pEffect, &m_sSignalInfo, &m_sSignalInfo);
	free(m_pEffect);

	//add effect params
	/* Create the `equalizer' effect, and initialise it with the desired parameters: */
	if (eYcEffect & YC_EFFECTS_PROFEESSION )
	{
		for (int i=0;i<YC_EQUALIZER_NUM;i++)
		{
			m_pEffect = sox_create_effect(sox_find_effect("equalizer"));
			sox_effect_options(m_pEffect, 3, equalizerArgs[i]);
			/* Add the effect to the end of the effects processing chain: */
			sox_add_effect(m_pEffectChain, m_pEffect, &m_sSignalInfo, &m_sSignalInfo);
			free(m_pEffect);
		}

	}

	/* Create the `echo' effect, and initialise it with the desired parameters: */
	if (eYcEffect & YC_EFFECTS_ECHO )
	{

		m_pEffect = sox_create_effect(sox_find_effect("echo"));
		sox_effect_options(m_pEffect, 4, echoArgs);
		/* Add the effect to the end of the effects processing chain: */
		sox_add_effect(m_pEffectChain, m_pEffect, &m_sSignalInfo, &m_sSignalInfo);
		free(m_pEffect);


	}
	/* Create the `reverb' effect, and initialise it with the desired parameters: */
	if (eYcEffect & YC_EFFECTS_REVERB )
	{
		m_pEffect = sox_create_effect(sox_find_effect("reverb"));
		sox_effect_options(m_pEffect, 7, reverArgs);
		/* Add the effect to the end of the effects processing chain: */
		sox_add_effect(m_pEffectChain, m_pEffect, &m_sSignalInfo, &m_sSignalInfo);
		free(m_pEffect);
	}

	//set output params
	m_pEffect = sox_create_effect(sox_find_effect("output"));
	args[0] = (char *)m_out;
	sox_effect_options(m_pEffect, 1, args);
	sox_add_effect(m_pEffectChain, m_pEffect, &m_sSignalInfo, &m_sSignalInfo);
	free(m_pEffect);
	return 0;
}


