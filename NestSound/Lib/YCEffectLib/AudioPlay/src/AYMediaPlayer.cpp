#include "AYMediaPlayer.h"
#include "ulu_log.h"
AYMEDIAPLAYER_SDK_API bool createMediaPlayerInstance(MediaPlayerInitParam * pInitParam, IAYMediaPlayer ** ppiMediaPlayer){

	CAYMediaPlayer *pMediaPlayer =  new CAYMediaPlayer();
	if(!pMediaPlayer)
		return false;
	pMediaPlayer->SetMediaPlayerInitParam(pInitParam);
	*ppiMediaPlayer = pMediaPlayer;
	return true;
}


AYMEDIAPLAYER_SDK_API void destroyMediaPlayerInstance(IAYMediaPlayer *& piMediaPlayer){
	delete piMediaPlayer;
}

CAYMediaPlayerThread::CAYMediaPlayerThread(CAYMediaPlayer*pMediaPlayer)
	: m_pMediaPlayer(pMediaPlayer)
{
	ut_begin();
}


CAYMediaPlayerThread::~CAYMediaPlayerThread()
{

}

void CAYMediaPlayerThread::ut_thread_function()
{
	m_pMediaPlayer->functionAudioThread();
}
CAYMediaPlayer::CAYMediaPlayer()
	: m_pAudioThread(NULL)
	, m_pMediaPlayInitParam(NULL)
	, m_pJVM(NULL)
	, m_pViderRenderView(NULL)
	, m_bIsPauseFlag(false)
	, m_bIsNeedRender(true)
	, m_iSeekPostion(0)
	, m_pAudioMix(NULL)
	, m_pMp3Encoder(NULL)
{
	initAudioContext();
}

CAYMediaPlayer::~CAYMediaPlayer(){
	stop();
	unInitAudioContext();
}

int CAYMediaPlayer::initAudioContext(){

	m_pAudioRender = NULL;
	m_iRecordAudioVolume = 0;
	m_iBackGroudAudioVolume =0;
	if (m_pAudioMix==NULL)
	{
		m_pAudioMix = new CAudioMix();
	}

	return 0;
}

int CAYMediaPlayer::unInitAudioContext(){
	if (m_pAudioRender)
	{
		delete m_pAudioRender;
		m_pAudioRender =NULL;
	}
	if (m_pAudioMix)
	{
		delete m_pAudioMix;
		m_pAudioMix =NULL;
	}
	return 0;
}



int CAYMediaPlayer::run()
{

	//audio thread start
	initAudioContext();
	if (m_pAudioThread)
	{
		m_bAudioRunningFlag =false;
		delete m_pAudioThread;
	}
	m_bAudioRunningFlag = true;
	m_pAudioThread = new CAYMediaPlayerThread(this);

	return 0;
}

int CAYMediaPlayer::pause()
{
	if (m_pMediaPlayInitParam!=NULL&&m_pMediaPlayInitParam->piCallback!=NULL)
	{
		m_pMediaPlayInitParam->piCallback->OnPlayerNotify(NULL,YC_PCMPLAYER_PAUSE,0,"pause");
	}
	if (m_bIsPauseFlag == false)
	{
		m_bIsPauseFlag = true;

	}
	m_bIsNeedRender =false;
	return 0;
}


int CAYMediaPlayer::resume()
{
	if (m_bIsPauseFlag == true)
	{
		m_bIsPauseFlag =false;
	}
	m_bIsNeedRender = true;
	if (m_pMediaPlayInitParam!=NULL&&m_pMediaPlayInitParam->piCallback!=NULL)
	{
		m_pMediaPlayInitParam->piCallback->OnPlayerNotify(NULL,YC_PCMPLAYER_RESUME,0,"resume");
	}
	return 0;
}

int CAYMediaPlayer::stop()
{
	if (m_pMediaPlayInitParam!=NULL&&m_pMediaPlayInitParam->piCallback!=NULL)
	{
		m_pMediaPlayInitParam->piCallback->OnPlayerNotify(NULL,YC_PCMPLAYER_STOP,0,"stop");
	}
	//audio thread stop
	m_bAudioRunningFlag = false;
	if(m_pAudioThread){
		delete m_pAudioThread;
		m_pAudioThread = NULL;

	}

	return 0;
}

