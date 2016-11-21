#ifndef __TT_MEDIA_PARSER_PROXY_H__
#define __TT_MEDIA_PARSER_PROXY_H__

#include "TTTypedef.h"
#include "TTMediainfoDef.h"
#include "TTFileReader.h"
#include "TTHttpReader.h"
#include "TTMediaParser.h"
#include "TTIMediaInfo.h"

static const TTInt KMaxMediaFlagSize = 32;

class ITTDataReader;
class ITTStreamBufferingObserver;

// CLASS DECLARATION
class CTTMediaInfoProxy : public ITTMediaParserObserver, public ITTStreamBufferingObserver, public ITTMediaInfo
{
public:

	enum TTMediaFormatId
	{
		EMediaExtIdNone
		, EMediaExtIdAAC
		, EMediaExtIdALAC
		, EMediaExtIdAMR
		, EMediaExtIdAPE
		, EMediaExtIdFLAC
		, EMediaExtIdM4A
		, EMediaExtIdMIDI
		, EMediaExtIdMP3
		, EMediaExtIdOGG
		, EMediaExtIdWAV
		, EMediaExtIdWMA
		, EMediaExtIdDTS
	};

public:

	/**
	* \fn								 CTTMediaInfoProxy(TTObserver& aObserver);
	* \brief							 ���캯��
	* \param[in]   aObserver			 Observer����
	*/
	CTTMediaInfoProxy(TTObserver* aObserver);

	/**
	* \fn								 ~CTTMediaInfoProxy();
	* \brief							 ��������
	*/
	virtual ~CTTMediaInfoProxy();

public:

	/**
	* \fn								 TTInt Open(const TTChar* aUrl);
	* \brief							 ��ý���ļ�
	* \param[in]   aUrl					 �ļ�·��
	* \param[in]   aStreamBufferingObserver	 ITTStreamBufferingObserver����ָ�� 
	* \return							 ����״̬
	*/
	virtual TTInt						 Open(const TTChar* aUrl, TTInt aFlag);
	
	/**
	* \fn								 TTInt Parse();
	* \brief							 �����ļ�
	* \return							 ����״̬
	*/
	virtual TTInt						 Parse();

	/**
	* \fn								 void Close();
	* \brief							 �رս�����
	*/
	virtual void						 Close();
	
	/**
	* \fn								 TTUint MediaDuration()
	* \brief							 ��ȡý��ʱ��(����)
	* \param[in]   aMediaStreadId		 ý����Id  
	* \return							 ý��ʱ��
	*/
	virtual TTUint						 MediaDuration();

	/**
	* \fn								 TTMediaInfo GetMediaInfo();
	* \brief							 �����ļ�
	* \param[in]	aUrl				 �ļ�·��
	*/
	virtual const TTMediaInfo&	     	 GetMediaInfo();

	/**
	* \fn								 TTUint MediaSize()
	* \brief							 ��ȡý���С(�ֽ�)
	* \return							 ý���С
	*/
	virtual TTUint						 MediaSize();

	/**
	* \fn								 TTBool IsSeekAble();
	* \brief							 �Ƿ���Խ���Seek����
	* \return                            ETTTrueΪ����
	*/
	virtual TTBool						 IsSeekAble();
	/**
	* \fn								 void CreateFrameIndex();
	* \brief							 ��ʼ����֡����������û���������ļ�����Ҫ�첽����������
	* \									 ���������������ļ���ֱ�Ӷ�ȡ
	*/
	virtual void						 CreateFrameIndex();

	/**
	* \fn								 TTMediaInfo GetMediaSample();
	* \brief							 ���audio��video����sample��Ϣ
	* \param[in]	aUrl				 �ļ�·��
	*/
	virtual TTInt			 			 GetMediaSample(TTMediaType aStreamType, TTBuffer* pMediaBuffer);

	/**
	* \fn								 TInt GetFrameLocation(TTInt aStreamId, TTInt aFrmIdx, TTMediaFrameInfo& aFrameInfo)
	* \brief							 ��ȡһ֡����λ��
	* \param	aStreamId[in]			 ý����ID
	* \param	aFrmIdx[in]				 ֡����
	* \param	aFrameInfo[out]			 ֡��Ϣ
	* \return							 �ɹ�����KErrNone�����򷵻ش���ֵ��
	*/
	virtual TTInt						 GetFrameLocation(TTInt aId, TTInt aFrmIdx, TTMediaFrameInfo& aFrameInfo);								 

