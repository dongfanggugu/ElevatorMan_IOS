//
//  HBPlaySDK.h
//  HBPlaySDK
//
//  Created by wangzhen on 15-1-13.
//  Copyright (c) 2015年 wangzhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static int PLAY_FRAME_UNKNOWN = 0;

/**
 * 音频帧
 */
static int PLAY_FRAME_AUDIO = 1;

/**
 * 视频I帧
 */
static int PLAY_FRAME_VIDEO_I = 2;

/**
 * 视频P帧
 */
static int PLAY_FRAME_VIDEO_P = 3;

/**
 * 视频B帧
 */
static int PLAY_FRAME_VIDEO_B = 4;

/**
 * 视频E帧
 */
static int PLAY_FRAME_VIDEO_E = 5;

/**
 * 视频编码算法MJPEG
 */
static int PLAY_VIDEO_FORMAT_MJPEG = 0x47504a4d;


/**
 * 视频编码算法MPEG4
 */
static int PLAY_VIDEO_FORMAT_MPEG4 = 0x3447504d;

/**
 * 视频编码算法H.264
 */
static int PLAY_VIDEO_FORMAT_H264 = 0x34363248;

/**
 * 视频编码算法H.265
 */
static int PLAY_VIDEO_FORMAT_H265 = 0x35363248;

/**
 * 音频编码算法G.711 Alaw
 */
static int PLAY_AUDIO_FORMAT_G711_ALAW = 0x41313137;

/**
 * 音频编码算法G.711 Ulaw
 */
static int PLAY_AUDIO_FORMAT_G711_ULAW = 0x55313137;

/**
 * 音频编码算法G.722 Hanbang
 */
static int PLAY_AUDIO_FORMAT_G722_HANBANG = 0x48323237;

/**
 * 音频编码算法MP3
 */
static int PLAY_AUDIO_FORMAT_MP3 = 0x2033504d;

/**
 * 音频编码算法AAC
 */
static int PLAY_AUDIO_FORMAT_AAC = 0x20434141;

@class Viewport;

@interface HBPlaySDK : NSObject

// 打开流
+ (instancetype)openStream:(void *)fileHeader length:(int)len;

//关闭流
- (bool)closeStream;

////////////////////////////////////////////////////////////////////////////////
//播放使能标志位
//这些标志位不能完全独立设置。它们之间的依赖关系，参考标志位的注释。
////////////////////////////////////////////////////////////////////////////////

//使能码流分析。
//该功能始终使能，不能被禁止。
#define PLAY_ENABLE_STREAM_PARSE            0x00000000

//使能视频解码器标志。
//使能该标志才能进行视频解码。
//禁止该标志时，同时也会禁止PLAY_ENABLE_MULTITHREADING_VIDEO_CODEC、
//PLAY_ENABLE_HARDWARE_VIDEO_CODEC、PLAY_ENABLE_VIDEO_QUALITY_PRIORITY、
//PLAY_ENABLE_VERIFY_CONTINUOUS_VIDEO和PLAY_ENABLE_DISPLAY标志。
#define PLAY_ENABLE_VIDEO_CODEC             0x00000001

//使能多线程视频解码标志。
//多线程解码能够充分利用多核CPU的资源，加快解码速度。
#define PLAY_ENABLE_MULTITHREADING_VIDEO_CODEC 0x00000002

//使能硬件视频解码器标志。
//可以自动探测可用的硬件解码器，并优先使用硬件解码器。
//尚未实现。
#define PLAY_ENABLE_HARDWARE_VIDEO_CODEC    0x00000004

//使能视频图像质量优先标志。
//使能该标志时，在视频解码时会优先保证图像的质量，但可能会导致较高的CPU使用率。
//若禁止该标志，在视频解码时会优先保证视频的流畅性，尽量维持较低的CPU使用率，
//但可能会降低图像的质量。
#define PLAY_ENABLE_VIDEO_QUALITY_PRIORITY  0x00000008

//使能校验连续视频标志。
//使能该标志时，能够检查视频编码数据的连续性。当发现不连续的视频帧时，暂停解码，
//一直等到下一个关键帧再恢复解码。使能该标志，可以避免由于丢帧导致的视频图像的
//马赛克现象，但可能导致视频短暂停顿。
#define PLAY_ENABLE_VERIFY_CONTINUOUS_VIDEO 0x00000010

//使能视频显示标志。
//使能该标志才能显示视频图像。
#define PLAY_ENABLE_DISPLAY                 0x00000100

