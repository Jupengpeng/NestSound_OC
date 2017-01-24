#include "AudioMix.h"
static inline int mulAdd(short in, short v, int a)
{
#if defined(__arm__) && !defined(__thumb__)
	int out;
	asm( "smlabb %[out], %[in], %[v], %[a] \n"
		: [out]"=r"(out)
		: [in]"%r"(in), [v]"r"(v), [a]"r"(a)
		: );
	return out;
#else
	return a + in * int(v);
#endif
}

static inline int mul(short in, short v)
{
#if defined(__arm__) && !defined(__thumb__)
	int out;
	asm( "smulbb %[out], %[in], %[v] \n"
		: [out]"=r"(out)
		: [in]"%r"(in), [v]"r"(v)
		: );
	return out;
#else
	return in * int(v);
#endif
}

static inline short clamp16(long sample)
{
	if ((sample>>15) ^ (sample>>31))
		sample = 0x7FFF ^ (sample>>31);
	return sample;
}

static void mixAudioWithVolume(short*pOutBuffer,short*pRecordBuffer,int recordVolume,short*pBackGroudBuffer,int accVolume,int bufferSize)
{
	short* pSrc1 = pRecordBuffer;
	short* pSrc2 = pBackGroudBuffer;
	int nProcessSample = bufferSize;


	short* pDstBuffer = (short*)pOutBuffer;
	while (nProcessSample--)
	{
		int nLeft0 = *pSrc1++;
		nLeft0 = mul(nLeft0, recordVolume);

		int nLeft1 = *pSrc2++;
		nLeft1 = mulAdd(nLeft1, accVolume, nLeft0) >> 12;

		nLeft1 = clamp16(nLeft1);

		*pDstBuffer++ = (nLeft1 & 0xFFFF);
	}

}



CAudioMix::CAudioMix()
	:m_pRecodReader(NULL)
	,m_pBackgroudReader(NULL)
	,m_recoderReadPos(0)
	,m_backGroudReadPos(0)
	,m_iRecordBytesPerSec(0)
	,m_iBackGroudBytesPerSec(0)
	,m_iRecordVolume(50)
	,m_iBackGroudVolume(50)
{

}

CAudioMix::~CAudioMix()
{

	if (m_pRecodReader)
	{
		delete m_pRecodReader;
	}
	if(m_pBackgroudReader){
		delete m_pBackgroudReader;
	}
	if (m_pRecordBuffer)
	{
		free(m_pRecordBuffer);
	}
	if (m_pBackGroudBuffer)
	{
		free(m_pBackGroudBuffer);
	}
}

int CAudioMix::setFilePath(int iAudioType,char*path)
{
	if (iAudioType == PID_RECORD_FILE_PATH)
	{
		if (m_pRecodReader==NULL)
		{
			m_pRecodReader = (ISTDataReaderItf *)new STFileReader();
			m_pRecodReader->Open(path);
		}
	}else if(iAudioType ==PID_BACKGROUD_FILE_PATH){
		if (m_pBackgroudReader==NULL)
		{
			m_pBackgroudReader = (ISTDataReaderItf *)new STFileReader();
			m_pBackgroudReader->Open(path);
		}
	}
	return 0;
}

int CAudioMix::setAudioVolume(int iAudioType,int volume){
	if (iAudioType==PID_AUDIO_RECORD_VOLUME)
	{
		m_iRecordVolume = volume;
	}else if (iAudioType==PID_AUDIO_BACKGROUD_VOLUME)
	{
		m_iBackGroudVolume =volume;
	}
	return 0;
}