int CAYMediaPlayer::seekTo(unsigned int *uPosition)
{
	m_iSeekPostion = *uPosition;
	return 0;
}


int CAYMediaPlayer::setParam(unsigned int uParamId, void * pParam)
{
	int iRet = 0;
	switch(uParamId){
	case PID_JAVA_VM:
		m_pJVM =pParam;
		if (m_pAudioRender)
		{
#ifdef _LINUX_ANDROID
			ulu_CAutoLock lock(&m_lookAudio);
			m_pAudioRender->SetNativeWindow(m_pJVM);
#endif
			m_pAudioRender->SetNativeWindow(m_pJVM);

		}
		break;
	case PID_RECORD_FILE_PATH:
		{
			char*path=(char*)pParam;
			if (m_pAudioMix)
			{
				m_pAudioMix->setFilePath(PID_RECORD_FILE_PATH,path);
			}
		}
		break;

	case PID_BACKGROUD_FILE_PATH:
		{
			char*path=(char*)pParam;
			if (m_pAudioMix)
			{
				m_pAudioMix->setFilePath(PID_BACKGROUD_FILE_PATH,path);
			}

		}
		break;

	case PID_AUDIO_RECORD_VOLUME:
		{
//			ulu_CAutoLock lock(&m_lookAudio);
			m_iRecordAudioVolume = *(int*)pParam;
			if (m_pAudioMix)
			{
				m_pAudioMix->setAudioVolume(PID_AUDIO_RECORD_VOLUME,m_iRecordAudioVolume);
			}
			if (m_pAudioRender)
			{
				//m_pAudioRender->SetVolume(m_iRecordAudioVolume);
			}
		}
		break;
	case PID_AUDIO_BACKGROUD_VOLUME:
		{
//			ulu_CAutoLock lock(&m_lookAudio);
			m_iBackGroudAudioVolume = *(int*)pParam;
			if (m_pAudioMix)
			{
				m_pAudioMix->setAudioVolume(PID_AUDIO_BACKGROUD_VOLUME,m_iBackGroudAudioVolume);
			}
			if (m_pAudioRender)
			{
				//m_pAudioRender->SetVolume(m_iBackGroudAudioVolume);
			}
		}
		break;
	case PID_RECORDER_AUDIO_FORMAT:
		{
			AYMediaAudioFormat *pAudioFormat = (AYMediaAudioFormat*)pParam;
			if (m_pAudioMix)
			{
				m_pAudioMix->setAudioFormat(PID_RECORDER_AUDIO_FORMAT,*pAudioFormat);
			}
			break;
		}


	case PID_BACKGROUD_AUDIO_FORMAT:
		{
			AYMediaAudioFormat *pAudioFormat = (AYMediaAudioFormat*)pParam;
			if (m_pAudioMix)
			{
				m_pAudioMix->setAudioFormat(PID_BACKGROUD_AUDIO_FORMAT,*pAudioFormat);
			}
			m_sAudioFormat.nSamplesPerSec = pAudioFormat->nSamplesPerSec;
			m_sAudioFormat.nChannels =2;//pAudioFormat->nChannels;
			m_sAudioFormat.wBitsPerSample = pAudioFormat->wBitsPerSample;
			break;
		}

	default:
		break;
	}

	return 0;
}

int CAYMediaPlayer::getParam(unsigned int uParamId, void * pParam)
{
	int ret =0;
	switch (uParamId)
	{
	case PID_AUDIO_DURATION:
		if (m_pAudioMix)
		{
			ret = m_pAudioMix->getPlayerDuration((int*)pParam);
		}
		break;
	case PID_AUDIO_PLAY_POSITION:
		if (m_pAudioMix)
		{
			ret = m_pAudioMix->getCurPlayPositon((int*)pParam);
		}
		break;
	default:
		break;
	}
	return ret;
}

int CAYMediaPlayer::SetMediaPlayerInitParam(MediaPlayerInitParam *pPlayerInitParam)
{
	m_pMediaPlayInitParam =pPlayerInitParam;
	return 0;
}