	/**
	* \fn								 TInt GetFrameLocation(TInt aStreamId, TInt& aFrmIdx, TTUint aTime)
	* \brief							 ����ʱ���ȡ֡����λ��
	* \param	aStreamId[in]			 ý����ID
	* \param	aFrmIdx[out]			 ֡����
	* \param	aTime[in]				 ʱ��
	* \return							 �ɹ�����KErrNone�����򷵻ش���ֵ��
	*/
	virtual TTInt						 GetFrameLocation(TTInt aStreamId, TTInt& aFrmIdx, TTUint64 aTime);		

	/**
	* \fn								 ITTDataReader::TTDataReaderId GetSrcReaderId();	
	* \brief							 ��ȡMediaInfoProxy���õ�DataReader��Id
	* \return							 DataReader��Id
	*/
	ITTDataReader::TTDataReaderId		 GetSrcReaderId();	


	/**
	* \fn								TTInt SelectStream()
	* \brief							ѡ��audio stream��
	* \param[in]	aStreamId			Media Stream ID,����audio����video stream
	* \return							����״̬
	*/
	virtual TTInt			     		SelectStream(TTMediaType aType, TTInt aStreamId);
	
	/**
	* \fn								void Seek(TTUint aPosMS);
	* \brief							Seek����
	* \param[in]	aPosMS				λ�ã���λ������
	* \return							��������seek��λ�ã�����Ǹ���������seek ʧ�ܡ�
	*/
	virtual TTInt64						Seek(TTUint64 aPosMS,TTInt aOption = 0);


	virtual void						SetNetWorkProxy(TTBool aNetWorkProxy);

	/**
	* \fn								TTInt SetParam()
	* \brief							���ò�����
	* \param[in]	aType				��������
	* \param[in]	aParam				����ֵ
	* \return							����״̬
	*/
	virtual TTInt				     	SetParam(TTInt aType, TTPtr aParam);

	/**
	* \fn								TTInt GetParam()
	* \brief							��ȡ����ֵ��
	* \param[in]	aType				��������
	* \param[in/out]	aParam			����ֵ
	* \return							����״̬
	*/
	virtual TTInt	     				GetParam(TTInt aType, TTPtr aParam);

public:
	/**
	* \fn								 void CancelReader()
	* \brief							 ȡ������reader
	*/
	 void								 CancelReader();

	/**
	* \fn								TTUint BandWidth()
	* \brief							��ȡ�������ش����С
	* \return							�����С(��λ:�ֽ�)
	*/
	TTUint								BandWidth();

	/**
	* \fn								TTUint BandPercent()
	* \brief							��ȡ�����������ݰٷֱ�
	* \return							�����С(��λ:�ֽ�)
	*/
	TTUint								BandPercent();


public:
	/**
	* \fn								 TTBool IsCreateFrameIdxComplete();
	* \brief							 �������Ƿ����
	* \return							 ���ΪETTrue
	*/
	TTBool								 IsCreateFrameIdxComplete();

	/**
	* \fn								 TTUint BufferedSize()
	* \brief							 ��ȡ�ѻ�������ݴ�С
	* \return							 �ѻ�������ݴ�С
	*/
	TTUint								 BufferedSize();


	TTUint								 ProxySize();

	void								 SetDownSpeed(TTInt aFast);

	/**
	* \fn								 TTInt BufferedPercent(TTInt& aBufferedPercent)
	* \brief							 ��ȡ�ѻ������ݵİٷֱ�
	* \param[out]	aBufferedPercent	 �ٷֱ�
	* \return							 ����״̬
	*/
	TTInt								 BufferedPercent(TTInt& aBufferedPercent);

public:
	/**
	* \fn								 TTMediaFormatId  IdentifyMedia(ITTDataReader& aDataReader, const TTChar* aUrl, const TTUint8* aHeader, TTInt aHeaderSize)
	* \brief							 �����ļ���ý���ʽ
	* \param	aDataReader[in]			 DataReader��������
	* \param	aUrl[in]				 �ļ�·��
	* \return							 ���ΪETTrue
	*/
	static TTMediaFormatId				 IdentifyMedia(ITTDataReader& aDataReader, const TTChar* aUrl);

