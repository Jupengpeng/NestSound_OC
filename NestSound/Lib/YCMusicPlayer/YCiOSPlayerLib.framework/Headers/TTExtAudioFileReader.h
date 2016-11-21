/**
* File : TTExtAudioFileReader.h  
* Created on : 2011-12-6
* Author : hu.cao
* Copyright : Copyright (c) 2011 Shuidushi Software Ltd. All rights reserved.
* Description : CTTExtAudioFileReader�����ļ�
*/
#ifndef __TT_EXT_AUDIO_FILE_READER_H__
#define __TT_EXT_AUDIO_FILE_READER_H__

// INCLUDES
#include "TTBaseDataReader.h"
#import <AudioToolbox/AudioToolbox.h>

static const int KReadSizePerTime = 40 * KILO;

// CLASSES DECLEARATION
class CTTExtAudioFileReader : public CTTBaseDataReader
{ 
public:
    static TTBool               IsSourceValid(const TTChar* aUrl);

public:
    
    TTInt                       GetSampleRate();
    TTInt                       GetChannels();
    TTUint                      Duration();
    TTInt64                     TotalFrame();
    
    TTInt                       Seek(TTUint aFrameIndex);

	/**
	* \fn                       CTTExtAudioFileReader()
	* \brief                    ���캯��
	*/
	CTTExtAudioFileReader();

	/**
	* \fn                       ~CTTExtAudioFileReader()
	* \brief                    ���캯��
	*/
	virtual ~CTTExtAudioFileReader();

	/**
	* \fn                       TTInt Open(const TTChar* aUrl);
	* \brief                    ���ļ�
	* \param[in]	aUrl		·��
	* \return					����״̬
	*/
	TTInt						Open(const TTChar* aUrl);

	/**
	* \fn						TTInt Close()
	* \brief                    �ر��ļ�
	* \return					����״̬
	*/
	TTInt						Close();
    
    virtual void                CloseConnection(){};

	/**
	* \fn                       TTInt ReadSync(TTUint8* aReadBuffer, TTInt aReadPos, TTInt aReadSize);
	* \brief                    ��ȡ�ļ�
	* \param[in]	aReadBuffer	��Ŷ������ݵĻ�����
	* \param[in]	aReadPos	��ȡ�������ļ��е�ƫ��λ��
	* \param[in]	aReadSize	��ȡ���ֽ���
	* \return					��ȡ��ȷʱ����ʵ�ʶ�ȡ���ֽ���������Ϊ������
	*/
	TTInt						ReadSync(TTUint8* aReadBuffer, TTInt aReadPos, TTInt aReadSize);

	/**
	* \fn						TTInt Size() const;
	* \brief                    ��ѯ�ļ���С
	* \return					�ļ��ֽ���
	*/
	TTInt						Size() const;

	/**
	* \fn						void ReadAsync(TTUint8* aReadBuffer, TTInt aReadPos, TTInt aReadSize);
	* \brief                    �첽��ȡ�ļ�
	* \param[in]	aReadBuffer	��Ŷ������ݵĻ�����
	* \param[in]	aReadPos	��ȡ�������ļ��е�ƫ��λ��
	* \param[in]	aReadSize	��ȡ���ֽ���
	*/
	TTInt						ReadWait(TTUint8* aReadBuffer, TTInt aReadPos, TTInt aReadSize);

	/**
	* \fn						TTDataReaderId		Id()
	* \brief                    ��ȡDataReaderʵ����Id
	* \return					DataReaderʵ����Id
	*/
	virtual TTDataReaderId		Id();
    
    virtual void                CheckOnLineBuffering() {};
    
    
    virtual TTUint              BufferedSize() {return 0;};
    
    
    virtual TTUint              ProxySize() {return 0;};
    
    virtual TTUint16 ReadUint16(TTInt aReadPos);
    
    virtual TTUint16 ReadUint16BE(TTInt aReadPos);
    
    virtual TTUint32 ReadUint32(TTInt aReadPos);
    
    virtual TTUint32 ReadUint32BE(TTInt aReadPos);
    
    virtual TTUint64 ReadUint64(TTInt aReadPos);
    
    virtual TTUint64 ReadUint64BE(TTInt aReadPos);
    
    /**
     * \fn						PrepareCache()
     * \brief
     */
    virtual TTInt               PrepareCache(TTInt aReadPos, TTInt aReadSize, TTInt aFlag);


	//virtual void				RunL();
    
private:
    TTInt                       StartReading();
private: 
    ExtAudioFileRef             iCurAudioFile;
    AudioBufferList             iCurBufferList;
    TTInt                       iSampleRate;
    TTInt                       iChannels;
    TTInt                       iDuration;
    TTBool                      iReadStarted;
    TTInt64                     iTotalFrameNum;
};
#endif
