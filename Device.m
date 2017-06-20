//
//  Device.m
//  hbydtSDKDemo
//
//  Created by wangzhen on 16/4/14.
//  Copyright © 2016年 wangzhen. All rights reserved.
//

#import "Device.h"
#import "HBNetSDK.h"
#import "HBPlaySDK.h"
#import "MapErrorCode.h"
#import "NSError+HbError.h"
#import "libt2u.h"
#import "StreamMediaServer.h"
#import "Viewport.h"
// 回放类型
typedef NS_ENUM(NSInteger, PlaybackType) {
    PlaybackTypeUnknow,
    PlaybackTypeOld,                // 老点播协议，数据发送速度由设备端控制
    PlaybackTypeVod,                // 交互式点播，需发送数据请求命令
};


// 一次请求大量帧数，尽快缓冲足够多数据以便回放
static const int RequestLargeData = 10;

// 一次请求少量帧数，保证播放流畅性
static const int RequestSmallData = 2;

static const int RequestNoData = 0;

static const float RequestDataPeriod = 0.150;

@interface Device()

// 设备相关操作需要加锁处理，防止操作过程中设备对象释放导致奔溃
@property (nonatomic, strong) NSRecursiveLock *deviceLock;

// 流媒体IP，重一点通服务器获取
@property (strong, nonatomic) NSString *smsIP;

// 流媒体端口，重一点通服务器获取
@property (nonatomic) int smsPort;

// 登录句柄，汉邦设备直连返回
@property (nonatomic) long lUserID;

// 流媒体预览句柄
@property (nonatomic) StreamMediaServer *lSmsHandle;

// 汉邦设备预览句柄
@property (nonatomic) long lRealHandle;

// 汉邦设备回放句柄
@property (nonatomic) long lPlaybackHandle;

// 点播回放vod，数据请求定时器
@property (nonatomic, strong) NSTimer *requestDataTimer;

// 数据请求量
@property (atomic, assign) int requestDataCount;

// 流媒体回放句柄
@property (nonatomic, strong) StreamMediaServer *lSmsPlayback;

// 解码对象
@property (strong, nonatomic) HBPlaySDK *player;

// 视频显示view对象
@property (strong, nonatomic) Viewport *viewport;

@end

@implementation Device
{
    // 汉邦设备登录返回参数－－－设备类型，设备名称通道名等
    HB_NET_DEVICEINFO devInfo;
    
    BOOL isContinueGetSms;
    
    int playbackType;
}

@synthesize userName;
@synthesize password;

@synthesize lanIP;
@synthesize lanPort;
@synthesize vveyeID;
@synthesize vveyeRemotePort;
@synthesize vveyeLocalPort;
@synthesize domain;
@synthesize domainPort;
@synthesize deviceID;
@synthesize serialNO;

@synthesize smsIP;
@synthesize smsPort;

@synthesize lUserID;
@synthesize lSmsHandle;
@synthesize lRealHandle;
@synthesize lSmsPlayback;
@synthesize lPlaybackHandle;

@synthesize requestDataCount;
@synthesize requestDataTimer;

@synthesize player;

@synthesize deviceLock;

- (instancetype)init
{
    if (self = [super init]) {
        deviceLock = [[NSRecursiveLock alloc] init];
    }
    return self;
}

