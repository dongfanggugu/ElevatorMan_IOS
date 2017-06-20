//
//  StreamMediaServer.m
//  testPod
//
//  Created by wangzhen on 15-4-8.
//  Copyright (c) 2015年 wangzhen. All rights reserved.
//

#import "StreamMediaServer.h"
#import "HBPlaySDK.h"
#import "NSError+HbError.h"

#define NET_TIMEOUT             12
#define NET_BUFFER_LEN			(8*1024)

#define DATA_TYPE_NONE              -1
#define DATA_TYPE_VODFIND           0
#define DATA_TYPE_XMLFILE           1
#define DATA_TYPE_CANCEL            2
#define DATA_TYPE_VODINFO           3
#define DATA_TYPE_VODCMD            4
#define DATA_TYPE_VODDATA           5
#define DATA_TYPE_DOWNLOADFILE      6
#define DATA_TYPE_UPLOADFILE        7
#define DATA_TYPE_UP_FILE_DATA      8
#define DATA_TYPE_REAL_XML          9
#define DATA_TYPE_VOICE_CMD         10
#define DATA_TYPE_VOICE_DATA        11
#define DATA_TYPE_SMS_CMD           12  //【目前用到】
#define DATA_TYPE_SMS_MEDIA         13  //【目前用到】
#define DATA_TYPE_COMPLEX           14
#define DATA_TYPE_DIRECTAV_STATION  15
#define DATA_TYPE_DIRECTAV_FRAME    16
#define DATA_TYPE_DEVICE_VOD_INFO   17
#define DATA_TYPE_DEVICE_VOD_DATA   18

enum FRAMETYPE_SMS
{
    FRAMETYPE_UNKNOWN = -1,
    FRAMETYPE_BP = 0,
    FRAMETYPE_KEY,
    FRAMETYPE_HEAD,
    FRAMETYPE_SPECIAL,
    FRAMETYPE_AUDIO,
};

typedef struct
{
    char    headflag[16];       // 流媒体码流文件头
    int     videoFormat;        // 视频算法
    short   videoWidth;         // 视频宽度
    short   videoHeight;        // 视频高度
    short   IframeInterval;     // I帧间隔
    short   reservedShort;
    int     audioFormat;        // 音频算法
    int     audioSampleRate;    // 音频采样率
    short   audioChannel;       // 音频通道数
    short   audioBitsPerSample; // 音频采样精度
    char    reserved[24];
}SMS_FILEHEAD;

typedef struct
{
    int		iActLength;		//包实际长度
    Byte	byProtocolType;	//新增,协议类型,流媒体为0,一点通盒子为1,手机通讯时,此值固定为0
    Byte	byProtocolVer;	//新增,协议版本,目前固定为9,以后如果有升级,按1增加,可作为C/S端通讯版本匹配提示
    Byte	byDataType;		//数据类型,手机通讯时,DATA_TYPE_REAL_XML:9:交互命令,DATA_TYPE_SMS_CMD:10:云台控制命令,DATA_TYPE_SMS_MEDIA:13:流媒体数据
    Byte	byFrameType;	//FRAMETYPE_BP:0:视频非关键帧,FRAMETYPE_KEY:1:视频关键帧,FRAMETYPE_HEAD:2:文件头,FRAMETYPE_SPECIAL:3:特殊帧,收到此帧可直接忽略掉
    //FRAMETYPE_AUDIO:4:音频帧
    uint	iTimeStampHigh;		//音/视频帧时间戳,目前保留
    uint	iTimeStamplow;		//音/视频帧时间戳,目前保留
    int		iVodFilePercent;//VOD文件播放进度
    int		iVodCurFrameNo;//VOD文件当前帧,需要*2,因为最大为65535,视频文件最大可能为25*3600=90000
    Byte	byBlockHeadFlag;//包头标识,1为头,0为中间包
    Byte	byBlockEndFlag;//包尾标识,1为尾,0为中间包
    Byte	byReserved1;	//保留1
    Byte	byReserved2;	//保留2
    char	cBuffer[NET_BUFFER_LEN];
}NET_LAYER;
#define Net_LAYER_STRUCT_LEN	sizeof(NET_LAYER)
#define PACKAGE_EXTRA_LEN (Net_LAYER_STRUCT_LEN-NET_BUFFER_LEN)

