#include "AYMediaPlayer.h"
#include <string.h>

//typedef struct  {
//	char recordPath[255];
//	AYMediaAudioFormat recordFormat;
//	char accompanyPath[255];
//	AYMediaAudioFormat accompanyFormat;
//}YCDataSource;
//


class CYCPcmPlayerWrap {

public:
	CYCPcmPlayerWrap(void *window,IAYMediaPlayerCallback * mCallback);
	virtual ~CYCPcmPlayerWrap();

public:
	virtual void setDataSourece(char*  recordPath,AYMediaAudioFormat recordFormat,char* accompanyPath,AYMediaAudioFormat accompanyFormat);

	virtual void start();

	virtual void pause();

	virtual void resume();

	virtual void stop();

	virtual void seek(int positon);

	virtual void setVolume(int volumeType,int volume); //0 record volume; 1 accompany 

	virtual int getPlayerDuration();

	virtual int getCurPosition();
	
private:


	IAYMediaPlayer                      *m_pMediaPlayer;

	IAYMediaPlayerCallback              *m_pMediaPlayerCallback;

	MediaPlayerInitParam				m_MediaPlayerParams;

	void								*m_pWindow;

};

