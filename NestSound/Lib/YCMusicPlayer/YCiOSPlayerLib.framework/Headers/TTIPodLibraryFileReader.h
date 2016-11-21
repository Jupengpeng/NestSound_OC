/**
* File : TTIPodLibraryFileReader.h  
* Created on : 2011-8-31
* Author : hu.cao
* Copyright : Copyright (c) 2011 Shuidushi Software Ltd. All rights reserved.
* Description : CTTIPodLibraryFileReader�����ļ�
*/
#ifndef __TT_IPOD_LIBRARY_FILE_READER_H__
#define __TT_IPOD_LIBRARY_FILE_READER_H__

// INCLUDES
#include "TTBaseDataReader.h"

// CLASSES DECLEARATION
class CTTIPodLibraryFileReader : public CTTBaseDataReader
{ 
public:
    static TTBool               IsSourceValid(const TTChar* aUrl);

public:
    
    TTInt                       GetSampleRate();
    TTInt                       GetChannels();
    TTUint                      Duration();
    
    TTInt                       Seek(TTUint aTime);

	/**
	* \fn                       CTTIPodLibraryFileReader()
	* \brief                    ���캯��
	*/
	CTTIPodLibraryFileReader();

	/**
	* \fn                       ~CTTIPodLibraryFileReader()
	* \brief                    ���캯��
	*/
	virtual ~CTTIPodLibraryFileReader();

	/**
	* \fn                       TTInt Open(const TTChar* aUrl);
	* \brief                    ���ļ�
	* \param[in]	aUrl		·��
	* \return					����״̬
	*/
	virtual TTInt			   Open(const TTChar* aUrl);

	/**
	* \fn						TTInt Close()
	* \brief                    �ر��ļ�
	* \return					����״̬
	*/
	virtual  TTInt				Close();
    
    virtual void                CloseConnection(){};

	/**
	* \fn                       TTInt ReadSync(TTUint8* aReadBuffer, TTInt aReadPos, TTInt aReadSize);
	* \brief                    ��ȡ�ļ�
	* \param[in]	aReadBuffer	��Ŷ������ݵĻ�����
	* \param[in]	aReadPos	��ȡ�������ļ��е�ƫ��λ��
	* \param[in]	aReadSize	��ȡ���ֽ���
	* \return					��ȡ��ȷʱ����ʵ�ʶ�ȡ���ֽ���������Ϊ������
	*/
	virtual TTInt				 ReadSync(TTUint8* aReadBuffer, TTInt aReadPos, TTInt aReadSize);

	/**
	* \fn						TTInt Size() const;
	* \brief                    ��ѯ�ļ���С
	* \return					�ļ��ֽ���
	*/
	virtual TTInt				  Size() const;

	/**
	* \fn						void ReadAsync(TTUint8* aReadBuffer, TTInt aReadPos, TTInt aReadSize);
	* \brief                    �첽��ȡ�ļ�
	* \param[in]	aReadBuffer	��Ŷ������ݵĻ�����
	* \param[in]	aReadPos	��ȡ�������ļ��е�ƫ��λ��
	* \param[in]	aReadSize	��ȡ���ֽ���
	*/
	virtual TTInt				  ReadWait(TTUint8* aReadBuffer, TTInt aReadPos, TTInt aReadSize);

	/**
	* \fn						TTDataReaderId		Id()
	* \brief                    ��ȡDataReaderʵ����Id
	* \return					DataReaderʵ����Id
	*/
	virtual TTDataReaderId		Id();
    
    virtual TTUint16 ReadUint16(TTInt aReadPos);
    
    virtual TTUint16 ReadUint16BE(TTInt aReadPos);
    
    virtual TTUint32 ReadUint32(TTInt aReadPos);
    
    virtual TTUint32 ReadUint32BE(TTInt aReadPos);
    
    virtual TTUint64 ReadUint64(TTInt aReadPos);
    
    virtual TTUint64 ReadUint64BE(TTInt aReadPos);
    
    
    virtual void                CheckOnLineBuffering() {};
    
    
    virtual TTUint              BufferedSize() {return 0;};
    
    
    virtual TTUint              ProxySize() {return 0;};
    
    virtual TTInt               PrepareCache(TTInt aReadPos, TTInt aReadSize, TTInt aFlag) ;
    
protected:
    void                        PreSampleRefRelease();
    TTInt                       SetStartReadPos(TTUint aTime);
    
private: 
    void*                       iAsset;
    void*                       iAssetReader;
    void*                       iAssetReaderOutput;
    void*                       iCurSampleBufferRef;
    void*                       iAudioArray;
    TTInt                       iDuration;
    TTBool                      iReadStarted;
    TTInt                       iSampleRate;
    TTInt                       iChannels;
    TTInt64                     iTotalReadSize;
};
#endif