@implementation StreamMediaServer
{
    dispatch_queue_t    smsQueue;
    GCDAsyncSocket      *smsSocket;
    NSTimeInterval      timeOut;
    StreamBlock         callbackBlock;
    StreamBlock         videoDataBlock;
    NSMutableData       *recvBuffer;
    dispatch_semaphore_t semphore;
    int                 nLastPTZCmd;
    NSLock              *lock;
    NSMutableData       *curFrame;
    
    NSString            *curDevName;
    int                 curChannel;
    int                 curStreamType;
    NSString            *curAddress;
    int                 curPort;
}

- (int)connectToSms:(NSString *)address port:(int)port completeBlock:(StreamBlock)block
{
    curAddress = address;
    curPort = port;
    smsQueue = dispatch_queue_create("com.hbgk.hbydt.sms", NULL);
    smsSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:smsQueue];
    semphore = dispatch_semaphore_create(0);
    lock = [[NSLock alloc] init];
    callbackBlock = block;
    
    NSError *error = nil;
    BOOL bConnect = [smsSocket connectToHost:address onPort:port withTimeout:NET_TIMEOUT error:&error];
    if (bConnect) {
        return SMS_OK;
    }
    else
    {
        return SMS_ERR_GENERIC;
    }
    
    return SMS_OK;
}

- (void)getInfoWithDeviceName:(NSString *)devName deviceID:(NSString *)devID completeBlock:(StreamBlock)block
{
    [lock lock];
    NSString *request = [[NSString alloc] initWithFormat:@"<TYPE>GetDeviceInfo</TYPE><DVRName>%@</DVRName><DVCID>%@</DVCID>", devName, devID ? devID : @""];
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    [self sendData:[request dataUsingEncoding:encoding] type:DATA_TYPE_REAL_XML];
    
    [smsSocket readDataWithTimeout:-1 tag:1];
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, NET_TIMEOUT * NSEC_PER_SEC);
    if (dispatch_semaphore_wait(semphore, time) == 0) {
        // 成功获取到返回
        NET_LAYER *pNetLayer = (NET_LAYER *)[recvBuffer bytes];
        NSString *answer = [[NSString alloc] initWithBytes:pNetLayer->cBuffer length:(pNetLayer->iActLength - PACKAGE_EXTRA_LEN) encoding:encoding];
        if (block) {
            block(0, [[NSData alloc] initWithBytes:pNetLayer->cBuffer length:(pNetLayer->iActLength - PACKAGE_EXTRA_LEN)], 0, nil);
        }
    } else {
        if (block) {
            block(0, nil, 0, [NSError errorWithHbCode:ErrorNetworkTimeout]);
        }
    }
    
//    [smsSocket readDataWithTimeout:-1 tag:1];
    [lock unlock];
}

- (int)startPlay:(NSString *)devName channel:(int)nChannel streamType:(int)nStreamType streamCallback:(StreamBlock)block
{
    [lock lock];
    curDevName = devName;
    curChannel = nChannel;
    curStreamType = nStreamType;
    // 请求音视频数据
    NSString *request = [[NSString alloc] initWithFormat:@"<TYPE>StartStream</TYPE><DVRName>%@</DVRName><ChnNo>%d</ChnNo><StreamType>%d</StreamType><TType>2</TType>", devName, nChannel, nStreamType];
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    [self sendData:[request dataUsingEncoding:encoding] type:DATA_TYPE_SMS_CMD];
    [smsSocket readDataWithTimeout:-1 tag:1];
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, NET_TIMEOUT * NSEC_PER_SEC);
    if (dispatch_semaphore_wait(semphore, time) == 0) {
        // 成功获取到返回
        NET_LAYER *pNetLayer = (NET_LAYER *)[recvBuffer bytes];
        NSString *answer = [[NSString alloc] initWithBytes:pNetLayer->cBuffer length:(pNetLayer->iActLength - PACKAGE_EXTRA_LEN) encoding:encoding];
//        NSLog(@"%@", answer);
        // 返回信息解析
        NSRange range = [answer rangeOfString:@"<LinkReturn>SUCCESS</LinkReturn>"];
        if (answer && (range.location != NSNotFound)) {
            // 成功获取到返回-->应答"ImOK"
            NSString *requestOK = @"<TYPE>ImOK</TYPE>";
            videoDataBlock = block;
            [self sendData:[requestOK dataUsingEncoding:encoding] type:DATA_TYPE_SMS_CMD];
//            [smsSocket readDataWithTimeout:-1 tag:1];
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, NET_TIMEOUT * NSEC_PER_SEC);
            if (dispatch_semaphore_wait(semphore, time) == 0) {
                NET_LAYER *pNetLayer = (NET_LAYER *)[recvBuffer bytes];
                NSString *answer = [[NSString alloc] initWithBytes:pNetLayer->cBuffer length:(pNetLayer->iActLength - PACKAGE_EXTRA_LEN) encoding:encoding];
                NSRange range = [answer rangeOfString:@"<Response>SUCCESS</Response>"];
//                NSLog(@"%@", answer);
                if (answer && (range.location != NSNotFound)) {
                    NSString *makeKeyFrame = @"<TYPE>MakeKeyFrame</TYPE>";
                    [self sendData:[makeKeyFrame dataUsingEncoding:encoding] type:DATA_TYPE_SMS_CMD];
                    [smsSocket readDataWithTimeout:-1 tag:1];
                } else {
                }
                NSLog(@"%@ ImOK answer %@", self, answer);
            } else {
                NSLog(@"%@ ImOK timeout", self);
                if (block) {
                    block(0, nil, 0, [NSError errorWithHbCode:ErrorNetworkTimeout]);
                }
            }
        } else {
            NSLog(@"%@ StartStream answer %@", self, answer);
            if (block) {
                block(0, nil, 0, [NSError errorWithHbCode:ErrorUnknown]);
            }
        }
    } else {
        NSLog(@"%@ StartStream timeout", self);
        if (block) {
            block(0, nil, 0, [NSError errorWithHbCode:ErrorNetworkTimeout]);
        }
    }
    [lock unlock];
    return 0;
}

