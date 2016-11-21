/*
============================================================================
 Name        : TTMP3Parser.h
 Author      : 
 Version     :
 Copyright   : Your copyright notice
 Description : CTTMP3Parser declaration
============================================================================
*/
#ifndef __TT_MP3_PARSER_H__
#define __TT_MP3_PARSER_H__


// INCLUDES
#include "TTMediaParser.h"
#include "TTMP3Header.h"


// CLASS DECLARATION
class CTTMP3Parser : public CTTMediaParser
{

public: // Constructors and destructor

    /**
    * \fn                               ~CTTMP3Parser.
    * \brief                            C++ destructor.
    */
    ~CTTMP3Parser();

	/**
	* \fn                               CTTMP3Parser.
	* \brief                            C++ constructor.
	*/
	CTTMP3Parser(ITTDataReader& aDataReader, ITTMediaParserObserver& aObserver);


public: // Functions from MTTMediaParser

	/**
	* \fn								TTInt Parse(TTMediaInfo& aMediaInfo);
	* \brief							����ý��Դ
	* \param[out] 	aMediaInfo			�����õ�ý����Ϣ
	* \return							�ɹ�����KErrNone�����򷵻ش���ֵ��
	*/
	virtual TTInt						Parse(TTMediaInfo& aMediaInfo);

    /**
    * \fn                               TTUint MediaDuration()
    * \brief                            ��ȡý��ʱ��(����)
	* \param[in]    aStreamId			��Id
    * \return                           ý��ʱ��
    */
    virtual TTUint						MediaDuration(TTInt aStreamId);

	/**
	* \fn								TTInt GetFrameLocation(TTInt aStreamId, TTInt& aFrmIdx, TTUint aTime)
	* \brief							����ʱ���ȡ֡����λ��
	* \param[in]	aStreamId			ý����ID
	* \param[out]	aFrmIdx				֡����
	* \param[in]	aTime				ʱ��
	* \return							�ɹ�����KErrNone�����򷵻ش���ֵ��
	*/
	virtual TTInt					    GetFrameLocation(TTInt aStreamId, TTInt& aFrmIdx, TTUint64 aTime);		

	/**
	* \fn								void StartFrmPosScan();
	* \brief							��ʼɨ��֡λ�ã�����֡������
	*/
	virtual void						StartFrmPosScan();


private:  // Functions from CTTMediaParser
	
	/**
	* \fn								ParseFrmPos(const TTUint8 *aData, TTInt aParserSize);
	* \param[in]	aData				����ָ��
	* \param[in]	aParserSize			���ݴ�С
	*/	
	virtual	void						ParseFrmPos(const TTUint8 *aData, TTInt aParserSize);

    /**
    * \fn                               TTInt SeekWithinFrmPosTab(TTInt aFrmIdx, TTMediaFrameInfo& aFrameInfo)
    * \brief                            ��֡�������в���֡λ��
    * \param[in]    aFrmIdx             ֡���
	* \param[out]   aFrameInfo          ֡��Ϣ
    * \return                           �����Ƿ�ɹ�
    */
    virtual TTInt                       SeekWithinFrmPosTab(TTInt aStreamId, TTInt aFrmIdx, TTMediaFrameInfo& aFrameInfo);

    /**
    * \fn                               TTInt SeekWithoutFrmPosTab(TTInt aFrmIdx, TTMediaFrameInfo& aFrameInfo); 
    * \brief                            ��֡�����������֡λ��
    * \param[in]    aFrameIdx           ֡��
    * \param[out]   aFrameInfo          ֡��Ϣ
    * \return                           �����Ƿ�ɹ�
    */
    virtual TTInt                       SeekWithoutFrmPosTab(TTInt aStreamId, TTInt aFrmIdx, TTMediaFrameInfo& aFrameInfo);

    /**
    * \fn                               TTInt SeekWithIdx(TTInt aFrmIdx, TTInt &aFrmPos, TTInt &aFrmSize)
    * \brief                            ����֡��������֡λ��
    * \param[in]    aFrmIdx             ֡���
    * \param[out]   aFrmPos             ֡λ��
    * \param[out]   aFrmSize            ֡����
    * \return                           �����Ƿ�ɹ�
    */
    TTInt                               SeekWithIdx(TTInt aStreamId, TTInt aFrmIdx, TTInt64 &aFrmPos, TTInt &aFrmSize);

    /**
    * \fn                               TTInt SeekWithPos(TTInt aPos, TTInt &aFrmPos, TTInt &aFrmSize)
    * \brief                            ����λ�ò���֡λ��
    * \param[in]    aPos                ��ʼ����λ��
    * \param[out]   aFrmPos             ֡λ��
    * \param[out]   aFrmSize            ֡����
    * \return                           �����Ƿ�ɹ�
    */
    TTInt                               SeekWithPos(TTInt aStreamId, TTInt64 aPos, TTInt64 &aFrmPos, TTInt &aFrmSize);


protected:
	
	/**
	* \fn								RawDataEnd();
	* \brief							��������β��λ��
	* \return							����β�����ļ��е�ƫ�ơ�
	*/
	virtual TTInt						RawDataEnd();


private:

    /**
    * \fn                               TTFrmSyncResult FrameSyncWithPos(TTInt aReadPos, TTInt& aOffSet, TTInt& aProcessedSize, MP3_FRAME_INFO& aFrameInfo, TBool aSyncFirstFrm)
    * \brief                            ͬ��֡ͷ
    * \param[in]    aReadPos            ��ȡ���ݵ�λ�á�
    * \param[out]   aOffSet             ֡ͷ���aReadPos��ƫ�ơ�
    * \param[out]	aProcessedSize	    ������ֽ���
    * \param[out]	aFrameInfo		    ֡��Ϣ 
	* \param[in]    aCheckNextFrameHeader��֤֡β�Ƿ�����һ֡֡ͷ
    * \return                           ����״̬
    */
    TTFrmSyncResult						FrameSyncWithPos(TTInt aReadPos, TTInt& aOffSet, TTInt& aProcessedSize, 
											   MP3_FRAME_INFO& aFrameInfo, TTBool aCheckNextFrameHeader = ETTFalse);

	/**
	* \fn								TTInt FramePosition(TTInt aFrameIdx)
	* \brief							����֡λ��
	* \param[in]	aFrameIdx			֡���
	* \return							֡λ��
	*/
	TTInt								FramePosition(TTInt aFrameIdx);

	/**
	* \fn                               void UpdateFrameInfo(TTMediaFrameInfo& aFrameInfo,  TTInt aFrameIdx);
	* \param[out]   aFrameInfo          ֡��Ϣ
	* \param[in]    aFrameIdx           ֡���
	*/
	void								UpdateFrameInfo(TTMediaFrameInfo& aFrameInfo,  TTInt aFrameIdx);

private:

    CTTMP3Header*                       iMP3Header;//MP3ͷ��Ϣ
	MP3_FRAME_INFO						iFirstFrmInfo;//��һ֡��Ϣ
	TTInt								iAVEFrameSize;//ƽ��֡��
	TTUint								iFrameTime;//֡ʱ��
 };
#endif // TTMP3PARSER_H
