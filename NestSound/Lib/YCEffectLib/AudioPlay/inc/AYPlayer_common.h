#ifndef __AYPLAYER_COMMON_H__
#define __AYPLAYER_COMMON_H__

namespace AYPlayer{
    typedef enum{
        enm_unknown = 0,
        enm_attach_window = 1,//para1:window
        enm_start = 2,
        enm_pause = 3,
        
        enm_fast_forword = 4,
        enm_forword = 5,
        enm_fast_back = 6,
        enm_back = 7,
        enm_set_volume = 8,//para1:volume_value(int)
        enm_seek = 9,//para1:timestamp
		enm_resume = 10,//
		enm_flush_window = 11,//
#ifdef __USE_WIN_DX__
		enm_win32_render_mode = 12,	// para: 0 -- D3D texture; 1 -- D3D Surface; 2 -- DirectDraw
#endif
		enm_software_scaler = 13,	// param: 1 -- using software scaler to get better video quality and the performance will downgrade
									// currently, only D3D texture render support it

        enm_active = 21,//para1:window
        enm_disactive = 22,
        
        enm_enable_audio = 31,//para1:0-----disable,1------enable
        
        enm_get_screen_shot = 101,//para:full_file_name
        enm_start_record = 102,//para:full_file_name
        enm_stop_record = 103,
		enm_get_video_info = 104,

        enm_stop = 201,
        enm_deattach_window = 201,
    }EAY_PLAYER_CONTROL;

	typedef enum{
		enm_err_code_ok = 0,
		enm_err_code_video_driver_err = 1,//para1:window
		enm_err_code_max = 0x7fffffff,
	}EAY_PLAYER_ERR_CODE;
}

#ifdef __APPLE__

#ifndef __ANYAN_PLAYER_BUFFER_DEFINE__
#define __ANYAN_PLAYER_BUFFER_DEFINE__
#endif

#ifndef CM_MAX_ENUM_VLAUE
#define CM_MAX_ENUM_VLAUE 0x7fffffff
#endif

typedef enum
{
    E_VIDEO_COLOR_YUV_PLANAR444			= 0,		/*!< YUV planar mode:444  vertical sample is 1, horizontal is 1  */
    E_VIDEO_COLOR_YUV_PLANAR422_12		= 1,		/*!< YUV planar mode:422, vertical sample is 1, horizontal is 2  */
    E_VIDEO_COLOR_YUV_PLANAR422_21		= 2,		/*!< YUV planar mode:422  vertical sample is 2, horizontal is 1  */
    E_VIDEO_COLOR_YUV_PLANAR420			= 3,		/*!< YUV planar mode:420  vertical sample is 2, horizontal is 2  */
    E_VIDEO_COLOR_YUV_PLANAR411			= 4,		/*!< YUV planar mode:411  vertical sample is 1, horizontal is 4  */
    E_VIDEO_COLOR_YUV_PLANAR411V			= 44,		/*!< YUV planar mode:411  vertical sample is 4, horizontal is 1  */
    E_VIDEO_COLOR_GRAY_PLANARGRAY		    = 5,		/*!< gray planar mode, just Y value								 */
    E_VIDEO_COLOR_YUYV422_PACKED			= 6,		/*!< YUV packed mode:422, vertical sample is 1, horizontal is 2, data: Y0 U0 Y1 V0  */
    E_VIDEO_COLOR_YVYU422_PACKED			= 7,		/*!< YUV packed mode:422, vertical sample is 1, horizontal is 2, data: Y0 V0 Y1 U0  */
    E_VIDEO_COLOR_UYVY422_PACKED			= 8,		/*!< YUV packed mode:422, vertical sample is 1, horizontal is 2, data: U0 Y0 V0 Y1  */
    E_VIDEO_COLOR_VYUY422_PACKED			= 9,		/*!< YUV packed mode:422, vertical sample is 1, horizontal is 2, data: V0 Y0 U0 Y1  */
    E_VIDEO_COLOR_YUV444_PACKED			= 10,		/*!< YUV packed mode:444, vertical sample is 1, horizontal is 1, data: Y U V	*/
    E_VIDEO_COLOR_YUV_420_PACK			= 11, 		/*!< YUV planar mode:420  vertical sample is 2, horizontal is 2  , Y planar, UV Packed*/
    E_VIDEO_COLOR_YUV_420_PACK_2			= 35, 		/*!< YUV planar mode:420  vertical sample is 2, horizontal is 2  , Y planar, VU Packed*/
    E_VIDEO_COLOR_YVU_PLANAR420			= 12,		/*!< YUV planar mode:420  vertical sample is 2, horizontal is 2  , Y planar, V planar, U planar*/
    E_VIDEO_COLOR_YVU_PLANAR422_12		= 13,		/*!< YUV planar mode:422  vertical sample is 1, horizontal is 2  , Y planar, V planar, U planar*/
    E_VIDEO_COLOR_YUYV422_PACKED_2		= 14,		/*!< YUV packed mode:422, vertical sample is 1, horizontal is 2, data: Y1 U0 Y0 V0  */
    E_VIDEO_COLOR_YVYU422_PACKED_2		= 15,		/*!< YUV packed mode:422, vertical sample is 1, horizontal is 2, data: Y1 V0 Y0 U0  */
    E_VIDEO_COLOR_UYVY422_PACKED_2		= 16,		/*!< YUV packed mode:422, vertical sample is 1, horizontal is 2, data: U0 Y1 V0 Y0  */
    E_VIDEO_COLOR_VYUY422_PACKED_2		= 17,		/*!< YUV packed mode:422, vertical sample is 1, horizontal is 2, data: V0 Y1 U0 Y0  */
    E_VIDEO_COLOR_RGB565_PACKED			= 30,		/*!< RGB packed mode, data: B:5 G:6 R:5   						 */
    E_VIDEO_COLOR_RGB555_PACKED			= 31,		/*!< RGB packed mode, data: B:5 G:5 R:5   						 */
    E_VIDEO_COLOR_RGB888_PACKED			= 32,		/*!< RGB packed mode, data: B G R		 						 */
    E_VIDEO_COLOR_RGB32_PACKED			= 33,		/*!< RGB packed mode, data: B G R A								 */
    E_VIDEO_COLOR_RGB888_PLANAR			= 34,		/*!< RGB planar mode											 */
    E_VIDEO_COLOR_YUV_PLANAR420_NV12		= 36,		/*!< YUV planar mode:420  vertical sample is 2, horizontal is 2  */
    E_VIDEO_COLOR_ARGB32_PACKED			= 37,		/*!< ARGB packed mode, data: B G R A							 */
    E_VIDEO_COLOR_TYPE_MAX				= CM_MAX_ENUM_VLAUE
}  E_VIDEO_COLORTYPE;