// 设备登录
- (void)loginWithBlick:(void(^)(BOOL loginStatus))block {
    BOOL isLogined = NO;
    
    // 局域网设备登录
    if (lanIP && [lanIP length] > 0 && lanPort != 0) {
        isLogined = [self deviceLocalLogin];
        self.isLogin = isLogined;
        if (isLogined) {
            _deviceLoginType = lanIPLogin;
        }
    }
    
    // vv穿透登录
    if (!isLogined && vveyeID && [vveyeID length] > 0 && vveyeRemotePort != 0) {
        NSLog(@">>> try vv login");
        isLogined = [self deviceVVLogin];
        self.isLogin = isLogined;
        if (isLogined) {
            
            _deviceLoginType = vvLogin;
        }
    }
    
    // 域名登录
    if (!isLogined && domain && [domain length] > 0 && domainPort != 0) {
        NSLog(@">>> try domain login");
        isLogined = [self deviceDomainLogin];
        self.isLogin = isLogined;
        if (isLogined) {
            
            _deviceLoginType = domainLogin;
        }
    }
    
//    // 流媒体登录
//    if (!isLogined && deviceID && [deviceID length] > 0) {
//        NSLog(@">>> try sms login");
//        isLogined = [self deviceSmsLogin];
//        self.isLogin = isLogined;
//        
//        if (isLogined) {
//            
//            _deviceLoginType = smsLogin;
//        }
//    }
    if (block) {
        block(isLogined);
    }
}

// 设备断线回调
void deviceDisconnectCallback(LONG lCommand, void *pData, void *pContext)
{
    if (lCommand == COMM_CONNECT) {
        Device *p = (__bridge Device *)pContext;
        [p onDisconnected];
    }
}

- (void)onDisconnected
{
    // 设备重连处理
    // 资源释放－－－关闭已开回放／预览／设备登出
    // 重连设备
}

// 局域网ip登录
- (BOOL)deviceLocalLogin
{
    memset(&devInfo, 0, sizeof(HB_NET_DEVICEINFO));
    devInfo.dwSize = sizeof(HB_NET_DEVICEINFO);
    [deviceLock lock];
    lUserID = HB_NET_Login((char *)lanIP.UTF8String, lanPort, (char *)userName.UTF8String, (char *)password.UTF8String, &devInfo, deviceDisconnectCallback, (__bridge void *)self);
    [deviceLock unlock];
    if (lUserID) {
        NSLog(@"device lan login success!!");
        return YES;
    } else {
        NSLog(@"device lan login fail! error %d", HB_NET_GetLastError());
        return NO;
    }
}

// vv穿透登录
- (BOOL)deviceVVLogin
{
    int i = 0;
    NSLog(@"try login %@ >>> %@", serialNO, vveyeID);
    
    // 查询与vv服务器连接
    NSError *error = [NSError errorWithHbCode:ErrorVVeyeStatus];
    for (i = 0; i < 10; i++) {
        if (t2u_status() == 1) {
            
            error = [NSError errorWithHbCode:ErrorSuccess];
            break;
        }
        [NSThread sleepForTimeInterval:0.1];
    }
    
    // 端口映射
    if ([error code] == ErrorSuccess) {
        error = [NSError errorWithHbCode:ErrorVVeyeAddPortV3];
        for (i = 0; i < 10; i++) {
            vveyeLocalPort = t2u_add_port_v3(vveyeID.UTF8String, NULL, "127.0.0.1", vveyeRemotePort, 0);
            if (vveyeLocalPort > 0) {
                error = [NSError errorWithHbCode:ErrorSuccess];
                break;
            }
            [NSThread sleepForTimeInterval:0.1];
        }
    } else {
        NSLog(@"%@ t2u_query fail", serialNO);
    }
    
    // 查询端口状态
    if ([error code] == ErrorSuccess) {
        
        error = [NSError errorWithHbCode:ErrorVVeyePortStatus];
        T2uNetStat stat;
        for (i = 0; i < 20; i++) {
            
            if (t2u_port_status(vveyeLocalPort, &stat) == 1) {
                
                error = [NSError errorWithHbCode:ErrorSuccess];
                break;
            }
            [NSThread sleepForTimeInterval:1];
        }
        
    } else {
        
        NSLog(@"%@ add port fail", serialNO);
    }
    
    if ([error code] == ErrorSuccess) {
        // 穿透超时需要延长
        HB_NET_SetConnectTime(12 * 1000, 3);
        
        memset(&devInfo, 0, sizeof(HB_NET_DEVICEINFO));
        devInfo.dwSize = sizeof(HB_NET_DEVICEINFO);
        [deviceLock lock];
        lUserID = HB_NET_Login("127.0.0.1", vveyeLocalPort, (char *)userName.UTF8String, (char *)password.UTF8String, &devInfo, deviceDisconnectCallback, (__bridge void *)self);
        [deviceLock unlock];
        
        if (lUserID == 0) {
            error = [MapErrorCode mapNetsdkError:HB_NET_GetLastError()];
            
            // 映射端口释放
            t2u_del_port(vveyeLocalPort);
            
            vveyeLocalPort = 0;
            NSLog(@"login fail %@", [error description]);
        } else {
            error = [NSError errorWithHbCode:ErrorSuccess];
            return YES;
        }
        
    } else {
        NSLog(@"%@ port status fail", serialNO);
        t2u_del_port(vveyeLocalPort);
        vveyeLocalPort = 0;
    }
    return NO;
}

