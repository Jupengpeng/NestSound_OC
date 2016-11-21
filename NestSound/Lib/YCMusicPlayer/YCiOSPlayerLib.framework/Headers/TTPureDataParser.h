/* Copyright (c) 2004, Nokia. All rights reserved */


#ifndef __TT_IPOD_LIBRARY_PARSER_H__
#define __TT_IPOD_LIBRARY_PARSER_H__

// INCLUDES
#include "TTTypedef.h"
#include "TTMacrodef.h"
#include "TTMediaParserItf.h"
#include "TTDataReaderItf.h"
#include "TTMediaInfoDef.h"

#include "TTMediaParser.h"

class CTTIPodLibraryParser : public CTTMediaParser
{

public: // Constructors and destructor

    /**
     * \fn							CTTIPodLibraryParser.
     * \brief						C++ constructor.
     */
	CTTIPodLibraryParser(ITTDataReader& aDataReader, ITTMediaParserObserver& aObserver);
    
	/*destructor*/
	virtual							~CTTIPodLibraryParser();


public: // Functions from ITTDataParser

    /**
     * \fn							TTInt Parse(TTMediaInfo& aMediaInfo);
     * \brief						����ý��Դ
     * \param[out] 	aMediaInfo		�����õ�ý����Ϣ
     * \return						�ɹ�����KErrNone�����򷵻ش���ֵ��
     */
	virtual TTInt					Parse(TTMediaInfo& aMediaInfo);
    
	/**
     * \fn							TTInt StreamCount()
     * \brief						����MTTDataSink
     * \return						����������
     */
	virtual TTInt					StreamCount();
    
	/**
     * \fn							TTUint MediaDuration()
     * \brief						��ȡý��ʱ��(����)
     * \param[in]					��Id
     * \return						ý��ʱ��
     */
	virtual TTUint					MediaDuration();
    
    virtual TTUint					MediaDuration(TTInt aStreamId);
     
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
     * \fn							TInt GetFrameLocation(TInt aStreamId, TInt& aFrmIdx, TTUint aTime)
     * \brief						����ʱ���ȡ֡����λ��
     * \param	aStreamId[in]		ý����ID
     * \param	aFrmIdx[out]		֡����
     * \param	aTime[in]			ʱ��
     * \return						�ɹ�����KErrNone�����򷵻ش���ֵ��
     */
	virtual TTInt					GetFrameLocation(TTInt aStreamId, TTInt& aFrmIdx, TTUint64 aTime);
    
    /**
     * \fn							TTInt GetFrameTimeStamp(TTInt aStreamId, TTInt aFrmIdx, TTUint32 aPlayTime)
     * \brief						��ȡһ֡����λ��
     * \param	aStreamId[in]		ý����ID
     * \param	aFrmIdx[in]			֡����
     * \param	aPlayTime[out]		֡��ʼʱ��(����)
     * \return						�ɹ�����KErrNone�����򷵻ش���ֵ��
     */
    virtual TTInt					GetFrameTimeStamp(TTInt aStreamId, TTInt aFrmIdx, TTUint64 aPlayTime);

	/**
     * \fn							void StartFrmPosScan();
     * \brief						��ʼɨ��֡λ�ã�����֡������
     */
	virtual void					StartFrmPosScan();
    
	/**
     * \fn                           TTBool IsCreateFrameIdxComplete();
     * \brief                        �������Ƿ����
     * \return                       ���ΪETTrue
     */
	virtual TTBool					IsCreateFrameIdxComplete();
    
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
     * \fn							TTInt SeekWithinFrmPosTab(TTInt aFrmIdx, TTMediaFrameInfo& aFrameInfo)
     * \brief						��֡�������в���֡λ��
     * \param[in]	aFrmIdx		    ֡���
     * \param[out]	aFrameInfo		֡��Ϣ
     * \return						�����Ƿ�ɹ�
     */
    virtual TTInt					SeekWithinFrmPosTab(TTInt aStreamId, TTInt aFrmIdx, TTMediaFrameInfo& aFrameInfo);
};

#endif 

// End of File