typedef struct __S_VIDEO_BUFFER
{
    unsigned char* 			Buffer[3];			/*!< Buffer pointer */
    int				        Stride[3];			/*!< Buffer stride */
    E_VIDEO_COLORTYPE		ColorType;			/*!< Color Type */
    signed long long				Time;				/*!< The time of the buffer */
    void*				    UserData;  /*!< The user data for later use.*/
    int                     Reserve;
} S_VIDEO_BUFFER;

/**
 * General video format info
 */
typedef struct __S_VIDEO_FORMAT
{
    signed int	iVideoWidth;          /*!< Video Width */
    signed int	iVideoHeight;         /*!< Video Heigth */
    E_VIDEO_COLORTYPE eColorType; /*!< Color Type */
} S_VIDEO_FORMAT;

typedef enum E_AUDIO_CODINGTYPE
{
    E_AUDIO_CodingUnused = 0,  /**< Placeholder value when coding is N/A  */
    E_AUDIO_CodingPCM,         /**< Any variant of PCM coding */
    E_AUDIO_CodingAAC,         /**< Any variant of AAC encoded data, 0xA106 - ISO/MPEG-4 AAC, 0xFF - AAC */
    E_AUDIO_CodingMP3,         /**< Any variant of MP3 encoded data */
    E_AUDIO_CodingG711A,        /**< Any variant of G711A encoded data */
    E_AUDIO_CodingG711U,        /**< Any variant of G711U encoded data */
    E_AUDIO_Coding_MAX		= CM_MAX_ENUM_VLAUE
} E_AUDIO_CODINGTYPE;


/**
 * General audio sample format
 */
typedef enum E_AUDIO_SAMPLE_FORMAT_TYPE
{
    E_AUDIO_SAMPLE_FORMAT_Unused = 0,
    E_AUDIO_SAMPLE_FORMAT_U16SYS,
    E_AUDIO_SAMPLE_FORMAT_S16SYS,
    E_AUDIO_SAMPLE_FORMAT_S32SYS,
    E_AUDIO_SAMPLE_FORMAT_F32SYS,
    E_AUDIO_SAMPLE_FORMAT_MAX		= CM_MAX_ENUM_VLAUE
} E_AUDIO_SAMPLE_FORMAT_TYPE;

/**
 * General audio format info
 */
typedef struct
{
    signed int	SampleRate;  /*!< Sample rate */
    signed int	Channels;    /*!< Channel count */
    signed int	SampleBits;  /*!< Bits per sample */
    E_AUDIO_SAMPLE_FORMAT_TYPE   eAudioFormatType;   /*!< SampleFormat Type */
    signed int   iRecommendSampleCount; /*!< Recommend Sample Count for audio callback */
} S_AUDIO_FORMAT;
#endif

#endif //__AYPLAYER_COMMON_H__