// 域名登录
- (BOOL)deviceDomainLogin {
    
    NSError *error = [NSError errorWithHbCode:ErrorNotSupported];
    if (domain != nil && [domain length] > 0 && domainPort != 0) {
        memset(&devInfo, 0, sizeof(HB_NET_DEVICEINFO));
        devInfo.dwSize = sizeof(HB_NET_DEVICEINFO);
        HB_NET_SetConnectTime(12 * 1000, 3);
        [deviceLock lock];
        lUserID = HB_NET_Login((char *)domain.UTF8String, domainPort, (char *)userName.UTF8String, (char *)password.UTF8String, &devInfo, deviceDisconnectCallback, (__bridge void *)self);
        [deviceLock unlock];
        if (lUserID == 0) {
            error = [MapErrorCode mapNetsdkError:HB_NET_GetLastError()];
            NSLog(@"domain login fail");
        } else {
            error = [NSError errorWithHbCode:ErrorSuccess];
            return YES;
        }
    }
    return NO;
}

// 流媒体登录
- (BOOL)deviceSmsLogin {
    
//    __block BOOL isLogined = NO;
//    // 流媒体设备登录仅从服务器获取流媒体设备相关信息，获取成功则代表可取码流，获取失败原则上不反复获取
//    if (!isContinueGetSms) {
//        return NO;
//    }
//    // TODO:从一点通获取流媒体参数
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
//    [HBYdtNetCtrl getSmsServerWithDeviceId:deviceID Block:^(int result, HBYdtSmsParam *server) {
//        if (result != HBYDT_ERROR_SUCCESS) {
//            isContinueGetSms = NO;
//        } else {
//            smsIP = server.smsIp;
//            smsPort = server.smsPort;
//            NSError *error = [NSError errorWithHbCode:ErrorDeviceDisconnected];
//            if (server.deviceStatus == 0) {
//                error = [NSError errorWithHbCode:ErrorSuccess];
//                isLogined = YES;
//            } else {
//                error = [MapErrorCode mapYdtError:server.deviceStatus];
//            }
//        }
//        dispatch_semaphore_signal(semaphore);
//    }];
//    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 12 * NSEC_PER_SEC);
//    dispatch_semaphore_wait(semaphore, time);
//    return isLogined;
//}
    return YES;
}
// 设备登出
- (void)logout {
    
    // 流媒体登录不需要处理
    
    [deviceLock lock];
    if (lUserID) {
        HB_NET_Logout(lUserID);
        lUserID = 0;
    }
    [deviceLock unlock];
    if (vveyeLocalPort > 0) {
        t2u_del_port(vveyeLocalPort);
        vveyeLocalPort = 0;
    }
}

