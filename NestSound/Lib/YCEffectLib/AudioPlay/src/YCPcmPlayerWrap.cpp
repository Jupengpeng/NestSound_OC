#include "YCPcmPlayerWrap.h"


CYCPcmPlayerWrap::CYCPcmPlayerWrap(void *window,IAYMediaPlayerCallback * mCallback)
	: m_pMediaPlayer(NULL)
{
	m_pWindow = window;
	m_pMediaPlayerCallback = mCallback;
	memset(&m_MediaPlayerParams,0,sizeof(MediaPlayerInitParam));

}

CYCPcmPlayerWrap::~CYCPcmPlayerWrap()
{
	if (m_pMediaPlayer)
	{
		destroyMediaPlayerInstance(m_pMediaPlayer);
		m_pMediaPlayer=NULL;
	}
}

void CYCPcmPlayerWrap::start()
{
	if (m_pMediaPlayer!=NULL)
	{
		m_pMediaPlayer->run();
	}
}

void CYCPcmPlayerWrap::pause()
{
	if (m_pMediaPlayer!=NULL)
	{
		m_pMediaPlayer->pause();
	}

}

void CYCPcmPlayerWrap::resume()
{
	if (m_pMediaPlayer!=NULL)
	{
		m_pMediaPlayer->resume();
	}

}

void CYCPcmPlayerWrap::stop()
{
	if (m_pMediaPlayer!=NULL)
	{
		m_pMediaPlayer->stop();
	}
}

void CYCPcmPlayerWrap::seek(int positon)
{
	if (m_pMediaPlayer!=NULL)
	{
		m_pMediaPlayer->seekTo((unsigned int*)&positon);
	}
}

void CYCPcmPlayerWrap::setVolume(int volumeType,int volume)
{
	if (m_pMediaPlayer!=NULL)
	{
		if (volumeType ==0)
		{
			m_pMediaPlayer->setParam(PID_AUDIO_RECORD_VOLUME,(void*)&volume);
		}else{
			m_pMediaPlayer->setParam(PID_AUDIO_BACKGROUD_VOLUME,(void*)&volume);
		}

	}

}

void CYCPcmPlayerWrap::setDataSourece(char* recordPath,AYMediaAudioFormat recordFormat,char* accompanyPath,AYMediaAudioFormat accompanyFormat)
{
	if (m_pMediaPlayer==NULL)
	{
		m_MediaPlayerParams.piCallback = m_pMediaPlayerCallback;
		if (createMediaPlayerInstance(&m_MediaPlayerParams,&m_pMediaPlayer))
		{
			//set player window
			m_pMediaPlayer->setParam(PID_JAVA_VM,(void*)m_pWindow);

			//set record format
			m_pMediaPlayer->setParam(PID_RECORDER_AUDIO_FORMAT,(void*)&recordFormat);

			//set record path
			if (recordPath!=NULL)
			{
				m_pMediaPlayer->setParam(PID_RECORD_FILE_PATH,(void*)(char*)recordPath);
			}
			//set accompany format
			m_pMediaPlayer->setParam(PID_BACKGROUD_AUDIO_FORMAT,(void*)&accompanyFormat);
			//set accompany path
			if (accompanyPath!=NULL)
			{
				m_pMediaPlayer->setParam(PID_BACKGROUD_FILE_PATH,(void*)(char*)accompanyPath);
			}

		}
		if (m_pMediaPlayer!=NULL)
		{
			m_pMediaPlayer->run();
		}

	}
}

int CYCPcmPlayerWrap::getPlayerDuration()
{
	int duration =0;
	if (m_pMediaPlayer)
	{
		m_pMediaPlayer->getParam(PID_AUDIO_DURATION,(void*)&duration);
	}
	return duration;
}

int CYCPcmPlayerWrap::getCurPosition()
{
	int playPositon =0;
	if (m_pMediaPlayer)
	{
		m_pMediaPlayer->getParam(PID_AUDIO_PLAY_POSITION,(void*)&playPositon);
	}
	return playPositon;
}