//使能音频解码器标志。
//使能该标志才能进行音频解码。
//禁止该标志，同时也会禁止PLAY_ENABLE_SOUND标志。
#define PLAY_ENABLE_AUDIO_CODEC             0x00001000

//使能音频播放标志。
//使能该标志才能进行音频播放。
//禁止该标志，同时也会禁止PLAY_ENABLE_SOUND_PRIORITY标志。
#define PLAY_ENABLE_SOUND                   0x00002000

//使能音频播放优先标志。
//一般情况下，以视频的时间来控制播放的速度。使能该标志后，优先使用音频的时间
//来控制播放的速度。
//建议采用PLAY_BUFFER_MODE_NONE作为流缓冲控制策略。
//该标志一般用于播放纯音频流。
#define PLAY_ENABLE_SOUND_PRIORITY          0x00004000

//使能直接输出标志。
//使能该标志，同时会禁止PLAY_ENABLE_DISPLAY和PLAY_ENABLE_SOUND标志，并使能
//PLAY_ENABLE_VIDEO_QUALITY_PRIORITY标志。
//可以通过CMediaPlay::GetFrame函数获取帧信息和解码后的音视频数据。
//可以通过CMediaPlay::FreeFrame函数释放帧信息和解码后的音视频数据。
//建议高级用户才使用该标志位。
//更多详细信息，参考CMediaPlay::GetFrame函数和CMediaPlay::FreeFrame函数。
#define PLAY_ENABLE_DIRECT_OUTPUT           0x10000000

//使能默认设置。
#define PLAY_ENABLE_DEFAULT         ( PLAY_ENABLE_STREAM_PARSE \
| PLAY_ENABLE_VIDEO_CODEC \
| PLAY_ENABLE_MULTITHREADING_VIDEO_CODEC \
| PLAY_ENABLE_VERIFY_CONTINUOUS_VIDEO \
| PLAY_ENABLE_DISPLAY \
| PLAY_ENABLE_AUDIO_CODEC \
| PLAY_ENABLE_SOUND )

//设置使能标志
- (bool)SetEnableFlag:(NSUInteger)flag;

//获取使能标志
- (NSUInteger)getEnableFlag;

//停止
- (bool)Stop;

//暂停
- (bool)Pause;

//播放
- (bool)Play;

#define PLAY_STATE_STOPPED          0
#define PLAY_STATE_PAUSED           1
#define PLAY_STATE_PLAYING          2
//获取播放状态
- (NSUInteger)GetPlayState;

//缓冲模式
#define PLAY_BUFFER_MODE_NONE       0               //无缓冲
#define PLAY_BUFFER_MODE_REALTIME   1               //实时性优先，用于预览和云台控制
#define PLAY_BUFFER_MODE_BALANCED   2               //均衡，用于预览
#define PLAY_BUFFER_MODE_FLUENCY    3               //流畅性优先，用于回放

//设置缓冲模式
- (bool)SetBufferMode:(NSUInteger)mode;

//获取缓冲模式
- (NSUInteger)GetBufferMode;

//获取缓冲状态
- (NSUInteger)GetBufferState;

//复位缓冲区
- (bool)ResetBuffer:(NSUInteger)nReservedCount;

//设置冲帧数的最大值
- (bool)SetMaxBufferCount:(NSUInteger)count;

//获取冲帧数的最大值
- (NSUInteger)GetMaxBufferCount;

//获取缓冲的音视频帧数
- (NSUInteger)GetBufferedFrameCount;

//获取缓冲的时长，单位：毫秒
- (NSUInteger)GetBufferedDuration;

//获取缓冲的数据大小，单位：字节
- (NSUInteger)GetBufferedLength;

//设置播放速度
- (bool)SetSpeed:(float)speed;

//获取播放速度
- (float)GetSpeed;

//获取视频图像宽度
- (NSUInteger)GetPictureWidth;

//获取视频图像高度
- (NSUInteger)GetPictureHeight;

//获取播放数据长度，单位：字节
- (uint64_t)GetPlayDataLength;

//获取播放的视频时长，单位：毫秒
- (NSUInteger)GetPlayVideoDuration;

//获取播放的视频帧时间戳，单位：毫秒
//从1970-01-01 00:00:00 UTC开始的毫秒数
- (uint64_t)GetPlayVideoTimestamp;

//获取播放的视频帧序号，从0开始
- (NSUInteger)GetPlayVideoIndex;

//获取视频帧率，单位：fps
- (float)GetVideoFrameRate;
- (bool)SetVideoFrameRate:(float)rate;

//获取音频帧率，单位：fps
- (float)GetAudioFrameRate;

//获取视频码流比特率，单位：kbps
- (float)GetVideoBitrate;