static void playStreamCallback(long lRealHandle, LPHB_NET_STREAMCALLBACKDATA pStreamData)
{
    Device *play = (__bridge Device *)pStreamData->pContext;
    if (play && [play respondsToSelector:@selector(playData:length:type:timestamp:)]) {
        [play playData:pStreamData->pFrame length:pStreamData->dwDataSize type:0 timestamp:0];
    }
    
    return;
}

static void bufferStateChangedCallback(unsigned int dwOldState, unsigned int dwNewState, void *pContext)
{
    if (dwNewState == PLAY_BUFFER_STATE_BUFFERING) {
        Device *p = (__bridge Device *)pContext;
        if (p && [p.player GetPlayState] == PLAY_STATE_PLAYING) {
            // 回放时，正在缓冲时可一次请求较多数据
            p.requestDataCount = RequestLargeData;
        }
    }
}

static void bufferStateAmostChangeCallback(BOOL bAlmostEmpty, void* pContext)
{
    
    Device *p = (__bridge Device *)pContext;
    if (p && [p.player GetPlayState] == PLAY_STATE_PLAYING) {
        if (bAlmostEmpty) {
            //      TRUE表示缓冲状态接近于要从PLAY_BUFFER_STATE_ENOUGH变为PLAY_BUFFER_STATE_BUFFERING，
            //      此时应该继续调用CMediaPlay::InputData函数输入更多数据，尽量维持PLAY_BUFFER_STATE_ENOUGH
            //      状态不变。
            p.requestDataCount = RequestSmallData;
        } else {
            //      FALSE表示缓冲状态接近于要从PLAY_BUFFER_STATE_ENOUGH变为PLAY_BUFFER_STATE_TOO_MUCH，
            //      此时应该暂停调用CMediaPlay::InputData函数，尽量维持PLAY_BUFFER_STATE_ENOUGH状态不变。
            p.requestDataCount = RequestNoData;
        }
    }
}

static void PictureSizeChangedCallback(unsigned int dwWidth, unsigned int dwHeight, void *pContext)
{
    NSLog(@"preview PictureSizeChangedCallback %d %d", dwWidth, dwHeight);
}

- (void)playData:(void *)data length:(int)len type:(int)type timestamp:(long long)llTimestamp
{
    if (player == nil) {
        // 打开解码
        player = [HBPlaySDK openStream:data length:len];
        
        if (self.viewport) {
            [player AddViewport:self.viewport];
        }
        // 设置缓冲模式
        [player SetBufferMode:PLAY_BUFFER_MODE_BALANCED];
        
        __weak Device *weakself = self;
        [self.player SetBufferStateAlmostChangeCallback:bufferStateAmostChangeCallback context:(__bridge void *)weakself];
        [self.player SetBufferStateChangedCallback:bufferStateChangedCallback context:(__bridge void *)weakself];
        [self.player SetPictureSizeChangedCallback:PictureSizeChangedCallback context:(__bridge void*)weakself];
        [self.player Play];
    }
    else
    {
        // 未考虑缓冲满重复送
        [self.player InputData:data length:len type:type timestamp:llTimestamp];
    }
}

// 实时预览
- (void)realplay:(Viewport *)view completedHandle:(void(^)(NSError *error))block
{
    HB_NET_CLIENTINFO info;
    memset(&info, 0, sizeof(HB_NET_CLIENTINFO));
    info.dwSize = sizeof(HB_NET_CLIENTINFO);
    
    // 主子码流类型设置，0，主码流；1，子码流；
    info.lStreamType = 1;
    
    // 通道号
    info.lChannel = 0;
    self.viewport = view;
    
    // 带宽有限，子码流情况下可考虑修改码流帧率，解决卡顿问题
    if (1) {
        HB_NET_setStreamConfig(lUserID, 0, info.lStreamType, 15, 128, -1);
    }
    
    info.pfnCallback = (PHB_NET_STREAMDATA_PROC)playStreamCallback;
    __weak Device *weekself = self;
    info.pContext = (__bridge void *)(weekself);
    
    [deviceLock lock];
    lRealHandle = HB_NET_RealPlay(lUserID, &info);
    [deviceLock unlock];
    
    NSError *error;
    if (lRealHandle) {
        
        error = [NSError errorWithHbCode:ErrorSuccess];
    
    }
    else
    {
        NSLog(@"real play fail!!!! >>> %@ %ld", self, info.lChannel);
        int lastError = HB_NET_GetLastError();
        if (lastError == 0) {
            error = [NSError errorWithHbCode:ErrorNetworkTimeout];
        } else {
            error = [MapErrorCode mapNetsdkError:lastError];
        }
    }
    
    if (block) {
        
        block(error);
    }
}

