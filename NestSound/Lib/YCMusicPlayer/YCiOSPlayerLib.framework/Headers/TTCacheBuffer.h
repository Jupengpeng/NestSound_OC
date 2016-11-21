#ifndef __TT_CACHE_BUFFER_H__
#define __TT_CACHE_BUFFER_H__
#include <stdio.h>
#include <string.h>
#include "TTOsalConfig.h"
#include "TTMacrodef.h"
#include "TTTypedef.h"
#include "TTCritical.h"

#define PAGE_BUFFER_COUNT	20
#define PAGE_BUFFER_SIZE	1024*1024

typedef struct
{
	TTInt64		iPosition;
	TTInt		iTotalSize;
	TTInt		iSize;
	TTUint8*	iBuffer;
	TTInt		iFlag;
} TTBufferPage;

class CTTCacheBuffer
{
public:

	/**
	* \fn							CTTCacheBuffer();
	* \brief						���캯��
	*/
	CTTCacheBuffer();

	/**
	* \fn							~CTTCacheBuffer();
	* \brief						��������
	*/
	~CTTCacheBuffer();

	/**
	* \fn							TTInt Read(TTChar* aBuffer, TTInt aReadPos, TTInt aReadSize);
	* \brief						��ȡ�ļ�
	* \param[in]	aBuffer			��Ŷ������ݵĻ�����
	* \param[in]	aReadPos		��ȡ�������ļ��е�ƫ��λ��
	* \param[in]	aReadSize		��ȡ���ֽ���
	* \return						��ȡ��ȷʱ����ʵ�ʶ�ȡ���ֽ���������Ϊ������
	*/
	TTInt							Read(TTUint8* aBuffer, TTInt aReadPos, TTInt aReadSize);
	
	/**
	* \fn							TTInt Write(TTChar* aBuffer, TTInt aWriteSize);
	* \brief						д�ļ�
	* \param[in]	aBuffer			���ڴ��Ҫд���ļ������ݵ�Buffer
	* \param[in]	aWriteSize		�ֽ���
	* \return						����״̬
	*/
	TTInt							Write(TTUint8* aBuffer, TTInt aWritePos, TTInt aWriteSize);
	
	/**
	* \fn							TTInt TotalSize();
	* \brief						��ȡ�ļ��ܴ�С
	* \return						�ļ��ܴ�С
	*/
	INLINE_C TTInt					TotalSize(){return iTotalSize;};

	INLINE_C TTInt					TotalCount(){return iCachedCount;};

	/**
	* \fn							TTInt CachePoistion();
	* \brief						��ȡ�ѻ������ݵĴ�С
	* \return						�ѻ������ݵĴ�С
	*/
	TTInt							CachePoistion(TTInt64& aCacheBegin, TTInt64& aCacheEnd);

	/**
	* \fn							void SetTotalSize(TTInt aTotalSize);
	* \brief						�����ļ��ܴ�С
	* \param[in]  aTotalSize		�ļ��ܴ�С
	*/
	INLINE_C	void				SetTotalSize(TTInt aTotalSize){iTotalSize = aTotalSize;};
	
	/**
	* \fn							TTInt Open(const TTChar* aUrl);
	* \brief						���ļ������ڼ���Ƿ��Ѿ�����������ļ�
	* \param[in]  aUrl				·��
	* \return						������
	*/
	TTInt							Open();
	/**
	* \fn							void Close();
	* \brief						�ر��ļ�
	*/
	void							Close();

private:
	void							InitPage();
	void							UnInitPage();
		
private:
	TTInt64				iTotalSize;
	TTInt64				iCachedCount;
	RTTCritical			iCritical;

	TTInt				iIndexStart; 
	TTInt				iIndexEnd;
	TTBufferPage		iPage[PAGE_BUFFER_COUNT];
};
#endif
