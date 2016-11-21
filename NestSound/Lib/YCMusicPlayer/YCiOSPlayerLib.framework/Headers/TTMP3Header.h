#ifndef __TT_MP3_HEADER_H__
#define __TT_MP3_HEADER_H__

#include <string.h>
#include "TTMacrodef.h"
#include "TTTypedef.h"

#define MP3_SAMPLES_PER_FRAME       1152
#define MP3_FRAME_INFO_SYNC_FLAG    0x7ff

const TTInt KMP3MinFrameSize = 0x04;
const TTInt KMP3MaxFrameSize = 6 * KILO;


//  ENMPEGVER enumeration
enum ENMPEGVER
{
    MPEGVER_NA,     // reserved, N/A
    MPEGVER_25,     // 2.5
    MPEGVER_2,      // 2.0 (ISO/IEC 13818-3)
    MPEGVER_1       // 1.0 (ISO/IEC 11172-3)
};

//  ENCHANNELMODE enumeration
enum ENCHANNELMODE
{
    MP3CM_STEREO,
    MP3CM_JOINT_STEREO,
    MP3CM_DUAL_CHANNEL,
    MP3CM_SINGLE_CHANNEL
};

//  ENEMPHASIS enumeration
enum ENEMPHASIS
{
    MP3EM_NONE,
    MP3EM_50_15_MS,     // 50/15 ms
    MP3EM_RESERVED,
    MP3EM_CCIT_J17      // CCIT J.17
};

enum HEADERTYPE
{
    MP3CBR_HEADER  = 1,
    MP3XING_HEADER = 2,
    MP3VBRI_HEADER = 3
};

#define MP3XING_MAGIC       (TTUint32('X' << 24) | TTUint32('i' << 16) | TTUint32('n' << 8) | 'g')
#define MP3XING_TOCENTRIES  100

#define MP3INFO_MAGIC       (TTUint32('I' << 24) | TTUint32('n' << 16) | TTUint32('f' << 8) | 'o')

#define MP3VBRI_MAGIC       (TTUint32('V' << 24) | TTUint32('B' << 16) | TTUint32('R' << 8) | 'I')

enum MP3XINGFLAGS
{
    XING_FRAMES     = 0x00000001L,
    XING_BYTES      = 0x00000002L,
    XING_TOC        = 0x00000004L,
    XING_SCALE      = 0x00000008L
};

typedef struct 
{
    unsigned emphasis   : 2;        // M
    unsigned original   : 1;        // L
    unsigned copyright  : 1;        // K
    unsigned modeext    : 2;        // J
    unsigned chanmode   : 2;        // I
    unsigned privbit    : 1;        // H
    unsigned padding    : 1;        // G
    unsigned samplerate : 2;        // F
    unsigned bitrate    : 4;        // E
    unsigned hascrc     : 1;        // D
    unsigned mpeglayer  : 2;        // C
    unsigned mpegver    : 2;        // B
    unsigned framesync  : 11;       // A
}MP3_HEADER;

typedef struct 
{
    ENMPEGVER         nMPEGVersion;
    ENCHANNELMODE     nChannelMode;
    TTInt             nMPEGLayer;
    TTInt             nSamplesPerFrame;
    TTInt             nSampleRate;
    TTInt             nChannels;
    TTInt             nBitRate;
    TTInt             nFrameSize;
    ENEMPHASIS        nEmphasis;
    TTBool            bHasCRC;
    TTBool            bCopyrighted;
    TTBool            bOriginal;
}MP3_FRAME_INFO;

//  Frame header for MP3 file
class CTTMP3Header
{
public:
    /**
    * \fn                       CTTMP3Header();
    * \brief                    Constructor */
    CTTMP3Header();

    /**
    * \fn                       ~CTTMP3Header()
    * \brief                    ��������
    */
    virtual ~CTTMP3Header();

    /**
    * \fn                       HEADERTYPE Type()
    * \brief                    ���ͺ���
    * \return                   ����ͷ������
    */
    virtual HEADERTYPE          Type();

    /**
    * \fn                       TTBool Parse(const TTUint8* pbData, TTInt cbData);
    * \brief                    ����MP3����
    * \param[in]      pbData    MP3����ָ��
    * \param[in]      cbData    ���ݳ���
    * \return                   ���Ϊ��Ӧ���ͣ�����Etrue
    */
    virtual TTBool				Parse(const TTUint8* /*pbData*/, TTInt /*cbData*/);


