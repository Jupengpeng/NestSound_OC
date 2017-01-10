#include "YCMp3encWrap.h"
#ifdef _LINUX_ANDROID
    extern void jni_onPlayerNotify(void * pUserData, AY_STATUS status,int value,const char * msg);

#endif


CYCMp3encWrap::CYCMp3encWrap(const char* recpath,AYMediaAudioFormat recFormat,const char *accpath,AYMediaAudioFormat accFormat)
	:m_pAudioMix(NULL)
	,m_pMp3Encoder(NULL)
{
	m_pAudioMix = new CAudioMix();
	if (recpath!=NULL)
	{
		m_pAudioMix->setFilePath(PID_RECORD_FILE_PATH,(char*)recpath);
	}

	m_pAudioMix->setAudioFormat(PID_RECORDER_AUDIO_FORMAT,recFormat);
	if (accpath!=NULL)

	{
		m_pAudioMix->setFilePath(PID_BACKGROUD_FILE_PATH,(char*)accpath);
	}

	m_pAudioMix->setAudioFormat(PID_BACKGROUD_AUDIO_FORMAT,accFormat);

	m_pMp3Encoder = new CMp3Encoder();
	m_pMp3Encoder->init(accFormat.nSamplesPerSec,accFormat.nChannels,accFormat.wBitsPerSample);
	int frameSize = m_pMp3Encoder->getFrameSize();
	if (recFormat.nChannels ==1)
	{
		m_pAudioMix->setStepSize(frameSize*2,frameSize*2*2);
	}else{
		m_pAudioMix->setStepSize(frameSize*2,frameSize*2);
	}
}


int CYCMp3encWrap::saveMp3(const char *mp3SavePath){
	if (m_pAudioMix==NULL)
	{
		return 1;
	}
	if (m_pMp3Encoder==NULL)
	{
		return 1;
	}
	m_pAudioMix->resetReader();
	FILE *mp3File = fopen(mp3SavePath,"wb");
	char *mixOut =(char*)malloc(10000);
	short buffer[2][1152];
	do 
	{
		int size =m_pAudioMix->getMixSample(mixOut);
		if (size>0)
		{
			short *p = (short*)mixOut;
			for(int i=0;i<size/4;i++){
				buffer[0][i]= *p++;
				buffer[1][i]= *p++;
			}
			unsigned char mp3buf[1000];
			int mp3bufsize=1000;
			int outsize =m_pMp3Encoder->process(buffer[0],buffer[1],size/4,mp3buf,mp3bufsize);
			int process = 0;
			m_pAudioMix->getCurPlayPositon(&process);
    #ifdef _LINUX_ANDROID
            jni_onPlayerNotify(NULL,YC_PCMPLAYER_MP3SAVEPROGRESS,process,"saveMp3");
            
    #endif
			fwrite(mp3buf,1,outsize,mp3File);
			ULULOGI("process =%d",m_pAudioMix->getPlayerDuration());
		}else{
			break;
		}

	} while (1);

	if (mixOut)
	{
		free(mixOut);
	}
	fclose(mp3File);
	return 1;
}




CYCMp3encWrap::~CYCMp3encWrap()
{
	if (m_pAudioMix)
	{
		delete m_pAudioMix;
		m_pAudioMix =NULL;
	}
	if (m_pMp3Encoder)
	{
		delete m_pMp3Encoder;
		m_pMp3Encoder=NULL;
	}

}