int CAudioMix::setAudioFormat(int iAudioType,AYMediaAudioFormat sFormat)
{
	if (iAudioType ==PID_RECORDER_AUDIO_FORMAT)
	{
		m_sRecordAudioFormat.nSamplesPerSec = sFormat.nSamplesPerSec;
		m_sRecordAudioFormat.wBitsPerSample = sFormat.wBitsPerSample;
		m_sRecordAudioFormat.nChannels = sFormat.nChannels;

		m_iRecordBytesPerSec = m_sRecordAudioFormat.nSamplesPerSec*m_sRecordAudioFormat.nChannels;
		if (m_sRecordAudioFormat.nSamplesPerSec == 16)
		{
			m_iRecordBytesPerSec =m_iRecordBytesPerSec*2;
		}
		m_iRecordStepSize = m_iRecordBytesPerSec/25;

		m_pRecordBuffer = (unsigned char*)malloc(m_iRecordStepSize);


	}else if (iAudioType == PID_BACKGROUD_AUDIO_FORMAT){
		m_sBackGroudAudioFormat.nSamplesPerSec = sFormat.nSamplesPerSec;
		m_sBackGroudAudioFormat.wBitsPerSample = sFormat.wBitsPerSample;
		m_sBackGroudAudioFormat.nChannels = sFormat.nChannels;

		m_iBackGroudBytesPerSec = m_sBackGroudAudioFormat.nSamplesPerSec*m_sBackGroudAudioFormat.nChannels;
		if (m_sBackGroudAudioFormat.nSamplesPerSec == 16)
		{
			m_iBackGroudBytesPerSec =m_iRecordBytesPerSec*2;
		}
		m_iBackGroudStepSize = m_iBackGroudBytesPerSec/25;
		m_pBackGroudBuffer =(unsigned char*)malloc(m_iBackGroudStepSize);

	}
	return 0;

}
int CAudioMix::setStepSize(int recStepSize,int accStepSize)
{
	m_iRecordStepSize = recStepSize;
	m_pRecordBuffer = (unsigned char*)realloc(m_pRecordBuffer,m_iRecordStepSize);
	m_iBackGroudStepSize = accStepSize;
	m_pBackGroudBuffer =(unsigned char*)realloc(m_pBackGroudBuffer,m_iBackGroudStepSize);
	return 0;
}


int CAudioMix::getMixSample(char*mixOut)
{

	if (m_pRecodReader==NULL)
	{
		return -1;
	}
	int read=0;
	int recordCout=0;
	int accoCount =0;
	unsigned short*temp=NULL;
	//read from recorder
	memset(m_pRecordBuffer,0,m_iRecordStepSize);
	memset(m_pBackGroudBuffer,0,m_iBackGroudStepSize);

	if (m_pRecodReader!=NULL)
	{
		read=m_pRecodReader->Read(m_pRecordBuffer,m_recoderReadPos,m_iRecordStepSize);
		m_recoderReadPos+=read;
		if (read< 0)
		{
			return -1;
		}
		//mono to stereo
		if (m_sRecordAudioFormat.nChannels==1)
		{
			int size =read/2;
			recordCout = size*2;
			temp = (unsigned short*)malloc(recordCout*sizeof(unsigned short));
			mono2stereo((short*)temp,(short*)m_pRecordBuffer,size);
#ifdef DUMP_FILE
			//fwrite(temp,2,readCout,stereFile);
#endif
		}else{
			recordCout =read/2;
			temp =(unsigned short*)m_pRecordBuffer;
		}
	}
	// read from backgroud
	if (m_pBackgroudReader!=NULL)
	{
		read=m_pBackgroudReader->Read(m_pBackGroudBuffer,m_backGroudReadPos,m_iBackGroudStepSize);
		if (read>0)
		{
			m_backGroudReadPos+=read;
			accoCount = read/2;
		}else{

		}

	}
	//mix audio
	int mixSize =recordCout;//int mixSize =(recordCout>accoCount)?accoCount:recordCout;

	//mixAudio(mixOut,(char*)temp,(char*)m_pBackGroudBuffer,mixSize);
	mixAudioWithVolume((short*)mixOut,(short*)temp,m_iRecordVolume*100,(short*)m_pBackGroudBuffer,m_iBackGroudVolume*100,mixSize);
	mixSize = mixSize*2;
	if (temp!=NULL&&m_sRecordAudioFormat.nChannels==1)
	{
		free(temp);
	}
	return mixSize;
}


