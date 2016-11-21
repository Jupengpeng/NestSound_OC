/* Copyright (c) 2004, Nokia. All rights reserved */


#ifndef __TT_MEDIA_PAESER_H__
#define __TT_MEDIA_PAESER_H__

// INCLUDES
#include "TTTypedef.h"
#include "TTMacrodef.h"
#include "TTSemaphore.h"
#include "TTMediaParserItf.h"
#include "TTDataReaderItf.h"
#include "TTMediadef.h"
#include "TTMediainfoDef.h"
//#include "AVCDecoderTypes.h"

static TTInt KMinSeekOverflowOffset = 1000;//1000ms 
static TTUint32 KOnlineWaitIntervalMs = 50;//unit:΢��

enum TTReadResult
{
	EReadErr	 			=  -1
	, EReadOK		 		=   0
	, EReadEof	 			=   1
	, EReadOverflow			=   2
	, EReadUnderflow	    =   3
};


#define SYNC_COMPLETED_SHIFT 1
#define SYNC_COMPLETED_MASK	 2
#define SYNC_EOF_SHIFT 0
#define SYNC_EOF_MASK 1

#define SYNC_COMPLETED(result)	(result) & SYNC_COMPLETED_MASK
#define SYNC_EOF(result)		(result) & SYNC_EOF_MASK

enum TTFrmSyncResult
{
	EFrmSyncInComplete	= -2
	, EFrmSyncReadErr		= -1
	, EFrmSyncEofInComplete	= (0<<SYNC_COMPLETED_SHIFT) | (1<<SYNC_EOF_SHIFT)
	, EFrmSyncComplete		= (1<<SYNC_COMPLETED_SHIFT) | (0<<SYNC_EOF_SHIFT)
	, EFrmSyncEofComplete	= (1<<SYNC_COMPLETED_SHIFT) | (1<<SYNC_EOF_SHIFT)
};


static const TTInt KTabSize = 10 * KILO;//��ʼ����
static const TTInt KReLINCSize = 2 * KILO;//ÿ�����ӵ�����
static const TTInt KSyncBufferSize = 8 * KILO;//ͬ����Buffer��С
static const TTInt KAsyncBufferSize = 16 * KILO;//�첽��Buffer��С
static const TTInt KMaxFirstFrmOffset = 320 * KILO; //IDv2��ĵ�һ֡���ƫ�ƣ����������ΧΪ��֧��
static const TTInt KSyncReadSize = KSyncBufferSize;


class CTTMediaParser : public ITTMediaParser
{

public: // Constructors and destructor

	/*destructor*/
	virtual							~CTTMediaParser();


public: // Functions from ITTDataParser

	/**
	* \fn							TTInt StreamCount()
	* \brief						����MTTDataSink
	* \return						����������
	*/
	virtual TTInt					StreamCount();

	/**
	* \fn							TTInt GetFrameLocation(TTMediaStreamId aStreamId, TTInt aFrmIdx, TTMediaFrameInfo& aFrameInfo)
	* \brief						��ȡһ֡����λ��
	* \param	aStreamId[in]		ý����ID
	* \param	aFrmIdx[in]			֡����
	* \param	aFrameInfo[out]		֡��Ϣ
	* \return						�ɹ�����KErrNone�����򷵻ش���ֵ��
	*/
	virtual TTInt					GetFrameLocation(TTInt aStreamId, TTInt aFrmIdx, TTMediaFrameInfo& aFrameInfo);


	/**
	* \fn							TTInt GetFrameLocation(TTInt aStreamId, TTInt& aFrmIdx, TTUint aTime);
	* \brief						����ʱ���ȡ֡����λ��
	* \param[in]	aStreamId		ý����ID
	* \param[out]	aFrmIdx			֡����
	* \param[in]	aTime			ʱ��
	* \return						�ɹ�����KErrNone�����򷵻ش���ֵ��
	*/
	virtual TTInt					GetFrameLocation(TTInt aStreamId, TTInt& aFrmIdx, TTUint64 aTime);

	/**
	* \fn							TTMediaInfo GetMediaSample();
	* \brief						���audio��video����sample��Ϣ
	* \param[in]	aUrl			�ļ�·��
	*/
	virtual TTInt			 		GetMediaSample(TTMediaType aStreamType, TTBuffer* pMediaBuffer);

