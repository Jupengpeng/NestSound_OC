/**
* File : TTUrlParser.h  
* Created on : 2011-8-31
* Author : ran.zhao
* Copyright : Copyright (c) 2011 Shuidushi Software Ltd. All rights reserved.
* Description : CTTUrlParser�����ļ�
*/
#ifndef __TT_URL_PARSER__H__
#define __TT_URL_PARSER__H__

// INCLUDES
#include "TTTypedef.h"

// CLASSES DECLEARATION
class CTTUrlParser
{ 
public:

	/**
	* \fn                       void ParseProtocal(const TTChar* aUrl, TTChar* aProtocal);
	* \brief                    ����Urlǰ׺������Э������
	* \param[in]	aUrl		Url
	* \param[out]	aProtocal	Э����(û��Э����ʱ�����ؿ��ַ�)
	*/
	static void					ParseProtocal(const TTChar* aUrl, TTChar* aProtocal);

	/**
	* \fn                       void ParseExtension(const TTChar* aUrl, TTChar* aExtension);
	* \brief                    ����Url��׺����
	* \param[in]	aUrl		Url
	* \param[out]	aExtension	��׺��(û�к�׺ʱ�����ؿ��ַ�)
	*/
	static void					ParseExtension(const TTChar* aUrl, TTChar* aExtension);

	/**
	* \fn                       void ParseShortName(const TTChar* aUrl, TTChar* aShortName);
	* \brief                    ����Url·���е�short name������: ����http://www.google.com/download/1.mp3 --> ���1.mp3
	* \param[in]	aUrl		Url
	* \param[out]	aShortName	Short name.
	*/
	static void					ParseShortName(const TTChar* aUrl, TTChar* aShortName);

	/**
	* \fn                       void ParseUrl(const TTChar* aUrl, TTChar* aHost, TTChar* aPath, TTInt& aPort);
	* \brief                    ��Url�н�������������·���Ͷ˿ںš�
	* \param[in]	aUrl		Url
	* \param[out]	aHost		������
	* \param[out]	aPath		·��
	* \param[out]	aPort		�˿ں�
	*/
	static void					ParseUrl(const TTChar* aUrl, TTChar* aHost, TTChar* aPath, TTInt& aPort);

};

#endif
