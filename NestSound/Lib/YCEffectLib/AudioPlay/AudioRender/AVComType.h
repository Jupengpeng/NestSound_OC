
//

#ifndef _AVComType_h
#define _AVComType_h
#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>



#define MAXBYTES 100000
    #define IMAGESIZE (160*120*3) // 480*360*3
//zx-320#define IMAGESIZE (320*240*3)
#define AUDIOPACKET 4096        //one audio buffer
#define RECORD_AUDIO_PACKET_SIZE 1280
#define kNumberBuffers  3 //audio buffer number 
#define kNumberReaBuffers  3
#define AUDIOFORPLAY 0.3  //change the audio play time
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

//audio format

typedef struct AudioFormat{
    Float64         mSampleRate;
    UInt32          mChannelsPerFrame;
    UInt32          mBitsPerChannel;

}AudioFormat;

struct ToAvData {
	int calldir;
	int function; // 1 为视频监控  ；2为视频电话
};

struct ANoiseControl
{
    int playNum, recordNum;
    char posit[240];
};

//通知信息定义：
//通知类型：
#define NET_NOTIFY_CONNECTED     1       //连接接通
#define NET_NOTIFY_CLOSE         2       //连接断开
#define NET_NOTIFY_ERR           3       //网络故障，错误不一定关断
#define NET_NOTIFY_MAX_PACK      4       //最大包长度
#define NET_NOTIFY_TYPE          5       //连接类型  1：TCP；0：UDP
#define NET_NOTIFY_BAND          6       //带宽属性
#define NET_NOTIFY_REALTIME      7       //实时属性
#define NET_NOTIFY_NEW_INCOME    8       //(内部使用)提示有新连接接入，当处于tcp服务端时，有此消息,附带新接入网络号
#define NET_NOTIFY_LEAVE         9       //(内部使用)tcp侦听的接入断开连接，附带断开的网络号
#define NET_NOTIFY_UDP_TRANSMIT  11      //UDP 中转

enum
{
    NEGO_STAT_INIT = 0,         // 开始协商状态
    NEGO_STAT_SUCCESS,          // 协商成功状态
    NEGO_STAT_FAILURE,          // 协商失败状态
    NOGO_STAT_ONLY_WAV          // 画只有音频画面
};

struct AQRecorderState {
    AudioStreamBasicDescription  mDataFormat; 
    AudioQueueRef                mQueue; 
    AudioQueueBufferRef          mBuffers[kNumberBuffers];
    AudioFileID                  mAudioFile;
    UInt32                       bufferByteSize;  
    SInt64                       mCurrentPacket;              
    bool                         mIsRunning;                 
};

struct AQPlayerState {
    AudioStreamBasicDescription   mDataFormat;   
    AudioQueueRef                 mQueue;   
    AudioQueueBufferRef           mBuffers[kNumberReaBuffers];  
    AudioFileID                   mAudioFile;       
    UInt32                        bufferByteSize;    
    SInt64                        mCurrentPacket;     
    UInt32                        mNumPacketsToRead;       
    AudioStreamPacketDescription  *mPacketDescs;       
    bool                          mIsRunning;
};

//协商参数结构
struct BasicOption  
{
    int OptionSize; //结构总大小 
    int Terminater; //终端标志(pc,pda,smartphone....) "定义"1: PC, 2: PDA
    int BandWith;   //预计网络带宽              "定义"20, 55, 110, 220, 440, 1000, 2000
};

//视频大小采集集合
struct VSize
{
    int CapWidth;   //视频宽度
    int CapHeight;  //视频高度
    int VFrameRate; //视频帧数
};

struct CS
{
	int  CSCode;  //色彩空间代号        "定义"1: YV12, 2: RGB32, 3: RGB24, 4: RGB555, 5: RGB565
};

struct VC
{
    int  VCCode;   //视频编解码器代号   "定义"10: vcd.dll, 20: vce.dll
};

struct ACO
{
    int  SampleRate;  //采样频率
    int  SizePerSample; //样本大小
    int  Track;        //声道数目
    int  AFrameRate; //音频帧数
};

struct AC
{
    int  ACCode;   //音频遍解码器代号   "定义"10: acg.dll, 20: ace.dll
};

//视频协商结果结构
struct VideoOption
{
	struct VSize        size;          //采集大小设置
	struct CS           cs;          //色彩空间设置
	struct VC           vc;          //视频编解码器设置
	int          bandrate;    //码流
};

//音频协商结果结构
struct AudioOption
{
	struct ACO          aco;         //音频采集设置
	struct AC           ac;          //音频编解码器设置
	int			 bandrate;	  //码流
};

//能力协商结果结构
struct CommunicationOption
{
    struct BasicOption  basicoption;     //基本设置
	struct VideoOption  videocaptureoption;	//视频捕获能力设置
	struct VideoOption  videoplaybackoption;	//视频回放能力设置
	struct AudioOption	 audiocaptureoption;	//音频捕获能力设置
	struct AudioOption  audioplaybackoption;	//音频回放能力设置
};

@interface AVComType : NSObject {

    int                 capImageSize;
    int                 playImageSize;
    int                 audioPacketType;
    struct CommunicationOption susAck;
    int                 av_State;
    CGRect                myView_Rect;
    char                *_appStoreLink;
    int                 _channelID;
}
@property(nonatomic)struct CommunicationOption susAck;
@property(nonatomic)int         capImageSize;
@property(nonatomic)int         playImageSize;
@property(nonatomic)int         audioPacketType;
@property(nonatomic)CGRect        myView_Rect;
@property(nonatomic)char        *appStoreLink;
@property(nonatomic)int         channelID;
+ (AVComType *)Instance;
- (void)initData;
- (int) AudioPacketSize;
- (void) GetAck: (struct CommunicationOption *)ack;
- (void) SetAck: (struct CommunicationOption **)ack;
- (void) SetState:(int) state;
- (int) GetState;
- (void)setAppLink:(NSString *)link;

@end



#endif