- (int)startPlayback:(NSString *)devName channel:(int)nChannel videoType:(int)nType startTime:(NSDate *)start stopTime:(NSDate *)stop streamCallback:(StreamBlock)block
{
    [lock lock];
    NSCalendar *calendar=[NSCalendar currentCalendar];
    NSDateComponents *startCompontents=[calendar components:(kCFCalendarUnitYear|kCFCalendarUnitMonth|kCFCalendarUnitDay|kCFCalendarUnitHour|kCFCalendarUnitMinute | kCFCalendarUnitSecond) fromDate:start];
    NSDateComponents *stopCompontents=[calendar components:(kCFCalendarUnitYear|kCFCalendarUnitMonth|kCFCalendarUnitDay|kCFCalendarUnitHour|kCFCalendarUnitMinute | kCFCalendarUnitSecond) fromDate:stop];
    
    NSString *request = [[NSString alloc] initWithFormat:@"<TYPE>GetRcdFile</TYPE><DVRName>%@</DVRName><ChnNo>%d</ChnNo><TriggerType>%d</TriggerType><Year1>%d</Year1><Month1>%d</Month1><Day1>%d</Day1><Hour1>%d</Hour1><Minute1>%d</Minute1><Second1>%d</Second1><Year2>%d</Year2><Month2>%d</Month2><Day2>%d</Day2><Hour2>%d</Hour2><Minute2>%d</Minute2><Second2>%d</Second2>", devName, nChannel, nType, startCompontents.year, startCompontents.month, startCompontents.day, startCompontents.hour, startCompontents.minute, startCompontents.second, stopCompontents.year, stopCompontents.month, stopCompontents.day, stopCompontents.hour, stopCompontents.minute, stopCompontents.second];
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    [self sendData:[request dataUsingEncoding:encoding] type:DATA_TYPE_DEVICE_VOD_INFO];
    [smsSocket readDataWithTimeout:-1 tag:1];
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, NET_TIMEOUT * NSEC_PER_SEC);
    if (dispatch_semaphore_wait(semphore, time) == 0) {
        
        // 成功获取到返回
        NET_LAYER *pNetLayer = (NET_LAYER *)[recvBuffer bytes];
        NSString *answer = [[NSString alloc] initWithBytes:pNetLayer->cBuffer length:(pNetLayer->iActLength - PACKAGE_EXTRA_LEN) encoding:encoding];
        //        NSLog(@"%@", answer);
        // 返回信息解析
        NSRange range = [answer rangeOfString:@"<Return>SUCCESS</Return>"];
        if (answer && (range.location != NSNotFound)) {
            // 成功获取到返回-->应答"ImOK"
            NSString *requestOK = @"<TYPE>ImOK</TYPE>";
            videoDataBlock = block;
            [self sendData:[requestOK dataUsingEncoding:encoding] type:DATA_TYPE_DEVICE_VOD_INFO];
            [smsSocket readDataWithTimeout:-1 tag:1];
        } else {
            NSLog(@"%@ StartPlayback answer %@", self, answer);
            if (block) {
                block(0, nil, 0, [NSError errorWithHbCode:ErrorUnknown]);
            }
        }
    } else {
        NSLog(@"%@ StartPlayback timeout", self);
        if (block) {
            block(0, nil, 0, [NSError errorWithHbCode:ErrorNetworkTimeout]);
        }
    }
    
    [lock unlock];
    return 0;
}