// 流媒体实时预览
- (void)smsRealplay:(Viewport *)view
{
    NSError *error = [NSError errorWithHbCode:ErrorNotSupported];
    lSmsHandle = [StreamMediaServer alloc];
    int nRet = [lSmsHandle connectToSms:smsIP port:smsPort completeBlock:^(int type, NSData *data, long long llTimestamp, NSError *error) {
    }];
    if (nRet == SMS_OK) {
        error = [NSError errorWithHbCode:ErrorSuccess];
        self.viewport = view;
        [lSmsHandle startPlay:serialNO channel:0 streamType:0 streamCallback:^(int type, NSData *data, long long llTimestamp, NSError *error) {
            
            if (error && [error code] != ErrorSuccess)
            {
                // 开启失败，资源释放
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    lSmsHandle = nil;
                });
            }
            [self playData:[data bytes] length:[data length] type:type timestamp:llTimestamp];
        }];
    }
}

// 关闭预览
- (void)stopRealplay
{
    // 需先关闭网络数据接收，再释放解码
    if (lRealHandle) {
        [deviceLock lock];
        HB_NET_StopRealPlay(lRealHandle);
        lRealHandle = 0;
        [deviceLock unlock];
    }
    if (lSmsHandle) {
        lSmsHandle = nil;
    }
    player = nil;
}