//获取音频码流比特率，单位：kbps
- (float)GetAudioBitrate;

//增加视口
- (bool)AddViewport:(Viewport *)frame;

//移除视口
- (bool)RemoveViewport:(Viewport *)frame;

//改变视口
- (bool)TransformViewport:(Viewport *)frame deltaX:(float)x delaY:(float)y deltaScaleFactor:(float)factor;

//改变图像显示的位置和比例
- (bool)TransformPicture:(Viewport *)frame x:(NSInteger)x y:(NSInteger)y width:(NSInteger)w height:(NSInteger)h;

//抓图，JPEG格式
- (UIImage *)Snapshot;

//输入流数据
- (bool)InputData:(void *)streamBuffer length:(NSUInteger)len type:(NSInteger)type timestamp:(long long)llTimestamp;


- (BOOL)openAudioEncoder:(int)algorithm channels:(int)channels bitPerSample:(int)bitSample sampleRate:(int)sampleRate;

- (BOOL)closeAudioEncoder;

- (BOOL)inputAudioRawData:(void *)data length:(int)len;

- (NSData *)getAudioEncodedData;

//缓冲状态
#define PLAY_BUFFER_STATE_BUFFERING 0               //正在缓冲中
#define PLAY_BUFFER_STATE_SUITABLE  1               //已缓冲了合适的数据
#define PLAY_BUFFER_STATE_MORE      2               //已缓冲了太多的数据

////////////////////////////////////////////////////////////////////////////////
// 函数名：PPLAY_BUFFER_STATE_ALMOST_CHANGE_CALLBACK
// 描述：缓冲状态接近于要改变回调函数。
// 参数：
//  [in]bAlmostEmpty - 状态标志。
//      TRUE表示缓冲状态接近于要从PLAY_BUFFER_STATE_ENOUGH变为PLAY_BUFFER_STATE_BUFFERING，
//      此时应该继续调用CMediaPlay::InputData函数输入更多数据，尽量维持PLAY_BUFFER_STATE_ENOUGH
//      状态不变。
//      FALSE表示缓冲状态接近于要从PLAY_BUFFER_STATE_ENOUGH变为PLAY_BUFFER_STATE_TOO_MUCH，
//      此时应该暂停调用CMediaPlay::InputData函数，尽量维持PLAY_BUFFER_STATE_ENOUGH状态不变。
//  [in]pContext - 用户上下文指针。
// 返回值：
//  无。
// 说明：
//  当前缓冲状态是PLAY_BUFFER_STATE_ENOUGH，并且缓冲状态接近于要改变时，触发该回调函数。
////////////////////////////////////////////////////////////////////////////////
typedef void (*PHBPLAY_BUFFER_STATE_ALMOST_CHANGE_CALLBACK)(BOOL bAlmostEmpty, void* pContext);


////////////////////////////////////////////////////////////////////////////////
// 函数名：PPLAY_BUFFER_STATE_CHANGED_CALLBACK
// 描述：缓冲状态改变回调函数。
// 参数：
//  [in]dwOldState - 原先的缓冲状态，使用PLAY_BUFFER_STATE_*宏。
//  [in]dwNewState - 现在的缓冲状态，使用PLAY_BUFFER_STATE_*宏。
//  [in]pContext - 用户上下文指针。
// 返回值：
//  无。
// 说明：
//  当缓冲状态改变时，触发该回调函数。
////////////////////////////////////////////////////////////////////////////////
typedef void (*PHBPLAY_BUFFER_STATE_CHANGED_CALLBACK)(unsigned int dwOldState, unsigned int dwNewState, void *pContext);

//注册缓冲状态接近于要改变回调函数
- (bool)SetBufferStateAlmostChangeCallback:(PHBPLAY_BUFFER_STATE_ALMOST_CHANGE_CALLBACK)callback context:(void *)pContext;

//注册缓冲状态改变回调函数
- (bool)SetBufferStateChangedCallback:(PHBPLAY_BUFFER_STATE_CHANGED_CALLBACK)callback context:(void *)pContext;

typedef void (*PHBPLAY_PICTRUE_SIZE_CHANGED_CALLBACK)(unsigned int dwWidth, unsigned int dwHeight, void *pContext);
//注册视频解码图像尺寸改变回调函数
- (bool)SetPictureSizeChangedCallback:(PHBPLAY_PICTRUE_SIZE_CHANGED_CALLBACK)callback context:(void *)pContext;

//文件头长度
#define HBPARSER_FILE_HEADER_LENGTH   64

