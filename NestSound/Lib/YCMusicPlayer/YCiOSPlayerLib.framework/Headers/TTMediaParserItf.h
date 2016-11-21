#ifndef __TT_DATA_PARSER_H__
#define __TT_DATA_PARSER_H__

// INCLUDES
#include "TTInterface.h"
#include "TTMediadef.h"
#include "TTMediainfoDef.h"

class TTMediaFrameInfo
{
public:
	TTMediaFrameInfo()
		:iFrameLocation(0)
		,iFrameStartTime(0)
		,iFrameDuration(0)
		,iFrameSize(0)
		,iFlag(0)
		,iExtraInfo(0)
	{
		
	}

public:
	TTInt64		iFrameLocation;
	TTInt64		iFrameStartTime;
	TTInt		iFrameDuration;
	TTInt		iFrameSize;
	TTInt		iFlag;
	TTInt		iExtraInfo;
};

// FORWARD DECLARATIONS
 class ITTDataReader;
 class TTMediaInfo;

class ITTMediaParserObserver
{
public:
	virtual void CreateFrameIdxComplete() = 0;
};
// CLASS DECLARATION
class ITTMediaParser: virtual public ITTInterface
{

public: // Functions from base classes

	/**
	* \fn							TTInt Parse(TTMediaInfo& aMediaInfo);
	* \brief						����ý��Դ
	* \param[out] 	aMediaInfo		�����õ�ý����Ϣ
	* \return						�ɹ�����KErrNone�����򷵻ش���ֵ��
	*/
	virtual TTInt					Parse(TTMediaInfo& aMediaInfo) = 0;

	/**
	* \fn							TTInt StreamCount()
	* \brief						����MTTDataSink
	* \return						����������
	*/
	virtual TTInt					StreamCount() = 0;

	/**
	* \fn							TTUint MediaDuration()
	* \brief						��ȡý��ʱ��(����)
	* \return						ý��ʱ��
	*/
	virtual TTUint					MediaDuration() = 0;

	/**
	* \fn							TTUint MediaDuration()
	* \brief						��ȡý��ʱ��(����)
	* \param[in]					��Id
	* \return						ý��ʱ��
	*/
	virtual TTUint					MediaDuration(TTInt aStreamId) = 0;

	/**
	* \fn							TTInt GetFrameLocation(TTint aStreamId, TTInt aFrmIdx, TTMediaFrameInfo& aFrameInfo)
	* \brief						��ȡһ֡����λ��
	* \param	aStreamId[in]		ý����ID
	* \param	aFrmIdx[in]			֡����
	* \param	aFrameInfo[out]		֡��Ϣ
	* \return						�ɹ�����KErrNone�����򷵻ش���ֵ��
	*/
	virtual TTInt					GetFrameLocation(TTInt aStreamId, TTInt aFrmIdx, TTMediaFrameInfo& aFrameInfo) = 0;

	/**
	* \fn							TTMediaInfo GetMediaSample();
	* \brief						���audio��video����sample��Ϣ
	* \param[in]	aUrl			�ļ�·��
	*/
	virtual TTInt			 		GetMediaSample(TTMediaType aStreamType, TTBuffer* pMediaBuffer) = 0;


	/**
	* \fn							TInt GetFrameLocation(TInt aStreamId, TInt& aFrmIdx, TTUint aTime)
	* \brief						����ʱ���ȡ֡����λ��
	* \param	aStreamId[in]		ý����ID
	* \param	aFrmIdx[out]		֡����
	* \param	aTime[in]			ʱ��
	* \return						�ɹ�����KErrNone�����򷵻ش���ֵ��
	*/
	virtual TTInt					GetFrameLocation(TTInt aStreamId, TTInt& aFrmIdx, TTUint64 aTime) = 0;		

	/**
	* \fn							TTInt GetFrameTimeStamp(TTInt aStreamId, TTInt aFrmIdx, TTUint32 aPlayTime)
	* \brief						��ȡһ֡����λ��
	* \param	aStreamId[in]		ý����ID
	* \param	aFrmIdx[in]			֡����
	* \param	aPlayTime[out]		֡��ʼʱ��(����)
	* \return						�ɹ�����KErrNone�����򷵻ش���ֵ��
	*/
	virtual TTInt					GetFrameTimeStamp(TTInt aStreamId, TTInt aFrmIdx, TTUint64 aPlayTime) = 0;

	/**
	* \fn							void StartFrmPosScan();
	* \brief						��ʼɨ��֡λ�ã�����֡������
	*/
	virtual void					StartFrmPosScan() = 0;

	/**
	* \fn                           TTBool IsCreateFrameIdxComplete();
	* \brief                        �������Ƿ����
	* \return                       ���ΪETTrue
	*/
	virtual TTBool					IsCreateFrameIdxComplete() = 0;

	/**
	* \fn							TTInt SelectStream()
	* \brief						ѡ��audio stream��
	* \param[in]	aStreamId		Media Stream ID,����audio����video stream
	* \return						����״̬
	*/
	virtual TTInt	     			SelectStream(TTMediaType aType, TTInt aStreamId) = 0;
	
	/**
	* \fn							void Seek(TTUint aPosMS);
	* \brief						Seek����
	* \param[in]	aPosMS			λ�ã���λ������
	* \return						��������seek��λ�ã�����Ǹ���������seek ʧ�ܡ�
	*/
	virtual TTInt64					Seek(TTUint64 aPosMS, TTInt aOption = 0) = 0;

	/**
	* \fn							TTInt SetParam()
	* \brief						���ò�����
	* \param[in]	aType			��������
	* \param[in]	aParam			����ֵ
	* \return						����״̬
	*/
	virtual TTInt	     			SetParam(TTInt aType, TTPtr aParam) = 0;

	/**
	* \fn							TTInt GetParam()
	* \brief						��ȡ����ֵ��
	* \param[in]	aType			��������
	* \param[in/out]	aParam		����ֵ
	* \return						����״̬
	*/
	virtual TTInt	     			GetParam(TTInt aType, TTPtr aParam) = 0;
};

#endif // __DATA_PARSER_H__

// End of File