	/**
	* \fn							TTInt GetFrameTimeStamp(TTInt aStreamId, TTInt aFrmIdx, TTUint64 aPlayTime)	
	* \brief						��ȡһ֡����λ��
	* \param [in]	aStreamId		ý����ID
	* \param [in]	aFrmIdx			֡����
	* \param [out]	aPlayTime		֡��ʼʱ��(����)
	* \return						�ɹ�����KErrNone�����򷵻ش���ֵ��
	*/
	virtual TTInt					GetFrameTimeStamp(TTInt aStreamId, TTInt aFrmIdx, TTUint64 aPlayTime);
		
	/**
    * \fn                           void StartFrmPosScan();
    * \brief                        ��ʼɨ��֡λ�ã�����֡������
    */
    virtual void                    StartFrmPosScan();

	/**
	* \fn                           TTBool IsCreateFrameIdxComplete();
	* \brief                        �������Ƿ����
	* \return                       ���ΪETTrue
	*/
	virtual TTBool					IsCreateFrameIdxComplete();

	/**
	* \fn							TTUint MediaDuration()
	* \brief						��ȡý��ʱ��(����)
	* \return						ý��ʱ��
	*/
	virtual TTUint					MediaDuration();

	/**
	* \fn							TTUint MediaDuration()
	* \brief						��ȡý��ʱ��(����)
	* \param[in]					��Id
	* \return						ý��ʱ��
	*/
	virtual TTUint					MediaDuration(TTInt aStreamId);

	/**
	* \fn							TTInt SelectStream()
	* \brief						ѡ��audio stream��
	* \param[in]	aStreamId		Media Stream ID,����audio����video stream
	* \return						����״̬
	*/
	virtual TTInt	     			SelectStream(TTMediaType aType, TTInt aStreamId);
	
	/**
	* \fn							void Seek(TTUint aPosMS);
	* \brief						Seek����
	* \param[in]	aPosMS			λ�ã���λ������
	* \return						��������seek��λ�ã�����Ǹ���������seek ʧ�ܡ�
	*/
	virtual TTInt64					Seek(TTUint64 aPosMS,TTInt aOption = 0);

	/**
	* \fn							TTInt SetParam()
	* \brief						���ò�����
	* \param[in]	aType			��������
	* \param[in]	aParam			����ֵ
	* \return						����״̬
	*/
	virtual TTInt	     			SetParam(TTInt aType, TTPtr aParam);

	/**
	* \fn							TTInt GetParam()
	* \brief						��ȡ����ֵ��
	* \param[in]	aType			��������
	* \param[in/out]	aParam		����ֵ
	* \return						����״̬
	*/
	virtual TTInt	     			GetParam(TTInt aType, TTPtr aParam);


private:

	/**
	* \fn							ParseFrmPos(const TUint8* aData, TTInt aParserSize);
	* \param[in]	aData			����ָ��
	* \param[in]	aParserSize     ���ݴ�С
	*/
	virtual	void					ParseFrmPos(const TTUint8* aData, TTInt aParserSize);
	
	/**
	* \fn							TTInt SeekWithinFrmPosTab(TTInt aFrmIdx, TTMediaFrameInfo& aFrameInfo)
	* \brief						��֡�������в���֡λ��
	* \param[in]	aFrmIdx		    ֡���
	* \param[out]	aFrameInfo		֡��Ϣ
	* \return						�����Ƿ�ɹ�
	*/
	virtual TTInt					SeekWithinFrmPosTab(TTInt aStreamId, TTInt aFrmIdx, TTMediaFrameInfo& aFrameInfo) = 0;

	/**
	* \fn                           TTInt SeekWithIdx(TTInt aFrmIdx, TTInt& aFrmPos, TTInt& aFrmSize)
	* \brief                        ����֡��������֡λ��
	* \param[in]    aFrmIdx         ֡���
	* \param[out]   aFrmPos         ֡λ��
	* \param[out]   aFrmSize        ֡����
	* \return                       �����Ƿ�ɹ�
	*/
	virtual TTInt                   SeekWithIdx(TTInt aStreamId, TTInt aFrmIdx, TTInt64& aFrmPos, TTInt& aFrmSize);

	/**
	* \fn                           TTInt SeekWithPos(TTInt aPos, TTInt& aFrmPos, TTInt& aFrmSize)
	* \brief                        ����λ�ò���֡λ��
	* \param[in]    aPos            ��ʼ����λ��
	* \param[out]   aFrmPos         ֡λ��
	* \param[out]   aFrmSize        ֡����
	* \return                       �����Ƿ�ɹ�
	*/
	virtual TTInt                   SeekWithPos(TTInt aStreamId, TTInt64 aPos, TTInt64& aFrmPos, TTInt& aFrmSize);


protected:
	/**
	* \fn							TTInt SeekWithoutFrmPosTab(TTInt aFrmIdx, TTMediaFrameInfo& aFrameInfo)	
	* \brief						��֡�����������֡λ��
	* \param[in] 	aFrameIdx		֡��
	* \param[out]	aFrameInfo		֡��Ϣ
	* \return						�����Ƿ�ɹ�
	*/
	virtual TTInt					SeekWithoutFrmPosTab(TTInt aStreamId, TTInt aFrmIdx, TTMediaFrameInfo& aFrameInfo);


protected:

