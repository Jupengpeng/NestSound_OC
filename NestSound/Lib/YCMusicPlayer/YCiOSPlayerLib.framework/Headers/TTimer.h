/**
* File : TTimer.h  
* Created on : 2011-3-1
* Author : hu.cao
* Copyright : Copyright (c) 2011 Shuidushi Software Ltd. All rights reserved.
* Description : CTTimer�����ļ�
*/

#ifndef __TT_TIMER_H__
#define __TT_TIMER_H__

// INCLUDES
#include "TTActive.h"

class CTTimer : public CTTActive
{
public:
	/**
	* \fn				            CTTimer(TPriority aPriority = EPriorityStandard);
	* \param[in]		aPriority	���ȼ�
	* \brief				        ���캯��
	*/
	CTTimer(TPriority aPriority = EPriorityStandard);

	/**
	* \fn				            ~CTTimer()
	* \brief				        ��������
	*/
	virtual ~CTTimer();

	/**
	* \fn							void DoCancel();
	* \brief						ȡ��AOʱ����
	*/
	virtual void					DoCancel();

	/**
	* \fn							void After(TTUint32 aDelayTimer);
	* \brief						ͬ����ʱ
	* \param[in]		aDelayTimer	ʱ��	
	*/
	void							After(TTRequestStatus& aStatus, TTUint32 aDelayTime);
	

private:
	TTUint64 iCompleteTime;

	friend class CTTActiveScheduler;
};

#endif