// 录像文件查询
- (void)findRecordFileByChannel:(int)channelIndx atDay:(NSDate *)day completedHandle:(void (^)(NSError *error, NSArray *filesList))block
{
    NSMutableArray *fileList = nil;
    fileList =  [[NSMutableArray alloc] init];
    
    //    if (NO/*_deviceParam.networkType == NetworkSms*/) {
    //        StreamMediaServer *lSMSHandle = [StreamMediaServer alloc];
    //        int nRet = [lSMSHandle connectToSms:_deviceParam.smsIP port:_deviceParam.smsPort completeBlock:^(int type, NSData *data, long long llTimestamp, NSError *error) {
    //        }];
    //        if (nRet == SMS_OK) {
    //            [lSMSHandle findRecordFileByDevice:_deviceParam.serialNO Channel:channelIndx videoType:0 atDay:day completedHandle:^(int type, NSData *data, long long llTimestamp, NSError *error) {
    //                if ([error code] == ErrorSuccess) {
    //                    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    //                    NSString *result = [[NSString alloc] initWithData:data encoding:enc];
    //                    NSLog(@"sms find file %@", result);
    //                    [self parseRecFiles:result channel:channelIndx OutFiles:fileList];
    //                    if (block) {
    //                        block([NSError errorWithHbCode:ErrorSuccess], fileList);
    //                    }
    //                }
    //            }];
    //        } else {
    //            if (block) {
    //                block([MapErrorCode mapNetsdkError:nRet], nil);
    //            }
    //        }
    //        return;
    //    }
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned unitFlags = kCFCalendarUnitYear | kCFCalendarUnitMonth | kCFCalendarUnitDay;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:day];
    HB_NET_FILEFINDCOND findFileInfo;
    memset(&findFileInfo, 0, sizeof(HB_NET_FILEFINDCOND));
    findFileInfo.dwSize = sizeof(HB_NET_FILEFINDCOND);
    findFileInfo.dwFileType = HB_NET_REC_ALL;
    findFileInfo.dwChannel = channelIndx;
    findFileInfo.struStartTime.dwYear = (unsigned int)[comps year];
    findFileInfo.struStartTime.dwMonth = (unsigned int)[comps month];
    findFileInfo.struStartTime.dwDay = (unsigned int)[comps day];
    findFileInfo.struStartTime.dwHour = 0;
    findFileInfo.struStartTime.dwMinute = 0;
    findFileInfo.struStartTime.dwSecond = 0;
    
    findFileInfo.struStopTime.dwYear = (unsigned int)[comps year];
    findFileInfo.struStopTime.dwMonth = (unsigned int)[comps month];
    findFileInfo.struStopTime.dwDay = (unsigned int)[comps day];
    findFileInfo.struStopTime.dwHour = 23;
    findFileInfo.struStopTime.dwMinute = 59;
    findFileInfo.struStopTime.dwSecond = 59;
    
    [deviceLock lock];
    long lFindhandle = HB_NET_FindFile(lUserID, &findFileInfo);
    [deviceLock unlock];
    
    long lFindRet = HB_NET_FILE_NOFIND;
    //    NSLog(@"find file %@ >>>>> %@", day, [NSThread currentThread]);
    if (lFindhandle) {
        do {
            HB_NET_FINDDATA findData;
            findData.dwSize = sizeof(HB_NET_FINDDATA);
            
            [deviceLock lock];
            lFindRet = HB_NET_FindNextFile(lFindhandle, &findData);
            [deviceLock unlock];
            
            if (lFindRet == HB_NET_FILE_SUCCESS) {
                NSString *fileString = [NSString stringWithFormat:@"%d-%d-%d-%d:%d >> %d:%d",findData.struStartTime.dwYear,findData.struStartTime.dwMonth, findData.struStartTime.dwDay, findData.struStartTime.dwHour, findData.struStartTime.dwMinute, findData.struStopTime.dwHour, findData.struStopTime.dwMinute];
                [fileList addObject:fileString];
            }
            [NSThread sleepForTimeInterval:0.01];
        }while (lFindRet == HB_NET_FILE_SUCCESS);
        [deviceLock lock];
        HB_NET_FindFileClose(lFindhandle);
        [deviceLock unlock];
        
        if (block) {
            block([NSError errorWithHbCode:ErrorSuccess], fileList);
        }
    } else {
        if (block) {
            block([MapErrorCode mapNetsdkError:HB_NET_GetLastError()], fileList);
        }
    }
    NSLog(@"find file end %@", day);
}


// 流媒体回放
- (void)smsPlayback:(Viewport *)view
{
    lSmsPlayback = [StreamMediaServer alloc];
    int nRet = [lSmsPlayback connectToSms:smsIP port:smsPort completeBlock:^(int type, NSData *data, long long llTimestamp, NSError *error) {
    }];
    if (nRet == SMS_OK) {
        self.viewport = view;
        NSDate *start = [NSDate dateWithTimeIntervalSinceNow: - 60 * 10];
        [lSmsPlayback startPlayback:serialNO channel:0 videoType:2 startTime:start stopTime:nil streamCallback:^(int type, NSData *data, long long llTimestamp, NSError *error) {
            if (error && [error code] != ErrorSuccess)
            {
                // 回放失败
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    lSmsHandle = nil;
                });
            } else {
                // 回放成功
            }
            // 数据回调
            [self playData:[data bytes] length:[data length] type:type timestamp:llTimestamp];
        }];
    }
}

static void playbackStreamCallback(long lRealHandle, LPHB_NET_STREAMCALLBACKDATA pStreamData)
{
    Device *playback = (__bridge Device *)pStreamData->pContext;
    
    if (playback) {
        [playback playData:pStreamData->pFrame length:pStreamData->dwDataSize type:0 timestamp:0];
    }
    
    return;
}