- (void)findRecordFileByDevice:(NSString *)devName Channel:(int)nChannel videoType:(int)nType atDay:(NSDate *)day completedHandle:(StreamBlock)block
{
    [lock lock];
    NSCalendar *calendar=[NSCalendar currentCalendar];
    NSDateComponents *startCompontents=[calendar components:(kCFCalendarUnitYear|kCFCalendarUnitMonth|kCFCalendarUnitDay|kCFCalendarUnitHour|kCFCalendarUnitMinute | kCFCalendarUnitSecond) fromDate:day];
    
    NSString *request = [[NSString alloc] initWithFormat:@"<TYPE>GetRcdFileTime</TYPE><DVRName>%@</DVRName><ChnNo>%d</ChnNo><TriggerType>%d</TriggerType><Year1>%ld</Year1><Month1>%ld</Month1><Day1>%ld</Day1><Hour1>%ld</Hour1><Minute1>%ld</Minute1><Second1>%ld</Second1><Year2>%ld</Year2><Month2>%ld</Month2><Day2>%ld</Day2><Hour2>%d</Hour2><Minute2>%d</Minute2><Second2>%d</Second2>", devName, nChannel, nType, startCompontents.year, startCompontents.month, startCompontents.day, startCompontents.hour, startCompontents.minute, startCompontents.second, startCompontents.year, startCompontents.month, startCompontents.day, 23, 59, 59];
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    videoDataBlock = block;
    [self sendData:[request dataUsingEncoding:encoding] type:DATA_TYPE_REAL_XML];
    [smsSocket readDataWithTimeout:-1 tag:1];
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, NET_TIMEOUT * NSEC_PER_SEC);
    if (dispatch_semaphore_wait(semphore, time) == 0) {
        // 成功获取到返回
        NET_LAYER *pNetLayer = (NET_LAYER *)[recvBuffer bytes];
        NSString *answer = [[NSString alloc] initWithBytes:pNetLayer->cBuffer length:(pNetLayer->iActLength - PACKAGE_EXTRA_LEN) encoding:encoding];
        if (block) {
            block(0, answer, 0, [NSError errorWithHbCode:ErrorSuccess]);
        }
    } else {
        if (block) {
            block(0, nil, 0, [NSError errorWithHbCode:ErrorNetworkTimeout]);
        }
    }
    [lock unlock];
    return;
}

