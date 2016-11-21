#ifndef __TT_HTTP_MP3_PARSER_H__
#define __TT_HTTP_MP3_PARSER_H__

#include "TTMP3Parser.h"

class CTTHttpMP3Parser : public CTTMP3Parser
{
public:
	CTTHttpMP3Parser(ITTDataReader& aDataReader, ITTMediaParserObserver& aObserver);

public: // Functions from ITTDataParser

	/**
	* \fn                           void StartFrmPosScan();
	* \brief                        ��ʼɨ��֡λ�ã�����֡������
	*/
	virtual void                    StartFrmPosScan();

	/**
	* \fn							RawDataEnd();
	* \brief						��������β��λ��
	* \return						����β�����ļ��е�ƫ�ơ�
	*/
	virtual TTInt					RawDataEnd();
};

#endif