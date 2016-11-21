#ifndef __TT_IMEDIA_INFO_H__
#define __TT_IMEDIA_INFO_H__

#include "TTTypedef.h"
#include "TTMediadef.h"

enum TTSourceType
{
	TTSourceNone = 0
	, TTSourcePlayList = 1
	, TTSourceTS = 2
	, TTSourceAudio = 3
	, TTSourceSubtitle = 4
};

enum TTSrcNotifyMsg
{
	ESrcNotifyUpdateDuration = 7
	, ESrcNotifyBufferingStart = 16
	, ESrcNotifyBufferingDone = 17
	, ESrcNotifyDNSDone = 18
	, ESrcNotifyConnectDone = 19
	, ESrcNotifyHttpHeaderReceived = 20
    , ESrcNotifyPrefetchStart = 21
	, ESrcNotifyPrefetchCompleted = 22
	, ESrcNotifyCacheCompleted = 23
	, ESrcNotifyException = 24
};

// CLASS DECLARATION
class ITTMediaInfo
{
public:

	/**
	* \fn								 TTInt Open(const TTChar* aUrl);
	* \brief							 ��ý���ļ�
	* \param[in]   aUrl					 �ļ�·��  
	* \param[in]   aStreamBufferingObserver	 ITTStreamBufferingObserver����ָ�� 
	* \return							 ����״̬
	*/
	virtual TTInt						  Open(const TTChar* aUrl, TTInt aFlag) = 0;
	
	/**
	* \fn								 TTInt Parse();
	* \brief							 �����ļ�
	* \return							 ����״̬
	*/
	virtual TTInt						 Parse() = 0;

	/**
	* \fn								 void Close();
	* \brief							 �رս�����
	*/
	virtual void						 Close() = 0;
	
	/**
	* \fn								 TTUint MediaDuration()
	* \brief							 ��ȡý��ʱ��(����)
	* \param[in]   aMediaStreadId		 ý����Id  
	* \return							 ý��ʱ��
	*/
	virtual TTUint						 MediaDuration() = 0;

	/**
	* \fn								 TTMediaInfo GetMediaInfo();
	* \brief							 �����ļ�
	* \param[in]	aUrl				 �ļ�·��
	*/
	virtual const TTMediaInfo&	     	 GetMediaInfo() = 0;

	/**
	* \fn								 TTUint MediaSize()
	* \brief							 ��ȡý���С(�ֽ�)
	* \return							 ý���С
	*/
	virtual TTUint						 MediaSize() = 0;

	/**
	* \fn								 TTBool IsSeekAble();
	* \brief							 �Ƿ���Խ���Seek����
	* \return                            ETTTrueΪ����
	*/
	virtual TTBool						 IsSeekAble() = 0;
	/**
	* \fn								 void CreateFrameIndex();
	* \brief							 ��ʼ����֡����������û���������ļ�����Ҫ�첽����������
	* \									 ���������������ļ���ֱ�Ӷ�ȡ
	*/
	virtual void						 CreateFrameIndex() = 0;

	/**
	* \fn								 TTMediaInfo GetMediaSample();
	* \brief							 ���audio��video����sample��Ϣ
	* \param[in]	aUrl				 �ļ�·��
	*/
	virtual TTInt			 			 GetMediaSample(TTMediaType aStreamType, TTBuffer* pMediaBuffer) = 0;

	/**
	* \fn								 TTInt SelectStream()
	* \brief							 ѡ��audio stream��
	* \param[in]	aStreamId			 Media Stream ID,����audio����video stream
	* \return							 ����״̬
	*/
	virtual TTInt			     		 SelectStream(TTMediaType aType, TTInt aStreamId) = 0;
	
	/**
	* \fn								 void Seek(TTUint aPosMS);
	* \brief							 Seek����
	* \param[in]	aPosMS				 λ�ã���λ������
	* \return							 ��������seek��λ�ã�����Ǹ���������seek ʧ�ܡ�
	*/
	virtual TTInt64						 Seek(TTUint64 aPosMS,TTInt aOption = 0) = 0;


	virtual void						 SetNetWorkProxy(TTBool aNetWorkProxy) = 0;

	/**
	* \fn								 TTInt SetParam()
	* \brief							 ���ò�����
	* \param[in]	aType				 ��������
	* \param[in]	aParam				 ����ֵ
	* \return							 ����״̬
	*/
	virtual TTInt				     	 SetParam(TTInt aType, TTPtr aParam) = 0;

	/**
	* \fn								 TTInt GetParam()
	* \brief							 ��ȡ����ֵ��
	* \param[in]	aType				 ��������
	* \param[in/out]	aParam			 ����ֵ
	* \return							 ����״̬
	*/
	virtual TTInt	     				 GetParam(TTInt aType, TTPtr aParam) = 0;

	/**
	* \fn								 void CancelReader()
	* \brief							 ȡ������reader
	*/
	virtual void						 CancelReader() = 0;

	/**
	* \fn								 TTUint BandWidth()
	* \brief							 ��ȡ�������ش����С
	* \return							 �����С(��λ:�ֽ�)
	*/
	virtual TTUint						 BandWidth() = 0;

	/**
	* \fn								 TTUint BandPercent()
	* \brief							 ��ȡ�����������ݰٷֱ�
	* \return							 �����С(��λ:�ֽ�)
	*/
	virtual TTUint						 BandPercent() = 0;

	/**
	* \fn								 TTBool IsCreateFrameIdxComplete();
	* \brief							 �������Ƿ����
	* \return							 ���ΪETTrue
	*/
	virtual TTBool						 IsCreateFrameIdxComplete() = 0;

	/**
	* \fn								 TTUint BufferedSize()
	* \brief							 ��ȡ�ѻ�������ݴ�С
	* \return							 �ѻ�������ݴ�С
	*/
	virtual TTUint						 BufferedSize() = 0;


	virtual TTUint						 ProxySize() = 0;

	virtual void					     SetDownSpeed(TTInt aFast) = 0;

	/**
	* \fn								 TTInt BufferedPercent(TTInt& aBufferedPercent)
	* \brief							 ��ȡ�ѻ������ݵİٷֱ�
	* \param[out]	aBufferedPercent	 �ٷֱ�
	* \return							 ����״̬
	*/
	virtual TTInt						 BufferedPercent(TTInt& aBufferedPercent) = 0;

	/**
	* \fn								 ReParse(TTInt aErrCode)
	* \brief							 ���ݴ�������Ϣ�������ļ���ʽ
	* \param    aErrCode[in]			 ������
	* \return							 �ɹ�����ΪTTKErrNone������ΪTTKErrNotSupported
	*/
	virtual void						 SetObserver(TTObserver*	aObserver) = 0;
};

#endif  //__TT_HLS_INFO_PROXY_H__