////////////////////////////////////////////////////////////////////////////////
//码流版本
////////////////////////////////////////////////////////////////////////////////
enum HBPARSER_STREAM_VERSION
{
    HBPARSER_STREAM_UNKNOWN = 0,                      //未知流类型
    HBPARSER_STREAM_15      = 1,                      //早期码流，15码流
    HBPARSER_STREAM_6000    = 2,                      //早期码流，6000码流
    HBPARSER_STREAM_V10     = 10,                     //第一代码流
    HBPARSER_STREAM_V20     = 20,                     //第二代码流
    HBPARSER_STREAM_V30     = 30,                     //第三代码流
    
    HBPARSER_STREAM_MEDIA = 1000,                     //流媒体码流（只有文件头，没有帧头）
    
    HBPARSER_STREAM_HX      = 8000,                   //互信互通定制码流
};


////////////////////////////////////////////////////////////////////////////////
//码流分析器特性
////////////////////////////////////////////////////////////////////////////////
typedef struct HBPARSER_PROPERTY
{
    //码流版本
    enum HBPARSER_STREAM_VERSION           Version;
    
    //文件头
    //注意： 绝大多数码流都有文件头，但PARSER_STREAM_6000码流没有文件头
    char                            szFileHeader[HBPARSER_FILE_HEADER_LENGTH];
    
} HBPARSER_PROPERTY, *PHBPARSER_PROPERTY;


////////////////////////////////////////////////////////////////////////////////
//帧类型
////////////////////////////////////////////////////////////////////////////////
enum HBPARSER_FRAME_TYPE
{
    HBPARSER_FRAME_UNKNOWN = 0,                       //未知帧类型
    HBPARSER_FRAME_AUDIO,                             //音频帧
    HBPARSER_FRAME_VIDEO_I,                           //视频I帧
    HBPARSER_FRAME_VIDEO_P,                           //视频P帧
    HBPARSER_FRAME_VIDEO_B,                           //视频B帧
    HBPARSER_FRAME_VIDEO_E,                           //视频E帧
    HBPARSER_FRAME_COUNT,                             //帧类型数量
};


////////////////////////////////////////////////////////////////////////////////
//视频帧信息
////////////////////////////////////////////////////////////////////////////////
typedef struct HBPARSER_VIDEO_INFO
{
    //视频编码算法，使用VIDEO_FORMAT_*宏
    unsigned int                           dwAlgorithm;
    
    //图像宽度，单位：像素
    unsigned int                           dwWidth;
    
    //图像高度，单位：像素
    unsigned int                           dwHeight;
    
    //帧序号
    //帧序号是逐渐递增的，用于判断视频帧的连续性
    unsigned int                           dwIndex;
    
    //距文件起始地址的偏移量，用于文件索引
    long long                        llOffset;
    
    //视频帧绝对时间。
    //从1970-01-01 00:00:00 UTC开始的毫秒数（millisecond）
    long long                        llTimestamp;
    
    //视频帧相对时间，单位：毫秒
    //相邻两帧之间的差值，就是这两帧之间的时间间隔
    unsigned int                           dwTickCount;
    
    //保留
    unsigned int                           dwReserved[3];
    
} HBPARSER_VIDEO_INFO, *PHBPARSER_VIDEO_INFO;


////////////////////////////////////////////////////////////////////////////////
//音频帧信息
////////////////////////////////////////////////////////////////////////////////
typedef struct HBPARSER_AUDIO_INFO
{
    //音频编码算法，使用AUDIO_FORMAT_*宏
    unsigned int                           dwAlgorithm;
    
    //音频通道数
    unsigned int                           dwChannels;
    
    //采样精度
    unsigned int                           dwBitsPerSample;
    
    //采样率，单位：赫兹（Hz）
    unsigned int                           dwSampleRate;
    
    //保留。
    unsigned int                           Reserved[2];
    
} HBPARSER_AUDIO_INFO, *PHBPARSER_AUDIO_INFO;


////////////////////////////////////////////////////////////////////////////////
//判断帧类型
////////////////////////////////////////////////////////////////////////////////
#define PARSER_IS_AUDIO_FRAME(p)    ((p) \
&& PARSER_FRAME_AUDIO == (p)->FrameType)
#define PARSER_IS_VIDEO_FRAME(p)    ((p) \
&& (p)->FrameType >= PARSER_FRAME_VIDEO_I \
&& (p)->FrameType <= PARSER_FRAME_VIDEO_E)
#define PARSER_IS_I_FRAME(p)        ((p) \
&& PARSER_FRAME_VIDEO_I == (p)->FrameType)