    /**
    * \fn                       TTBool MP3SyncFrameHeader(const TTUint8 *pbData, TTInt DataSize, TTInt &SyncOffset, MP3_FRAME_INFO& mi);
    * \brief                    Ѱ��Mp3ͷ������
    * \param[in]      pbData    ����ָ��
    * \param[in]      DataSize  ���ݴ�С
    * \param[out]     SyncOffset֡����ƫ��
    * \param[out]     mi        ֡��Ϣ
    * \return                   �ҵ�����ETrue
    */
    static TTBool				MP3SyncFrameHeader(const TTUint8 *pbData, TTInt DataSize, TTInt &SyncOffset, MP3_FRAME_INFO& mi);

    /**
    * \fn                       TTBool MP3ParseFrame(MP3_HEADER mh, MP3_FRAME_INFO& mi);
    * \brief                    ����MP3֡��Ϣ
    * \param[in]      mh        �ĸ��ֽ�ͷ
    * \param[out]     mi		���ظ�����Ϣ
    * \return                   ����״̬
    */
    static TTBool				MP3ParseFrame(MP3_HEADER mh, MP3_FRAME_INFO& mi);

	/**
    * \fn                       TTBool MP3CheckHeader(const TTUint8* pbData, MP3_HEADER& mh); 
    * \brief                    ��pbData��ȡ��
	* \param[in]      pbData    ����ָ��
	* \param[out]     mh		֡��Ϣ
	* \return                   ����״̬
    */
    static TTBool				MP3CheckHeader(const TTUint8* pbData, MP3_HEADER& mh); 
};

//  XING VBR header for MP3 file
class CTTXingHeader: public CTTMP3Header
{
public:
	/**
    * \fn                       CTTXingHeader();
    * \brief                    Constructor */
    CTTXingHeader();

    /**
    * \fn                       ~CTTXingHeader()
    * \brief                    ��������
    */
    virtual ~CTTXingHeader();

    /**
    * \fn                       HEADERTYPE Type()
    * \brief                    ���ͺ���
    * \return                   ����ͷ������
    */
    virtual HEADERTYPE          Type();

    /**
    * \fn                       TTBool Parse(const TTUint8* pbData, TTInt cbData);  
    * \brief                    ����MP3����
    * \param[in]      pbData    MP3����ָ��
    * \param[in]      cbData    ���ݳ���
    * \return                   ���Ϊ��Ӧ���ͣ�����Etrue
    */
	virtual TTBool				Parse(const TTUint8* pbData, TTInt cbData);  


public:
	TTUint32   m_dwMagic;      //  "Xing"
	TTUint32   m_dwFlags;      //  valid xing flags
	TTUint32   m_dwFrames;     //  total number of frames
	TTUint32   m_dwBytes;      //  total number of bytes
	TTUint32   m_dwScale;      //  VBR scale
	TTUint8    m_arToc[MP3XING_TOCENTRIES];    //  100-point seek table
};


//  VBRI header parser for MP3 file
class CTTVbriHeader: public CTTMP3Header
{

public:
	/**
    * \fn                       CTTVbriHeader();
    * \brief                    Constructor */
    CTTVbriHeader();

    /**
    * \fn                       ~CTTVbriHeader()
    * \brief                    ��������
    */
    virtual ~CTTVbriHeader();

    /**
    * \fn                       HEADERTYPE Type()
    * \brief                    ���ͺ���
    * \return                   ����ͷ������
    */
    virtual HEADERTYPE          Type();

    /**
    * \fn                       TTBool Parse(const TTUint8* pbData, TTInt cbData);    
    * \brief                    ����MP3����
    * \param[in]      pbData    MP3����ָ��
    * \param[in]      cbData    ���ݳ���
    * \return                   ���Ϊ��Ӧ���ͣ�����Etrue
    */
	virtual TTBool				Parse(const TTUint8* pbData, TTInt cbData);            

public:
	TTUint32    m_dwMagic;
	TTUint16    m_wVersion;
	TTUint16    m_wDelay;
	TTUint16    m_wQuality;
	TTUint32    m_dwBytes;
	TTUint32    m_dwFrames;
	TTUint16    m_wTableSize;
	TTUint16    m_wTableScale;
	TTUint16    m_wEntryBytes;
	TTUint16    m_wEntryFrames;
	TTInt*      m_pnTable;
};

/**
* \fn							CTTMP3Header* MP3ParseFrameHeader(const TTUint8 *pbData, TTInt aDataSize, MP3_FRAME_INFO& aFrameInfoo)
* \brief						����MP3ͷ����
* \param[in]      pbData		MP3����ָ��
* \param[in]      aDataSize		���ݳ���
* \param[out]     aFrameInfo    ֡��Ϣ
* \return						����ͷ�Ľṹ
*/
extern CTTMP3Header*			MP3ParseFrameHeader(const TTUint8 *pbData, TTInt aDataSize, MP3_FRAME_INFO& aFrameInfo);

#endif  //  __MP3HEADER_H__
