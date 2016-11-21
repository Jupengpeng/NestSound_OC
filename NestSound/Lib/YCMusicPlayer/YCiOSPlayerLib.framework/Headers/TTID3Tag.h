#ifndef __TTID3TAG_H__

#include "TTTypedef.h"

class ITTDataReader;


/**
* \fn                       TTInt ID3v2TagSize(ITTDataReader& aDataReader, TTInt aPos = 0);
* \brief                    ��ȡID3v2��Ϣͷ����
* \param [in] aDataReader	ITTDataReader��������
* \param [in] aPos			Tag��ʼλ�ã�Ĭ��Ϊ0
* \return                   �������ID3v2��Ϣͷ��������Ϣͷ����(����KID3V2_TAG_HEADER_BYTES)�����������ID3v2��Ϣͷ������0
*/
TTInt						ID3v2TagSize(ITTDataReader& aDataReader, TTInt aPos = 0);

/**
* \fn                       TTInt ID3v1TagSize(ITTDataReader& aDataReader);
* \brief                    ��ȡID3v1��Ϣͷ����
* \param [in] aDataReader	ITTDataReader��������
* \return                   �������ID3v1��Ϣͷ��������Ϣͷ����(KID3V1_TAG_BYTES)�����������ID3v1��Ϣͷ������0
*/
TTInt						ID3v1TagSize(ITTDataReader& aDataReader);

#endif