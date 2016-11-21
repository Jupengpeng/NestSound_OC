#ifndef __TT_HTTP_CLIENT_H__
#define __TT_HTTP_CLIENT_H__
#include "TTTypedef.h"
#include "TTMacrodef.h"
#include "TTOsalConfig.h"
#include "TTDNSCache.h"
#include <string.h>

#ifdef __TT_OS_WINDOWS__
#include <winsock2.h>
#include "Ws2tcpip.h"
#else
#include <sys/socket.h>
#include <unistd.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <netinet/tcp.h>
#endif

#define MAXDOMAINNAME 256

static const TTInt KMaxHostAddrLen = 256;
static const TTInt KMaxHostFileNameLen = 512;
static const TTInt KMaxRequestLen = 1024;
static const TTInt KMaxLineLength = 2048;

typedef struct _DNSParam{
    TTChar   domainName[MAXDOMAINNAME];
    TTUint32 ip;
    TTInt    errorcode;
    _DNSParam(){
        memset(domainName, 0, MAXDOMAINNAME);
        errorcode = -1;
        ip = 0;
    }
} DNSParam;

class ITTStreamBufferingObserver;
class CTTHttpClient;

typedef TTInt (CTTHttpClient::*_pFunConnect)(ITTStreamBufferingObserver* aObserver, const TTChar* aUrl, TTInt aOffset);


class CTTHttpClient
{
public:
	/**
	* \fn							CTTHttpClient();
	* \brief						���캯��
	*/
	CTTHttpClient();

	/**
	* \fn							~CTTHttpClient();
	* \brief						��������
	*/
	~CTTHttpClient();
	
	/**
	* \fn							TTInt Read(TTChar* aDstBuffer, TTInt aSize);
	* \brief						�ӵ�ǰλ�ö�ȡ��
	* \param[in] aDstBuffer			����������ݵ�Buffer		
	* \param[in] aSize			    ��ȡ�����ݴ�С	
	* \return						��ȡ���ֽ������ߴ�����
	*/
	TTInt							Read(TTChar* aDstBuffer, TTInt aSize);

	/**
	* \fn							TTInt Recv(TTChar* aDstBuffer, TTInt aSize);
	* \brief						�ӷ�������������
	* \param[in] aDstBuffer			���ڽ������ݵ�Buffer		
	* \param[in] aSize			    ���յ����ݴ�С	
	* \return						���յ��ֽ������ߴ�����
	*/
	TTInt							Recv(TTChar* aDstBuffer, TTInt aSize);

	/**
	* \fn							TTInt Send(TTChar* aDstBuffer, TTInt aSize);
	* \brief						���������������
	* \param[in] aSendBuffer		�������ݵ�Buffer		
	* \param[in] aSize			    ���͵����ݴ�С	
	* \return						����״̬
	*/
	TTInt							Send(const TTChar* aSendBuffer, TTInt aSize);

	/**
	* \fn							TTInt Connect(const ITTStreamBufferingObserver* aObserver, const TTChar* aUrl, TTInt aOffset = 0);
	* \brief						���ӷ�����
	* \param[in] aObserver			�ص��ӿ�
	* \param[in] aUrl				��Դ·��
	* \param[in] aOffset			��ȡƫ��
	* \return						����״̬
	*/
	TTInt							Connect(ITTStreamBufferingObserver* aObserver, const TTChar* aUrl, TTInt aOffset = 0);
    
    /**
     * \fn							TTInt ConnectProxyServer(const ITTStreamBufferingObserver* aObserver, const TTChar* aUrl, TTInt aOffset = 0);
     * \brief						���ӷ�����
     * \param[in] aObserver			�ص��ӿ�
     * \param[in] aUrl				��Դ·��
     * \param[in] aOffset			��ȡƫ��
     * \return						����״̬
     */
    TTInt							ConnectViaProxy(ITTStreamBufferingObserver* aObserver, const TTChar* aUrl, TTInt aOffset = 0);
    
	/**
	* \fn							TTInt Disconnect();
	* \brief						�Ͽ�����		
	* \return						����״̬
	*/
	TTInt							Disconnect();