//#define DUMP_FILE
#ifdef DUMP_FILE
FILE *outFile = fopen("out.pcm","wb");
FILE *stereFile = fopen("stereo.pcm","wb");
#endif
void CAYMediaPlayer::functionAudioThread()
{
	void* pSourceFunc=NULL;
	void * pUserDate=NULL;
	unsigned short*temp=NULL;
	char *mixOut =(char*)malloc(50000);
	IAYMediaPlayerCallback *pPlayerCallback=NULL;
	if (m_pAudioMix)
	{
		m_pAudioMix->resetReader();
	}
	if (m_pMediaPlayInitParam!=NULL)
	{
		pPlayerCallback = m_pMediaPlayInitParam->piCallback;
		pPlayerCallback->OnPlayerNotify(NULL,YC_PCMPLAYER_PREPARED,0,"PREPARED");
	}
	while(m_bAudioRunningFlag){
		if (m_pAudioMix&&m_iSeekPostion!=0)
		{
			m_pAudioMix->seekTo(m_iSeekPostion);
			m_iSeekPostion =0;
		}
		if (m_bIsNeedRender!=true)
		{
			ulu_OS_Sleep(10);
			continue;
		}

		if (m_pAudioRender==NULL)
		{
			int ret = createAudioRender(m_sAudioFormat);
			if (ret!=0)
			{
				ulu_OS_Sleep(10);
				continue;
			}
			pPlayerCallback->OnPlayerNotify(NULL,YC_PCMPLAYER_START,0,"start");
		}
		int size =0;
		if (m_pAudioMix)
		{
			size = m_pAudioMix->getMixSample(mixOut);
			ULULOGI("out size =%d",size);
		}
		if (size>0)
		{
			audio_render_frame((unsigned char*)mixOut,size,0);
		}else{
			break;
		}

#ifdef DUMP_FILE
		if (size>0)
		{
			fwrite(mixOut,1,size,outFile);
		}
#endif

	}
	if (mixOut!=NULL)
	{
		free(mixOut);
	}
	if (pPlayerCallback!=NULL)
	{
		pPlayerCallback->OnPlayerNotify(NULL,YC_PCMPLAYER_FINISH,0,"finish");
	}
	//saveMp3("out.mp3");
	unInitAudioContext();

}


int CAYMediaPlayer::audio_render_frame(unsigned char*pData,unsigned int ulDataSize,unsigned int ulTimestamp)
{

	ulu_CAutoLock lock(&m_lookAudio);

	int iRet = m_pAudioRender->Render(pData, ulDataSize);
	while(iRet == AUDIO_COMMIT_NEED_RETRY&&m_bAudioRunningFlag==1)
	{
		ulu_OS_Sleep(2);
		iRet = m_pAudioRender->Render(pData, ulDataSize);
	}
	return 0;
}



int CAYMediaPlayer::createAudioRender(AYMediaAudioFormat &sAudioFormat)
{
	ulu_CAutoLock lock(&m_lookAudio);
	int iRetValue = 0;
	if (m_pAudioRender !=NULL)
	{
		delete m_pAudioRender;
		m_pAudioRender =NULL;
	}
#ifdef __APPLE__
	iRetValue = CreateIOSAudioRender(m_pAudioRender);
#elif defined (_WINDOWS)
	iRetValue = CreateDXAudioRender(m_pAudioRender);
#elif defined (_LINUX_ANDROID)
	iRetValue = CreateAndroidAudioTrackRender(m_pAudioRender);
#endif // _DEBUG
	if (iRetValue == 1)
	{
#ifdef _LINUX_ANDROID
		if (m_pJVM ==NULL)
		{
			return -1;
		}
		m_pAudioRender->SetNativeWindow(m_pJVM);
#else
		if (m_pJVM ==NULL)
		{
			return -1;
		}
		m_pAudioRender->SetNativeWindow(m_pJVM);
#endif
		m_pAudioRender->SetAudioFormat(&sAudioFormat);
#ifdef _LINUX_ANDROID
		//m_nLatency = m_pAudioRender->GetLatency();
		//m_pAudioRender->Start();
		m_pAudioRender->SetVolume(100);
#elif defined(_WINDOWS)
		m_pAudioRender->SetVolume(100);
#else 

#endif
		m_pAudioRender->Start();
		iRetValue = 0;
	}

	return iRetValue;

}