- (int)PTZControl:(int)nPTZCmd speed:(int)nSpeed
{
    [lock lock];
    int nRet = SMS_ERR_GENERIC;
    NSString *sPTZCmd = nil;
    
    nSpeed = 6;
    int iSpeed_Pos_AssistantNo = nSpeed;
    bool bStartOrStop = true;
    if (nPTZCmd == ALL_STOP)
    {
        bStartOrStop = false;
        nPTZCmd = nLastPTZCmd;
    }
    
    switch (nPTZCmd)
    {
        case Yuntai_Left_Up:
        case TILT_LEFT_UP:
            if (bStartOrStop)
                sPTZCmd = [[NSString alloc] initWithFormat:@"<TYPE>PTZ</TYPE><PtzID>LeftUp</PtzID><Speed_Pos_AssNo>%d</Speed_Pos_AssNo>", iSpeed_Pos_AssistantNo];
            else
                sPTZCmd = [[NSString alloc] initWithFormat:@"<TYPE>PTZ</TYPE><PtzID>LeftUpStop</PtzID>"];
            break;
        case Yuntai_Left_Down:
        case TILT_LEFT_DOWN:
            if (bStartOrStop)
                sPTZCmd = [[NSString alloc] initWithFormat:@"<TYPE>PTZ</TYPE><PtzID>LeftDown</PtzID><Speed_Pos_AssNo>%d</Speed_Pos_AssNo>", iSpeed_Pos_AssistantNo];
            else
                sPTZCmd = [[NSString alloc] initWithFormat:@"<TYPE>PTZ</TYPE><PtzID>LeftDownStop</PtzID>"];
            break;
        case Yuntai_Right_Up:
        case TILT_RIGHT_UP:
            if (bStartOrStop)
                sPTZCmd = [[NSString alloc] initWithFormat:@"<TYPE>PTZ</TYPE><PtzID>RightUp</PtzID><Speed_Pos_AssNo>%d</Speed_Pos_AssNo>", iSpeed_Pos_AssistantNo];
            else
                sPTZCmd = [[NSString alloc] initWithFormat:@"<TYPE>PTZ</TYPE><PtzID>RightUpStop</PtzID>"];
            break;
        case Yuntai_Right_Down:
        case TILT_RIGHT_DOWN:
            if (bStartOrStop)
                sPTZCmd = [[NSString alloc] initWithFormat:@"<TYPE>PTZ</TYPE><PtzID>RightDown</PtzID><Speed_Pos_AssNo>%d</Speed_Pos_AssNo>", iSpeed_Pos_AssistantNo];
            else
                sPTZCmd = [[NSString alloc] initWithFormat:@"<TYPE>PTZ</TYPE><PtzID>RightDownStop</PtzID>"];
            break;
            
        case Yuntai_Up:
        case TILT_UP:
            if (bStartOrStop)
                sPTZCmd = [[NSString alloc] initWithFormat:@"<TYPE>PTZ</TYPE><PtzID>Up</PtzID><Speed_Pos_AssNo>%d</Speed_Pos_AssNo>", iSpeed_Pos_AssistantNo];
            else
                sPTZCmd = [[NSString alloc] initWithFormat:@"<TYPE>PTZ</TYPE><PtzID>UpStop</PtzID>"];
            break;
        case Yuntai_Left:
        case PAN_LEFT:
            if (bStartOrStop)
                sPTZCmd = [[NSString alloc] initWithFormat:@"<TYPE>PTZ</TYPE><PtzID>Left</PtzID><Speed_Pos_AssNo>%d</Speed_Pos_AssNo>", iSpeed_Pos_AssistantNo];
            else
                sPTZCmd = [[NSString alloc] initWithFormat:@"<TYPE>PTZ</TYPE><PtzID>LeftStop</PtzID>"];
            break;
        case Yuntai_Down:
        case TILT_DOWN:
            if (bStartOrStop)
                sPTZCmd = [[NSString alloc] initWithFormat:@"<TYPE>PTZ</TYPE><PtzID>Down</PtzID><Speed_Pos_AssNo>%d</Speed_Pos_AssNo>", iSpeed_Pos_AssistantNo];
            else
                sPTZCmd = [[NSString alloc] initWithFormat:@"<TYPE>PTZ</TYPE><PtzID>DownStop</PtzID>"];
            break;
        case Yuntai_Right:
        case PAN_RIGHT:
            if (bStartOrStop)
                sPTZCmd = [[NSString alloc] initWithFormat:@"<TYPE>PTZ</TYPE><PtzID>Right</PtzID><Speed_Pos_AssNo>%d</Speed_Pos_AssNo>", iSpeed_Pos_AssistantNo];
            else
                sPTZCmd = [[NSString alloc] initWithFormat:@"<TYPE>PTZ</TYPE><PtzID>RightStop</PtzID>"];
            break;
        case Aperture_Plus:
            if (bStartOrStop)
                sPTZCmd = [[NSString alloc] initWithFormat:@"<TYPE>PTZ</TYPE><PtzID>Aperture_Add</PtzID><Speed_Pos_AssNo>%d</Speed_Pos_AssNo>", iSpeed_Pos_AssistantNo];
            else
                sPTZCmd = [[NSString alloc] initWithFormat:@"<TYPE>PTZ</TYPE><PtzID>Aperture_Add_Stop</PtzID>"];
            break;
        case Aperture_Reduce:
            if (bStartOrStop)
                sPTZCmd = [[NSString alloc] initWithFormat:@"<TYPE>PTZ</TYPE><PtzID>Aperture_Dec</PtzID><Speed_Pos_AssNo>%d</Speed_Pos_AssNo>", iSpeed_Pos_AssistantNo];
            else
                sPTZCmd = [[NSString alloc] initWithFormat:@"<TYPE>PTZ</TYPE><PtzID>Aperture_Dec_Stop</PtzID>"];
            break;
        case Focus_Plus:
        case FOCUS_NEAR:
            if (bStartOrStop)
                sPTZCmd = [[NSString alloc] initWithFormat:@"<TYPE>PTZ</TYPE><PtzID>Focus_Add</PtzID><Speed_Pos_AssNo>%d</Speed_Pos_AssNo>", iSpeed_Pos_AssistantNo];
            else
                sPTZCmd = [[NSString alloc] initWithFormat:@"<TYPE>PTZ</TYPE><PtzID>Focus_Add_Stop</PtzID>"];
            break;
        case Focus_Reduce:
        case FOCUS_FAR:
            if (bStartOrStop)
                sPTZCmd = [[NSString alloc] initWithFormat:@"<TYPE>PTZ</TYPE><PtzID>Focus_Dec</PtzID><Speed_Pos_AssNo>%d</Speed_Pos_AssNo>", iSpeed_Pos_AssistantNo];
            else
                sPTZCmd = [[NSString alloc] initWithFormat:@"<TYPE>PTZ</TYPE><PtzID>Focus_Dec_Stop</PtzID>"];
            break;
        case Zoom_Wide:
            if (bStartOrStop)
                sPTZCmd = [[NSString alloc] initWithFormat:@"<TYPE>PTZ</TYPE><PtzID>Zoom_Add</PtzID><Speed_Pos_AssNo>%d</Speed_Pos_AssNo>", iSpeed_Pos_AssistantNo];
            else
                sPTZCmd = [[NSString alloc] initWithFormat:@"<TYPE>PTZ</TYPE><PtzID>Zoom_Add_Stop</PtzID>"];
            break;
        case Zoom_Tele:
            if (bStartOrStop)
                sPTZCmd = [[NSString alloc] initWithFormat:@"<TYPE>PTZ</TYPE><PtzID>Zoom_Dec</PtzID><Speed_Pos_AssNo>%d</Speed_Pos_AssNo>", iSpeed_Pos_AssistantNo];
            else
                sPTZCmd = [[NSString alloc] initWithFormat:@"<TYPE>PTZ</TYPE><PtzID>Zoom_Dec_Stop</PtzID>"];
            break;
        case Set_Reserved:
            sPTZCmd = [[NSString alloc] initWithFormat:@"<TYPE>PTZ</TYPE><PtzID>Set_Reserved</PtzID><Speed_Pos_AssNo>%d</Speed_Pos_AssNo>", iSpeed_Pos_AssistantNo];
            break;
        case Call_Reserved:
            sPTZCmd = [[NSString alloc] initWithFormat:@"<TYPE>PTZ</TYPE><PtzID>Call_Reserved</PtzID><Speed_Pos_AssNo>%d</Speed_Pos_AssNo>", iSpeed_Pos_AssistantNo];
            break;
        case AssistantId:
            if (bStartOrStop)
                sPTZCmd = [[NSString alloc] initWithFormat:@"<TYPE>PTZ</TYPE><PtzID>Assistant</PtzID><Speed_Pos_AssNo>%d</Speed_Pos_AssNo><Open>1</Open>", iSpeed_Pos_AssistantNo];
            else
                sPTZCmd = [[NSString alloc] initWithFormat:@"<TYPE>PTZ</TYPE><PtzID>Assistant</PtzID><Speed_Pos_AssNo>%d</Speed_Pos_AssNo><Open>0</Open>", iSpeed_Pos_AssistantNo];
            break;
    }
    if (sPTZCmd) {
        nLastPTZCmd = nPTZCmd;
        
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        [self sendData:[sPTZCmd dataUsingEncoding:encoding] type:DATA_TYPE_SMS_CMD];
        nRet = SMS_OK;
    }
    [lock unlock];
    return nRet;
}