	/**
	* \fn							CTTMediaParser.
	* \brief						C++ constructor.
	*/
	CTTMediaParser(ITTDataReader& aDataReader, ITTMediaParserObserver& aObserver);

	/**
	* \fn							ReadStreamData(const TTInt aReadPos, TTUint8*& aDataPtr, TTInt& aReadSize);
	* \brief						������
	* \param[in]	aReadPos		��ȡ���ݵ�λ�á�
	* \param[out]	aDataPtr		������ȡ���ݵ�ָ�롣
	* \param[out]	aReadSize		��ȡ���ֽ�����
	* \return						�����룬-1��ʾaReadPos������Χ��0,��ʾ�������ļ�δ������1��ʾ�ļ����ꡣ
	*/
	TTReadResult					ReadStreamData(TTInt aReadPos, TTUint8*& aDataPtr, TTInt& aReadSize);

	/**
	* \fn							ReadStreamDataAsync(TTInt aReadPos);
	* \brief						�첽������
	* \param[in]	aReadPos		��ȡ���ݵ�λ�á�
	*/
	/*void							ReadStreamDataAsync(TTInt aReadPos);*/

	/**
	* \fn							void FrmIdxTabReAlloc();
	* \brief						���������ڴ治���Ļ����·����ڴ�
	*/
	void							FrmIdxTabReAlloc();

	/**
	* \fn							void FrmIdxTabAlloc();
	* \brief						Ϊ����������ڴ�
	*/
	void							FrmIdxTabAlloc();

//	TTInt							ConvertAVCHead(TTAVCDecoderSpecificInfo* AVCDecoderSpecificInfo, TTPBYTE pInBuffer, TTUint32 nInSzie);
//	TTInt							ConvertHEVCHead(TTPBYTE pOutBuffer, TTUint32& nOutSize, TTPBYTE pInBuffer, TTUint32 nInSzie);
//	TTInt							ConvertAVCFrame(TTPBYTE pBuffer, TTUint32 nSize, TTUint32& nFrameLen, TTInt& IsKeyFrame);	

protected:
	
	ITTDataReader&					iDataReader;
	ITTMediaParserObserver&			iObserver;

	TTUint8*						iSyncReadBuffer;//ͬ��������Buffer
	TTInt							iSyncReadBufferSize;
	TTUint8*						iAsyncReadBuffer;//�첽������Buffer

	TTMediaInfo*					iParserMediaInfoRef;
	
	TTUint*							iFrmPosTab;//������ָ��
	TTInt							iFrmTabSize;//�������С

	TTBool							iFrmPosTabDone;//���������Ƿ���ɱ�־
	TTBool							iAccessBeyond;//���ʳ���������Χ
	TTInt							iFrmPosTabCurOffset;//��ǰ��Ҫ��ȡ�ļ���λ��
	TTInt							iFrmPosTabCurIndex;//��ǰ����������λ��
	
	TTInt64							iNextSeekPos;//��һ��seek��λ��
	TTInt							iPreSeekIdx;//��һ��seek������ֵ
	TTInt							iPreSeekFrameSize;//�ϴ�seek��֡��С

	RTTSemaphore					mSemaphore;

	TTInt							iNALLengthSize;
	TTUint8*						iAVCBuffer;
	TTInt							iAVCSize;

	TTInt							iStreamAudioCount;
	TTInt							iStreamVideoCount;

	TTInt64							iRawDataBegin;//ý�����ݵ���ʼλ��
	TTInt64							iRawDataEnd;//ý�����ݵĽ���λ��

	TTPBYTE							iAudioBuffer;
	TTInt32							iAudioSize;

	TTPBYTE							iVideoBuffer;
	TTInt32							iVideoSize;

	TTInt							iCurAudioReadFrmIdx;//��¼ÿ����������֡��
	TTInt							iCurVideoReadFrmIdx;//��¼ÿ����������֡��
	TTInt							iAudioStreamId;
	TTInt							iVideoStreamId;

	TTBool							iReadEof;
	TTBool							iAudioSeek;
	TTBool							iVideoSeek;
};

#endif // __MP3_PAESER_H__

// End of File
