#ifndef __PUREDECODEENTITY__
#define __PUREDECODEENTITY__

// INCLUDES
#include "TTTypedef.h"
#include "TTMacrodef.h"
#include "TTCritical.h"
#include "TTMediainfoProxy.h"
#include "TTAudioPlugin.h"
#include "aflibconverter.h"
//#include "TTSrcDemux.h"
#include "TTMediadef.h"
// CLASSES DECLEARATION
class CTTPureDecodeEntity 
{
public:
	/**
	* \fn							CTTPureDecodeEntity()
	* \brief						���캯��

	*/
	CTTPureDecodeEntity();

	/**
	* \fn							~CTTPureDecodeEntity()
	* \brief						��������
	*/
	virtual ~CTTPureDecodeEntity();

public:
	 
	/**
	* \fn							void Decode(const TTChar* aUrl, TTInt size)
	* \brief					    �ⲿ���ý���ӿ�
	* \param[in] aUrl			    Դ�ļ�url	
	* \param[in] size			    ��Ҫ��ȡ��pcm����size	
	* \return						������		
	*/
	TTInt							Decode(const TTChar* aUrl, TTInt size);

	/**
	* \fn							TTInt GetPCMData();
	* \brief						��ȡ��������
	* \return						����������		
	*/
	TTUint8*						GetPCMData();

	/**
	* \fn							TTInt GetPCMDataSize();
	* \brief						��ȡ����������
	* \return						����������ֵ		
	*/
	TTInt							GetPCMDataSize();

	/**
	* \fn							void SetTimeRange(TTInt start, TTInt end, TTInt decodeStartPos)
	* \brief						���ò��ŷ�Χ
	* \param[in] start			    ��ʼֵ	
	* \param[in] end			    ����ֵ	
	* \param[in] decodeStartPos		��ʼ����λ��ֵ	
	*/
	void							SetTimeRange(TTInt start, TTInt end, TTInt decodeStartPos);

	/**
	* \fn							TTInt Volume();
	* \brief						��ȡ����
	* \return						����ֵ		
	*/
	TTInt							OpenAndParse(const TTChar* aUrl);

	/**	
	* \fn							void Flush();
	* \brief						��ջ����е�����
	*/
	TTInt							InitDecodePlugin();

	/**
	* \fn							void SeekToStartPos();
	* \brief			            seek������λ�ô�
	* \return						seek���	
	*/
	TTInt							SeekToStartPos();


	/**
	* \fn							void DecodeData();
	* \brief			            ��������
	* \return						 ������	
	*/
	TTInt							DecodeData(TTInt size);

	/**
	* \fn							void GetSamplerate();
	* \brief			            ��ȡ������
	* \return						������ֵ	
	*/
	TTInt							GetSamplerate();

	/**
	* \fn							void GetChannels();
	* \brief			            ��ȡ������
	* \return						����ֵ	
	*/
	TTInt							GetChannels();

	/**
	* \fn							void Cancel();
	* \brief			            ȡ������	
	*/
	void							Cancel();

	static CTTPureDecodeEntity*		Instance();
    
    static void                     Release();

	TTInt							updateParam(TTAudioInfo* pCurAudioInfo);

	TTInt							DecBuffer(TTPBYTE pBuffer, TTInt32 nSize);

	TTInt							updateStep();

	TTInt							doSampleBitsConv(TTBuffer* srcBuffer, TTBuffer* dstBuffer);

	void							convert64BitTo16Bit(TTBuffer* srcBuffer, TTBuffer* dstBuffer);
	void							convert8BitTo16Bit(TTBuffer* srcBuffer, TTBuffer* dstBuffer);
	void							convert24BitTo16Bit(TTBuffer* srcBuffer, TTBuffer* dstBuffer);
	void							convert32BitIntTo16Bit(TTBuffer* srcBuffer, TTBuffer* dstBuffer);
	void							convert32BitFloatTo16Bit(TTBuffer* srcBuffer, TTBuffer* dstBuffer);

	TTInt							doChannelDoMix(TTBuffer* srcBuffer, TTBuffer* dstBuffer);

	TTInt							doSampleRateConv(TTBuffer* srcBuffer, TTBuffer* dstBuffer);

protected:
	RTTSemaphore					iSemaphore;

private: 

	CTTAudioPluginManager*			iPluginManager;
	CTTMediaInfoProxy*				iMediaInfoProxy;

	TTBuffer						mSrcBuffer;
	TTBuffer*						aDstBuffer;

	TTUint							iCurSrcMediaFormat;

	TTInt							iSleepDataSize;
	TTUint32						iWaitIntervalUs;

	TTUint8*						iDecodeDataPtr;
	TTInt							iDecodeDataSize;
	TTInt							iCopyPos;
	TTBool							iCancel;
	TTInt							iDecodrStartPos;

	static CTTPureDecodeEntity*		iDecodeEntity;

	//CTTSrcDemux *mSrc ;
	TTAudioFormat	 mAudioFormat;
	TTInt			 mAudioDecSize;
	TTInt			 mAudioStepSize;
	TTInt			 mDoSampleBits;
	TTInt			 mDoDownMix;
	TTInt			 mDoSampleRateConv;
	aflibConverter*							mResampleObj;
	float			 mResmpFactor;
	TTObserver		observer;
	//TTWAVFormat		 mWAVFormat;
};

#endif