- (int)sendData:(NSData *)pSend type:(int)nType
{
    NET_LAYER   _NetLayer;
    _NetLayer.byProtocolType        = 0;			// 协议类型
    _NetLayer.byProtocolVer         = 9;			// 协议版本
    _NetLayer.byDataType            = nType;        // 数据类型,手机通讯时,
                                                    // DATA_TYPE_REAL_XML:9:交互命令,
                                                    // DATA_TYPE_SMS_CMD:12:云台控制命令,
                                                    // DATA_TYPE_SMS_MEDIA:13:流媒体数据
    _NetLayer.byFrameType           = 0;			// 帧类型
    _NetLayer.iTimeStampHigh        = 0;			// 时间戳
    _NetLayer.iTimeStamplow         = 0;
    _NetLayer.iVodFilePercent       = 0;            // VOD进度,默认值
    _NetLayer.iVodCurFrameNo        = 0;			// VOD当前帧,默认值
    
    int iLength = [pSend length];
    void *pSrc = [pSend bytes];
    int i;
    char *pSrcOffset;
    int iSplit;				//如果大于8K，拆分的包数
    int iLastBlockLength;	//拆分后，前面包有效数据长度为8K，最后一包的长度
    if (iLength % NET_BUFFER_LEN == 0)
    {
        iSplit = iLength / NET_BUFFER_LEN;
        iLastBlockLength = NET_BUFFER_LEN;
    }
    else
    {
        iSplit = (iLength + NET_BUFFER_LEN) / NET_BUFFER_LEN;
        iLastBlockLength = iLength % NET_BUFFER_LEN;
    }
    for(i = 0; i < iSplit; i++)
    {
        pSrcOffset=pSrc+i*NET_BUFFER_LEN;
        if (i==iSplit-1)//最后一包
        {
            _NetLayer.iActLength=PACKAGE_EXTRA_LEN+iLastBlockLength;
            memcpy(&_NetLayer.cBuffer,pSrcOffset,iLastBlockLength);
            if(iSplit==1)
            {
                _NetLayer.byBlockHeadFlag=TRUE;
                _NetLayer.byBlockEndFlag=TRUE;
            }
            else
            {
                _NetLayer.byBlockHeadFlag=FALSE;
                _NetLayer.byBlockEndFlag=TRUE;
            }
        }
        else//前面的包
        {
            _NetLayer.iActLength=Net_LAYER_STRUCT_LEN;
            memcpy(_NetLayer.cBuffer,pSrcOffset,NET_BUFFER_LEN);
            if(i==0)
            {
                _NetLayer.byBlockHeadFlag=TRUE;
                _NetLayer.byBlockEndFlag=FALSE;
            }
            else
            {
                _NetLayer.byBlockHeadFlag=FALSE;
                _NetLayer.byBlockEndFlag=FALSE;
            }
        }
        
        NSData *pCurSend = [[NSData alloc] initWithBytes:&_NetLayer length:_NetLayer.iActLength];
        [smsSocket writeData:pCurSend withTimeout:-1 tag:1];
    }
    
//    [smsSocket readDataWithTimeout:-1 tag:1];
    return 0;
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
//    NSLog(@"Socket:DidConnectToHost: %@ Port: %hu", host, port);
    if (callbackBlock) {
        callbackBlock(0, nil, 0, nil);
    }
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
//    NSLog(@"SocketDidDisconnect:WithError: %@", err);
    if (callbackBlock) {
        callbackBlock(0, nil, 0, err);
    }
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    //            NSLog(@"socket:didReadData:withTag (%x %x)>>>>>>> len %ld >> %ld >>>>>>>", recvBuffer, data, [data length], [recvBuffer length]);
    if (recvBuffer == nil) {
        recvBuffer = [[NSMutableData alloc] init];
    }
    [recvBuffer appendData:data];
    
    int recvedLen = [recvBuffer length];
    
    while (recvedLen >= PACKAGE_EXTRA_LEN) {
        NET_LAYER *pNetLayer = (NET_LAYER *)[recvBuffer bytes];
        if (pNetLayer->byDataType > 16 || pNetLayer->byDataType < 0
            || pNetLayer->iActLength < PACKAGE_EXTRA_LEN || pNetLayer->iActLength > Net_LAYER_STRUCT_LEN) {
            NSLog(@"package error!!!");
            [recvBuffer setData:nil];
            return;
        }
        
        if (recvedLen >= pNetLayer->iActLength) {
//                        NSLog(@"frame %d >> data %d H(%d)E(%d)>>>> len %d", pNetLayer->byFrameType, pNetLayer->byDataType, pNetLayer->byBlockHeadFlag, pNetLayer->byBlockEndFlag, pNetLayer->iActLength);
            
            NSData *pData = [recvBuffer subdataWithRange:NSMakeRange(PACKAGE_EXTRA_LEN, pNetLayer->iActLength - PACKAGE_EXTRA_LEN)];
            switch (pNetLayer->byDataType) {
                case DATA_TYPE_SMS_MEDIA:
                case DATA_TYPE_DEVICE_VOD_DATA:
                {
                    int type = FRAMETYPE_UNKNOWN;
                    switch (pNetLayer->byFrameType) {
                        case FRAMETYPE_HEAD:
                        {
                            NSLog(@"%@ get frame head %d", self, pNetLayer->byFrameType);
                            
                            SMS_FILEHEAD filehead;
                            memcpy(filehead.headflag, "HBGKSTREAMMEDIA", 16);
                            filehead.videoFormat = PLAY_VIDEO_FORMAT_H264;
                            int *pRet = (int *)pNetLayer->cBuffer;
                            filehead.videoWidth = *pRet;
                            filehead.videoHeight = *(pRet + 1);
                            filehead.IframeInterval = *(pRet + 2);
                            filehead.audioFormat = PLAY_AUDIO_FORMAT_G711_ALAW;
                            switch (*(pRet + 3)) {
                                case 0x15001:
                                    filehead.audioFormat = PLAY_AUDIO_FORMAT_MP3;
                                    break;
                                    
                                case 0x10007:
                                    filehead.audioFormat = PLAY_AUDIO_FORMAT_G711_ALAW;
                                    break;
                                    
                                default:
                                    break;
                            }
                            filehead.audioSampleRate = *(pRet + 4);
                            filehead.audioBitsPerSample = *(pRet + 5);
                            filehead.audioChannel = *(pRet + 6);
                            switch (*(pRet + 8)) {
                                case 28:
                                    filehead.videoFormat = PLAY_VIDEO_FORMAT_H264;
                                    break;
                                    
                                default:
                                    break;
                            }
                            if (videoDataBlock) {
                                videoDataBlock(type, [[NSData alloc] initWithBytes:&filehead length:sizeof(SMS_FILEHEAD)], 0, nil);
                            }
                        }
                            pData = nil;
                            break;
                            
                        case FRAMETYPE_BP:
                            type = PLAY_FRAME_VIDEO_P;
                            break;
                        case FRAMETYPE_KEY:
                            type = PLAY_FRAME_VIDEO_I;
                            break;
                        case FRAMETYPE_AUDIO:
                            type = PLAY_FRAME_AUDIO;
                            break;
                            
                        default:
                            break;
                    }
                    
                    if (curFrame == nil) {
                        curFrame = [[NSMutableData alloc] init];
                    }
                    [curFrame appendData:pData];
                    if (pNetLayer->byBlockEndFlag && ([curFrame length] != 0)) {
                        unsigned int timeH = pNetLayer->iTimeStampHigh;
                        unsigned int timeL = pNetLayer->iTimeStamplow;
                        UInt64 llTimestamp = (timeL & 0xFFFFFFFFl) | (((UInt64)timeH << 32) & 0xFFFFFFFF00000000l);
                        
                        if (videoDataBlock) {
                            videoDataBlock(type, curFrame, llTimestamp, nil);
                        }
                        curFrame = nil;
                    }
                }
                    break;
                    
                case DATA_TYPE_SMS_CMD:
                    dispatch_semaphore_signal(semphore);
                    break;
                    
                case DATA_TYPE_REAL_XML:
                    dispatch_semaphore_signal(semphore);
                    break;
                    
                default:
                    break;
            }
            recvedLen = recvedLen - pNetLayer->iActLength;
            
            if (recvedLen > 0) {
                NSData *remain = [recvBuffer subdataWithRange:NSMakeRange(pNetLayer->iActLength, recvedLen)];
                [recvBuffer setData:remain];
            }
            else
            {
                [recvBuffer setData:nil];
                recvedLen = 0;
            }
        }
        else
        {
            break;
        }
    }
    [smsSocket readDataWithTimeout:-1 tag:1];
}

//- (void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag;

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
//    NSLog(@"socket:didWriteDataWithTag: %ld",tag);
}

//- (void)socket:(GCDAsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag;

- (void)dealloc
{
    [lock lock];
    [smsSocket disconnect];
    smsQueue = nil;
    smsSocket = nil;
    semphore = nil;
    [lock unlock];
    lock = nil;
//    NSLog(@"%@ dealloc>>>>>>>>>>>>>>", self);
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@:%p, \"%@@%d %@ %d %d\">", [self class], self, curAddress, curPort, curDevName, curChannel, curStreamType];
}
@end