////////////////////////////////////////////////////////////////////////////////
//帧信息
////////////////////////////////////////////////////////////////////////////////
typedef struct HBPARSER_INFO
{
    //帧头长度，单位：字节
    unsigned int                           dwHeaderSize;
    
    //编码数据长度，单位：字节
    unsigned int                           dwDataSize;
    
    //帧头地址
    void*                           pHeader;
    
    //编码数据地址
    void*                           pData;
    
    //保留
    unsigned int                           dwReserved;
    
    //帧类型，指定联合体u中有效的成员。
    //帧类型为PARSER_FRAME_AUDIO时，u.a有效。
    //帧类型为PARSER_FRAME_VIDEO_*时，u.v有效。
    enum HBPARSER_FRAME_TYPE               FrameType;
    
    union INFO
    {
        //视频帧信息
        HBPARSER_VIDEO_INFO           v;
        
        //音频帧信息
        HBPARSER_AUDIO_INFO           a;
        
    } u;
    
} HBPARSER_INFO, *PHBPARSER_INFO;


////////////////////////////////////////////////////////////////////////////////
// 函数名：PPARSER_PARSE_CALLBACK
// 描述：码流分析回调函数。
// 参数：
//  [in]pInfo - PARSER_INFO结构体指针。
//  [in]pContext - 用户上下文指针。
// 返回值：
//  无。
// 说明：
////////////////////////////////////////////////////////////////////////////////
typedef void (*PHBPARSER_PARSE_CALLBACK)(
const PHBPARSER_INFO pInfo,
void* pContext
);

- (bool)setParseCallback:(PHBPARSER_PARSE_CALLBACK)pfnCallback context:(void *)pContext;

////////////////////////////////////////////////////////////////////////////////
//音视频解码帧
////////////////////////////////////////////////////////////////////////////////
typedef struct HBDECODER_FRAME
{
    //音视频帧标志
    //TRUE表示视频帧u.v有效，FALSE表示音频帧u.a有效
    BOOL                            bVideo;
    
    //保留
    unsigned int                           dwReserved;
    
    union AV
    {
        struct Video
        {
            //图像宽度，单位：像素
            unsigned int                   dwWidth;
            
            //图像高度，单位：像素
            unsigned int                   dwHeight;
            
            //关键帧
            BOOL                    bKeyFrame;
            
            //YUV格式，使用YUV_FORMAT_*宏
            unsigned int                   dwYuvFormat;
            
            //解码缓冲区，格式由dwYuvFormat定义
            //1、YUV_FORMAT_YV12
            //  pBuffer[0]是Y平面，pBuffer[1]是V平面，pBuffer[2]是U平面
            void*                   pBuffer[4];
            
            //对应解码缓冲区的长度，单位：字节
            unsigned int                   dwBufferLength[4];
            
        }                           v;
        
        struct Audio
        {
            //音频通道数。
            unsigned int                   dwChannels;
            
            //采样精度。
            unsigned short                    dwBitsPerSample;
            
            //采样率，单位：赫兹（Hz）
            unsigned int                   dwSampleRate;
            
            //PCM格式，使用PCM_FORMAT_*宏
            unsigned int                   dwPcmFormat;
            
            //解码缓冲区，格式由dwPcmFormat定义
            void*                   pBuffer;
            
            //解码缓冲区的长度，单位：字节
            unsigned int                   dwBufferLength;
            
        } a;
        
    } u;
    
} HBDECODER_FRAME, *PHBDECODER_FRAME;


////////////////////////////////////////////////////////////////////////////////
// 函数名：PDECODER_CALLBACK
// 描述：解码回调函数。
// 参数：
//  [in]pFrame - DECODER_FRAME结构体指针，音视频解码数据。
//  [in]pContext - 用户上下文指针。
// 返回值：无。
// 说明：
//
////////////////////////////////////////////////////////////////////////////////
typedef void (*PHBDECODER_DECODE_CALLBACK)(
const HBDECODER_FRAME* pFrame,
void* pContext
);

- (bool)setDecodeCallback:(PHBDECODER_DECODE_CALLBACK)pfnCallback context:(void *)pContext;

#define HBPLAY_ERR_WRITE_DISK 0x30
#define HBPLAY_ERR_READ_DISK 0x31

typedef void(^RECORDHANDLERBLOCK)(long fileLen, long fileDuration, long recordState, bool completed);

- (long)startRecord2Mp4File:(NSString *)fileName recordHandle:(RECORDHANDLERBLOCK)block;

- (void)stopRecordFile;

//获取版本信息
- (NSString *)GetVersion;

@end