- (void)playbackByChannel:(int)index andView:(Viewport *)view from:(NSDate *)start completedCallback:(StartPreviewBlock)block {
    
    NSError *error = [NSError errorWithHbCode:ErrorUnknown];
    
    self.viewport = view;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *startCompontents = [calendar components:(kCFCalendarUnitYear|kCFCalendarUnitMonth|kCFCalendarUnitDay|kCFCalendarUnitHour|kCFCalendarUnitMinute|kCFCalendarUnitSecond) fromDate:start];
    HB_NET_VODCOND vodCond;
    memset(&vodCond, 0, sizeof(vodCond));
    vodCond.dwSize = sizeof(HB_NET_VODCOND);
    vodCond.dwChannel = index;
    vodCond.dwType = HB_NET_REC_ALL;
    vodCond.dwLoadMode=1;
    vodCond.mode.byTime.struStartTime.dwYear    = (int)[startCompontents year];
    vodCond.mode.byTime.struStartTime.dwMonth   = (int)[startCompontents month];
    vodCond.mode.byTime.struStartTime.dwDay     = (int)[startCompontents day];
    vodCond.mode.byTime.struStartTime.dwHour    = (int)[startCompontents hour];
    vodCond.mode.byTime.struStartTime.dwMinute  = (int)[startCompontents minute];
    vodCond.mode.byTime.struStartTime.dwSecond  = (int)[startCompontents second];
    
    vodCond.mode.byTime.struStopTime.dwYear     = (int)[startCompontents year];
    vodCond.mode.byTime.struStopTime.dwMonth    = (int)[startCompontents month];
    vodCond.mode.byTime.struStopTime.dwDay      = (int)[startCompontents day];
    vodCond.mode.byTime.struStopTime.dwHour     = 23;
    vodCond.mode.byTime.struStopTime.dwMinute   = 59;
    vodCond.mode.byTime.struStopTime.dwSecond   = 59;
    NSLog(@"play back >>>>> %d %d", vodCond.mode.byTime.struStartTime.dwHour, vodCond.mode.byTime.struStartTime.dwMinute);
    __weak Device *weakself = self;
    vodCond.pContext=(__bridge void *)(weakself);
    vodCond.pfnDataProc = (PHB_NET_STREAMDATA_PROC)playbackStreamCallback;
    
    [deviceLock lock];
    lPlaybackHandle = HB_NET_Vod(lUserID, &vodCond);
    [deviceLock unlock];
    
    // 先尝试使用vod模式，不支持再尝试老协议
    if (lPlaybackHandle) {
        
        playbackType = PlaybackTypeVod;
        error = [NSError errorWithHbCode:ErrorSuccess];
        
    } else {
        
        HB_NET_PLAYBACKCOND playbackCond;
        playbackCond.dwChannel = index;
        playbackCond.dwSize = sizeof(playbackCond);
        playbackCond.dwType = HB_NET_REC_ALL;
        __weak Device *weakself = self;
        playbackCond.pContext = (__bridge void *)weakself;
        playbackCond.pfnDataProc = (PHB_NET_STREAMDATA_PROC)playbackStreamCallback;
        playbackCond.struStartTime.dwYear    = (int)[startCompontents year];
        playbackCond.struStartTime.dwMonth   = (int)[startCompontents month];
        playbackCond.struStartTime.dwDay     = (int)[startCompontents day];
        playbackCond.struStartTime.dwHour    = (int)[startCompontents hour];
        playbackCond.struStartTime.dwMinute  = (int)[startCompontents minute];
        playbackCond.struStartTime.dwSecond  = (int)[startCompontents second];
        
        playbackCond.struStopTime.dwYear     = (int)[startCompontents year];
        playbackCond.struStopTime.dwMonth    = (int)[startCompontents month];
        playbackCond.struStopTime.dwDay      = (int)[startCompontents day];
        playbackCond.struStopTime.dwHour     = 23;
        playbackCond.struStopTime.dwMinute   = 59;
        playbackCond.struStopTime.dwSecond   = 59;
        
        [deviceLock lock];
        lPlaybackHandle = HB_NET_PlayBack(lUserID, &playbackCond);
        [deviceLock unlock];
        
        if (lPlaybackHandle) {
            
            playbackType = PlaybackTypeOld;
            error = [NSError errorWithHbCode:ErrorSuccess];
            
        } else {
            
            error = [MapErrorCode mapNetsdkError:HB_NET_GetLastError()];
        }
    }
    
    if (block) {
        
        block (error,0,0);
    }
    
    if ([error code] == ErrorSuccess) {
        
        [self getFrame:RequestLargeData];
        requestDataTimer = [NSTimer timerWithTimeInterval:RequestDataPeriod target:self selector:@selector(requestFrame) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:requestDataTimer forMode:NSDefaultRunLoopMode];
        
    } else {
        
        if (block) {
            block(error, 0, 0);
        }
    }
    NSLog(@"play back >>>>> %d %d >>>>>> return %ld", vodCond.mode.byTime.struStartTime.dwHour, vodCond.mode.byTime.struStartTime.dwMinute, (long)[error code]);
}


