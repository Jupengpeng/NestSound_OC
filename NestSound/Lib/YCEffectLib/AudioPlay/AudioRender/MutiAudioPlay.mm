
#import "MutiAudioPlay.h"

#if 0
//#define MUTI_AUDIO_Log(fmt, ...) NSLog((@"%@ " fmt), @"##MUTI AUDIO PLAY##", ##__VA_ARGS__)
#define MUTI_AUDIO_Log(fmt, ...) printf("##MUTI AUDIO PLAY## %s\n", [[NSString stringWithFormat:fmt, ##__VA_ARGS__] UTF8String])
#else
#define MUTI_AUDIO_Log(...) {}
#endif

typedef struct _MutiAudioPlayNode
{
    AudioPlay   *audioPlay;
    NSMutableArray *audioArray;
    int   playSequence;
    int   userID;
    BOOL    isUse;
    char    VSirNum[15];
    struct _MutiAudioPlayNode *next;
}MutiAudioPlayNode;

MutiAudioPlayNode MutiAudioPlayListHead;//only for head, not data!
@implementation MutiAudioPlay


-(void)initHeadNode
{
    MutiAudioPlayListHead.audioPlay = NULL;
    MutiAudioPlayListHead.next = NULL;
    MutiAudioPlayListHead.playSequence = -2;
    MutiAudioPlayListHead.userID = 0;
    MutiAudioPlayListHead.isUse = TRUE;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        MUTI_AUDIO_Log(@"MutiAudioPlay init");
        [self   initHeadNode];
    }
    return self;
}

-(void)setAudioFormat:(AudioFormat)format{
    m_audioFormat.mSampleRate = format.mSampleRate;
    m_audioFormat.mChannelsPerFrame = format.mChannelsPerFrame;
    m_audioFormat.mBitsPerChannel = format.mBitsPerChannel;
}

-(bool)AddNode:(int)playID
{
    /**
     * insert list tail
     */
    MutiAudioPlayNode *tempNode = &MutiAudioPlayListHead;
    
    //find tail node
    while(NULL != tempNode->next)
    {
        tempNode = tempNode->next;
    }
    
    //alloc and init new node
    MutiAudioPlayNode *newNode = (MutiAudioPlayNode *)malloc(sizeof(MutiAudioPlayNode));
    newNode->playSequence = playID;
    newNode->userID = 0;
    newNode->isUse = FALSE;
    newNode->next = NULL;
    
    //insert
    tempNode->next = newNode;
    
    MUTI_AUDIO_Log(@"add + init playID = %i", playID);
    newNode->audioPlay = [[AudioPlay    alloc]  init];
    [newNode->audioPlay setAudioPlayFormat:m_audioFormat];
    newNode->audioArray = [[NSMutableArray   alloc] init];
    [newNode->audioPlay SetPlayID:playID];
    [newNode->audioPlay LoudSpeaker:FALSE];
    [newNode->audioPlay StartPlay];

    return true;
}

-(bool)DeleNode:(int)playID
{
    MutiAudioPlayNode *deleNode = &MutiAudioPlayListHead;
    MutiAudioPlayNode *priorNode = deleNode;
    deleNode = deleNode->next;
    
    //find node for delete
    while(NULL != deleNode)
    {
        if(playID == deleNode->playSequence) break;
        priorNode = deleNode;
        deleNode = deleNode->next;
    }
    
    //delete
    if(NULL != deleNode)
    {
        priorNode = deleNode->next;
        MUTI_AUDIO_Log(@"delete + release sender = %li audioplay", playID);
        [deleNode->audioPlay    StopPlay];
        [deleNode->audioPlay release];
        [deleNode->audioArray removeAllObjects];
        [deleNode->audioArray release];
        deleNode->audioArray = NULL;
        deleNode->audioPlay = NULL;
        free(deleNode);
        deleNode = NULL;
        return true;
    }
    
    return false;
}

-(void)ReleaseList
{
    MUTI_AUDIO_Log(@"mutiAudioPlay---ReleaseList");
    MutiAudioPlayNode *tempNode = &MutiAudioPlayListHead;
    MutiAudioPlayNode *releaseNode = tempNode;
    tempNode = tempNode->next;
    
    while(NULL != tempNode)
    {
        releaseNode = tempNode;
        tempNode = tempNode->next;
        [releaseNode->audioPlay StopPlay];
        MUTI_AUDIO_Log(@"mutiAudioPlay-----playID = %i stop", releaseNode->playSequence);
        [releaseNode->audioPlay release];
        [releaseNode->audioArray removeAllObjects];
        [releaseNode->audioArray release];
        releaseNode->audioPlay = NULL;
        releaseNode->audioArray = NULL;
        free(releaseNode);
        releaseNode = NULL;
    }
    
    MutiAudioPlayListHead.next = NULL;
}

-(bool)setVolume:(Float32)volume{
    MutiAudioPlayNode *tempNode = (&MutiAudioPlayListHead)->next;
    
    if (NULL == tempNode) {
        return false;
    }
    
    while(NULL != tempNode)
    {
        MUTI_AUDIO_Log(@"set play id = %d, volume = %f", tempNode->playSequence, volume);
        [tempNode->audioPlay SetVolume:volume];
        tempNode = tempNode->next;
    }
    
    return true;
}

-(void)Stop{
    [self ReleaseList];
}

-(void)dealloc
{
    MUTI_AUDIO_Log(@"mutiAudioPlay----dealloc");
    [self   ReleaseList];
    [super  dealloc];
}

@end