	/**
	* \fn							TTInt ContentLength();
	* \brief						��ȡ��Դ�ļ���С		
	* \return						��Դ�ļ���С(byte)
	*/
	INLINE_C TTInt					ContentLength() { return iContentLength;};	

	/**
	* \fn							void Interrupt();
	* \brief						����signal��connect thread���ж����������
	*/
	void							Interrupt();

	/**
	* \fn							void ReleaseDNSCache()
	* \brief						�ͷ�DNS����
	*/
	static	void					ReleaseDNSCache();

	/**
	* \fn							TTUint32 HostIP();
	* \brief						��ȡ����������IP
	* \return						����������IP
	*/
	TTUint32						HostIP();

	/**
	* \fn							TTUint32 StatusCode();
	* \brief						��ȡ������Ӧ״̬��
	* \return						������Ӧ״̬��
	*/
	TTUint32						StatusCode();


	TTInt							HttpStatus();

	/**
	* \fn							void SetStatusCode();
	* \brief						�趨������Ӧ״̬��
	*/
	void							SetStatusCode(TTUint32 aCode);
    
    TTBool							IsCancel();

    void                            SetSocketCheckForNetException();

	TTBool							IsTtransferBlock(){return iTransferBlock;};

	TTInt							RequireContentLength();

	TTInt							ConvertToValue(TTChar * aBuffer);

	TTChar*							GetRedirectUrl();
	

private:
	TTBool				IsRedirectStatusCode(TTUint32 aStatusCode);
	TTInt				ReceiveLine(TTChar* aLine, TTInt aSize);
	TTInt				ParseHeader(TTUint32& aStatusCode);
	TTInt				GetHeaderValueByKey(const TTChar* aKey, TTChar* aBuffer, TTInt aBufferLen);

	TTInt				ConnectServer(ITTStreamBufferingObserver* aObserver, TTUint32 nHostIP, TTInt& nPortNum);
	TTInt				ResolveDNS(ITTStreamBufferingObserver* aObserver, TTChar* aHostAddr, TTUint32& aHostIP);
	TTInt				SendRequest(TTInt aPort, TTInt aOffset);
	TTInt				ParseResponseHeader(ITTStreamBufferingObserver* aObserver, TTUint32& aStatusCode);
    
	TTInt				Redirect(_pFunConnect pFunConnect, ITTStreamBufferingObserver* aObserver, TTInt aOffset);
	TTInt				SendRequestAndParseResponse(_pFunConnect pFunConnect, ITTStreamBufferingObserver* aObserver, const TTChar* aUrl, TTInt aPort, TTInt aOffset);
	
	TTInt				ParseContentLength(TTUint32 aStatusCode);

	TTInt				Receive(TTInt& aSocketHandle, timeval& aTimeOut, TTChar* aDstBuffer, TTInt aSize);
	TTInt				WaitSocketWriteBuffer(TTInt& aSocketHandle, timeval& aTimeOut);
	TTInt				WaitSocketReadBuffer(TTInt& aSocketHandle, timeval& aTimeOut);
	TTInt				SetSocketTimeOut(TTInt& aSocketHandle, timeval aTimeOut);

	void				SetSocketBlock(TTInt& aSocketHandle);
	void				SetSocketNonBlock(TTInt& aSocketHandle);

private:
	enum State {
	        DISCONNECTED,
	        CONNECTING,
	        CONNECTED
	    };

	State		iState;
	TTInt		iSocketHandle;
	TTInt		iContentLength;
	TTInt		iWSAStartup;

	TTChar		iLineBuffer[KMaxLineLength];
	TTChar		iHeaderValueBuffer[KMaxLineLength];
	pthread_t   iConnectionTid;

	TTChar		iHostAddr[KMaxHostAddrLen];
	TTChar		iHostFileName[KMaxHostFileNameLen];
	TTChar		iRequset[KMaxRequestLen];

	static CTTDNSCache* iDNSCache;
	TTUint32	iHostIP;
	TTUint32	iStatusCode;
    TTBool		iCancel;

	TTBool		iTransferBlock;
	TTChar		iRedirectUrl[KMaxLineLength];
};

#endif