	/**
	* \fn								 ReParse(TTInt aErrCode)
	* \brief							 ���ݴ�������Ϣ�������ļ���ʽ
	* \param    aErrCode[in]			 ������
	* \return							 �ɹ�����ΪTTKErrNone������ΪTTKErrNotSupported
	*/
	TTInt								 Parse(TTInt aErrCode);

	void								 SetObserver(TTObserver*	aObserver);

public:// from ITTStreamBufferingObserver
	/**
	* \fn								 void StreamIsBuffering();
	* \brief						     ����������������	
	*/
	virtual void						 BufferingStart(TTInt nErr, TTInt nStatus, TTUint32 aParam);

	/**
	* \fn								 void StreamBufferCompleted();
	* \brief						 	 �������ݻ������	
	*/
	virtual void						 BufferingDone();
    
	/**
	* \fn								 void DNSDone();
	* \brief							 DNS�������
	*/
	virtual void						 DNSDone();

	/**
	* \fn								 void ConnectDone();
	* \brief							 �������
	*/
	virtual void						 ConnectDone();

	/**
	* \fn								 void HttpHeaderReceived();
	* \brief							 Httpͷ���ճɹ�
	*/
	virtual void						 HttpHeaderReceived();

    /**
	* \fn								 void PrefetchStart(TTUint32 aParam);
	* \brief						 	 ���翪ʼ����
	*/
    virtual void                    	 PrefetchStart(TTUint32 aParam);

	/**
	* \fn								 void PrefetchCompleted();
	* \brief							 Ԥȡ�������
	*/
	virtual void						 PrefetchCompleted();
	
	/**
	* \fn								 void StreamBufferCompleted();
	* \brief						 	 ����ý������ȫ�����	
	*/
	virtual void						 CacheCompleted(const TTChar* pFileName);

	virtual void	    				 DownLoadException(TTInt errorCode, TTInt nParam2, void *pParam3);

protected:
	virtual void	    				 FileException(TTInt nReadSize);

private:

	/**
	* \fn								 void CreateFrameIdxComplete();
	* \brief							 ����֡�������
	*/
	void								 CreateFrameIdxComplete();

	/**
	* \fn								 ITTDataReader* SelectSrcReader(const TTChar* aUrl);
	* \brief							 ����Urlѡ��һ�����ʵ�Reader
	* \param	aUrl[in]				 ·��
	* \return							 Readerʵ��
	*/
	void								 AdaptSrcReader(const TTChar* aUrl, TTInt aFlag, TTBool aHarddecode = ETTTrue);
	TTInt								 AdaptLocalFileParser(const TTChar* aUrl);
	TTInt								 AdaptHttpFileParser(const TTChar* aUrl);

	TTBool								 IsLocalFileSource(const TTChar* aUrl);
	TTBool								 IsIPodLibrarySource(const TTChar* aUrl);
	TTBool								 IsHttpSource(const TTChar* aUrl);
    TTBool                               IsLocalExtAudioFileSource(const TTChar* aUrl);

private:
	static TTBool IsALAC(const TTUint8* aHeader);
	static TTBool IsAPE(const TTUint8* aHeader);
	static TTBool IsAMR(const TTUint8* aHeader);
	static TTBool IsFLAC(const TTUint8* aHeader);
	static TTBool IsM4A(const TTUint8* aHeader);
	static TTBool IsMIDI(const TTUint8* aHeader);
	static TTBool IsMP3(const TTUint8* aHeader);
	static TTBool IsDTS(const TTUint8* aHeader);
	static TTBool IsWAV(const TTUint8* aHeader);
	static TTBool IsWMA(const TTUint8* aHeader);

	static TTBool ShouldIdentifiedByHeader(TTMediaFormatId aMediaFormatId);
	static TTMediaFormatId IdentifyMediaByHeader(ITTDataReader& aDataReader);
	static TTMediaFormatId IdentifyMediaByExtension(const TTChar* aUrl);

private:
	TTObserver*				iObserver;

	ITTMediaParser*			iMediaParser;	
	ITTDataReader*			iDataReader;
	TTMediaInfo				iMediaInfo;

	RTTCritical				iCriEvent;
};

#endif
