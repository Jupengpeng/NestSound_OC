#ifndef __IAYMediaPlayer_H__
#define __IAYMediaPlayer_H__

//#define AYMEDIAPLAYER_SDK_API extern "C" __declspec(dllexport)

#ifdef _WINDOWS
#ifdef AYMEDIAPLAYER_SDK_EXPORTS
#define AYMEDIAPLAYER_SDK_API extern "C" __declspec(dllexport)
#else	// AYMEDIAPLAYER_SDK_EXPORTS
#define AYMEDIAPLAYER_SDK_API extern "C" __declspec(dllimport)
#endif	// AYMEDIAPLAYER_SDK_EXPORTS
#else	// _WINDOWS
#define AYMEDIAPLAYER_SDK_API extern "C" 
#endif	// _WINDOWS



/************************************************************************/
/* YC RECORDER EFFECT                                                   */
/************************************************************************/

#define 		YC_EFFECTS_NORMAL             0x0000
#define     	YC_EFFECTS_PROFEESSION		  0x0001	
#define			YC_EFFECTS_ECHO				  0x0002
#define			YC_EFFECTS_REVERB			  0x0004
#define     	YC_EFFECTS_SINGER			  0x0003
#define			YC_EFFECTS_MAGIC			  0x0005
#define			YC_EFFECTS_KTV				  0x0007

#define			YC_EQUALIZER_NUM				 9
static char *echoArgs[4]={"0.8","0.8","200","0.18"};
static char *reverArgs[7] ={"-m","30","50","50","0","50","10"};
static char *equalizerArgs[9][3] ={{"40","1","2"},{"80","1","3"},{"160","1","2"},{"320","1","1"},{"650","1","0"},{"2500","1","0"},{"5000","1","4"},{"8000","0.2","-7"},{"12500","1","2"}};




/************************************************************************/
/* YC PCM PLAYER STATUS                                                 */
/************************************************************************/
enum AY_STATUS{
	YC_PCMPLAYER_UNKNOWN          =0,
	YC_PCMPLAYER_PREPARED         =1,
	YC_PCMPLAYER_START		      =2,
	YC_PCMPLAYER_STOP			  =3,
	YC_PCMPLAYER_FINISH			  =4,
	YC_PCMPLAYER_PAUSE			  =5,
	YC_PCMPLAYER_RESUME			  =6,
	YC_PCMPLAYER_MP3SAVEPROGRESS  =7,
	YC_PCMPLAYER_DOEFFECTDONE     =8,


};
/****************************************************************************************
IAYMediaPlayerCallback : AY Media Player Callback Interface
*****************************************************************************************/
class IAYMediaPlayerCallback
{
public:
	IAYMediaPlayerCallback() {}
	virtual ~IAYMediaPlayerCallback() {}

public:
	virtual void OnPlayerNotify(void * pUserData, AY_STATUS status_code,int value, const char * msg)=0;

};
/************************************************************************/
/* notify the app msg                                                   */
/************************************************************************/
typedef void (*OnPlayerNotify)(void * pUserData,AY_STATUS status, const char * msg);


typedef struct tagMediaPlayerInitParam 
{
	IAYMediaPlayerCallback *						piCallback;
	void *											pCallbackUserData;
	//OnPlayerNotify 								piCallback;	
	//void *										pCallbackUserData;
} MediaPlayerInitParam;

typedef struct{
	int nSamplesPerSec;
	int nChannels;
	int wBitsPerSample;
}AYMediaAudioFormat;


/************************************************************************/
/* parameter ID possible be used                                        */
/************************************************************************/
#define   PID_JAVA_VM							0X0001
#define   PID_RECORD_FILE_PATH				    0X0002
#define   PID_BACKGROUD_FILE_PATH				0X0003
#define   PID_AUDIO_RECORD_VOLUME				0X0004
#define   PID_RECORDER_AUDIO_FORMAT			    0X0005
#define   PID_BACKGROUD_AUDIO_FORMAT			0X0006
#define   PID_AUDIO_BACKGROUD_VOLUME			0X0007
#define   PID_AUDIO_DURATION					0X0008
#define   PID_AUDIO_PLAY_POSITION				0X0009
#define   PID_AUDIO_RECORDER_EFFECT				0X00010

/****************************************************************************************
IAYMediaPlayer : AY Media Player Function Interface
*****************************************************************************************/
class IAYMediaPlayer
{
public:
	IAYMediaPlayer() {}
	virtual ~IAYMediaPlayer() {}

public:
	virtual int 				run()=0;

	virtual int					pause()=0;

	virtual int					stop()=0;

	virtual int					resume()=0;

	// puPosition is the desired position, but it will change after seekTo return since I frame or other reasons
	virtual int					seekTo(unsigned int * puPosition)=0;  //parameter second

	virtual int					setParam(unsigned int uParamId, void * pParam)=0;

	virtual int					getParam(unsigned int uParamId, void * pParam)=0;

};

/****************************************************************************************
AY Media Player Factory Function 
*****************************************************************************************/
AYMEDIAPLAYER_SDK_API bool createMediaPlayerInstance(MediaPlayerInitParam * pInitParam, IAYMediaPlayer ** ppiMediaPlayer);
AYMEDIAPLAYER_SDK_API void destroyMediaPlayerInstance(IAYMediaPlayer * &piMediaPlayer);

#endif	// __IAYMediaPlayer_H__