- (void)requestFrame
{
    int requestCount = self.requestDataCount;
    if (requestCount) {
        __weak typeof(self) weakself = self;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            __strong typeof(weakself) strongself = weakself;
            [strongself getFrame:requestCount];
        });
    }
}

- (void)getFrame:(int)frameCount
{
    if (playbackType == PlaybackTypeVod) {
        
        HB_NET_VodGetFrame(lPlaybackHandle, frameCount, 0);
    }
}

- (void)stopPlayback {
    
    // 先关闭网络数据数据接收，再关解码
    [self.requestDataTimer invalidate];
    self.requestDataTimer = nil;

    if (lSmsPlayback) {
        lSmsPlayback = nil;
    }
    if (lPlaybackHandle) {
        if (playbackType == PlaybackTypeOld) {
            HB_NET_StopPlayBack(lPlaybackHandle);
        } else {
            HB_NET_StopVod(lPlaybackHandle);
        }
        lPlaybackHandle = NULL;
    }
    player = nil;
}

- (NSString *)getDeviceSerialNO
{
    HB_NET_NETCFG netCfg;
    HB_NET_GETDEVCONFIG devCfg;
    memset(&devCfg, 0, sizeof(devCfg));
    netCfg.dwSize = sizeof(netCfg);
    devCfg.dwCommand = HB_NET_GET_NETCFG;
    devCfg.dwOutBufSize = netCfg.dwSize;
    devCfg.dwSize = sizeof(HB_NET_GETDEVCONFIG);
    devCfg.pOutBuffer = &netCfg;
    [deviceLock lock];
    BOOL bGet = HB_NET_GetDevConfig(lUserID, &devCfg);
    [deviceLock unlock];
    if(bGet)
    {
        unsigned char aa= netCfg.struEtherNet[0].byMACAddr[2];
        unsigned char bb= netCfg.struEtherNet[0].byMACAddr[3];
        unsigned char cc= netCfg.struEtherNet[0].byMACAddr[4];
        unsigned char dd= netCfg.struEtherNet[0].byMACAddr[5];
        NSLog(@"mac %@", [NSString stringWithFormat:@"%02x%02x%02x%02x",aa,bb,cc,dd]);
        return [NSString stringWithFormat:@"%02x%02x%02x%02x",aa,bb,cc,dd];
    }
    NSLog(@"get net cfg fail");
    return nil;
}

// 设备添加
// 无序列号－－－域名或ip，局域网扫描获取局域网IP，先登录设备，获取设备序列号
// 通过序列号查询设备信息，如可添加则添加设备至账号

@end