/************************************************************************/
/* MIX TWO¡¡AUDIO                                                       */
/************************************************************************/
void  CAudioMix::mixAudio(char*pOutBuffer,char*pRecordBuffer,char*pBackGroudBuffer,int bufferSize)
{
	int i,j;
	for(i = 0; i < bufferSize; i+=2)
	{
		char tmp[2] = {0};
		short int nSrcValue = 0;
		short int nDestValue = 0;
		long nMidValue = 0;


		tmp[0] = pRecordBuffer[i];
		tmp[1] = pRecordBuffer[i+1];
		nSrcValue = *(int *)tmp;
		nMidValue += (long)nSrcValue;

		tmp[0] = pBackGroudBuffer[i];
		tmp[1] = pBackGroudBuffer[i+1];
		nSrcValue = *(int *)tmp;
		nMidValue += (long)nSrcValue;

		if(nMidValue > 32767)
		{
			nDestValue = 32767;
		}
		else if(nMidValue < -32768)
		{
			nDestValue = -32768;
		}
		else
		{
			nDestValue = nMidValue;
		}
		pOutBuffer[i] = (char)(nDestValue);
		pOutBuffer[i+1] = (char)(nDestValue>>8);
	}

}


/************************************************************************/
/* MONO TO STEREO¡¡                                                     */
/************************************************************************/
int CAudioMix::mono2stereo(short*pDstBuffer,short*pSrcBuffer,int inSize){    
	if (pDstBuffer==NULL||pSrcBuffer==NULL)
	{
		return -1;
	}
	int j=0;
	for (int i = 0; i < inSize; i++)    
	{        
		pDstBuffer[j] = pSrcBuffer[i];
		pDstBuffer[j+1] = pSrcBuffer[i];
		j+=2;

	}    
	return inSize * 2;

}

/************************************************************************/
/*                reset read positon                                    */
/************************************************************************/
void CAudioMix::resetReader()
{
	m_recoderReadPos =0;
	m_backGroudReadPos =0;
}


/************************************************************************/
/* get PCM play duration                                                */
/************************************************************************/
int CAudioMix::getPlayerDuration(int *duration)
{
	int ret =0;
	int recordDuration =0;
	int accompanyDuration =0;
	if (m_pRecodReader!=NULL)
	{
		recordDuration = m_pRecodReader->Size()/(m_sRecordAudioFormat.nSamplesPerSec*m_sRecordAudioFormat.nChannels);
		if (m_sRecordAudioFormat.wBitsPerSample==16)
		{
			recordDuration = recordDuration/2;
		}
	}
	if (m_pBackgroudReader!=NULL)
	{
		accompanyDuration = m_pBackgroudReader->Size()/(m_sBackGroudAudioFormat.nSamplesPerSec*m_sBackGroudAudioFormat.nChannels);
		if (m_sBackGroudAudioFormat.wBitsPerSample==16)
		{
			accompanyDuration = accompanyDuration/2;
		}
	}
	if (recordDuration!=0&&accompanyDuration!=0)
	{
		*duration = ULUMIN(recordDuration,accompanyDuration);
	}else{
		*duration = ULUMAX(recordDuration,accompanyDuration);
	}
	return 0;
}

int CAudioMix::getCurPlayPositon(int *positon)
{
	if (m_pRecodReader!=NULL)
	{
		int totolSize = m_pRecodReader->Size();
		int duration = 0;
		getPlayerDuration(&duration);
		float curPositon =(float) m_recoderReadPos*1000*duration/totolSize;
		*positon = (int)curPositon;
		return 0;
	}
	*positon=0;
	return 0;
}

int CAudioMix::seekTo(int iPositon)
{
	float Pos = (float)iPositon*  m_iRecordBytesPerSec /1000;
	m_recoderReadPos =(int)Pos;

	Pos = (float)iPositon*m_iBackGroudBytesPerSec/1000;
	m_backGroudReadPos =(int)Pos;
	return 1;

}



