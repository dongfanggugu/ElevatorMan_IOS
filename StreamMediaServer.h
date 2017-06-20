//
//  StreamMediaServer.h
//  testPod
//
//  Created by wangzhen on 15-4-8.
//  Copyright (c) 2015年 wangzhen. All rights reserved.
//

#import "GCDAsyncSocket.h"

#define Yuntai_Up           1
#define Yuntai_Down         2
#define Yuntai_Left         3
#define Yuntai_Right        4
#define Yuntai_Left_Up      5
#define Yuntai_Left_Down    6
#define Yuntai_Right_Up     7
#define Yuntai_Right_Down   8
#define Aperture_Reduce     9
#define Aperture_Plus       10
#define Focus_Reduce        11
#define Focus_Plus          12
#define Zoom_Tele           13
#define Zoom_Wide           14
#define Set_Reserved        15 //设置预置位
#define Call_Reserved       16 //调用预置位
#define AssistantId         17
#define StopPTZ             18
#define Ptz_Auto            19//自动

#define Up_Stop             20
#define Left_Stop           21
#define Down_Stop           22
#define Right_Stop          23
#define ApertureReduce_Stop 24
#define AperturePlus_Stop   25
#define FocusReduce_Stop    26
#define FocusPlus_Stop      27
#define ZoomTele_Stop       28
#define ZoomWide_Stop       29
#define Auto_Scan           30

#define TILT_UP             0x0001000c /* 云台以SS的速度上仰 */
#define TILT_DOWN           0x0001000d /* 云台以SS的速度下俯 */
#define PAN_LEFT            0x0001000e /* 云台以SS的速度左转 */
#define PAN_RIGHT           0x0001000f /* 云台以SS的速度右转 */
#define TILT_LEFT_UP        0x00010010 /* 云台以dwSpeed的速度左上 */
#define TILT_LEFT_DOWN      0x00010011 /* 云台以dwSpeed的速度左下 */
#define TILT_RIGHT_UP       0x00010012 /* 云台以dwSpeed的速度右上 */
#define TILT_RIGHT_DOWN     0x00010013 /* 云台以dwSpeed的速度右下 */
#define FOCUS_NEAR          0x00010014 /* 焦点以速度SS前调 */
#define FOCUS_FAR           0x00010015 /* 焦点以速度SS后调 */
#define ALL_STOP            0x00010028// 停止前一命令

#define SMS_ERROR(code) (1<<31 | 'S'<<24 | 'M' << 16 | code)
#define SMS_OK					0
#define	SMS_ERR_GENERIC			SMS_ERROR(0x1)	//一般错误
#define SMS_ERR_TIMEOUT			SMS_ERROR(0x2)	// 超时
#define SMS_ERR_MEMORY			SMS_ERROR(0x3)	// 内存错误

typedef void (^StreamBlock)(int type, NSData *data, long long llTimestamp, NSError *error);

@interface StreamMediaServer : NSObject

- (int)connectToSms:(NSString *)address port:(int)port completeBlock:(StreamBlock)block;
- (void)getInfoWithDeviceName:(NSString *)devName deviceID:(NSString *)devID completeBlock:(StreamBlock)block;
- (int)startPlay:(NSString *)devName channel:(int)nChannel streamType:(int)nStreamType streamCallback:(StreamBlock)block;
- (int)PTZControl:(int)nPTZCmd speed:(int)nSpeed;

- (int)startPlayback:(NSString *)devName channel:(int)nChannel videoType:(int)nType startTime:(NSDate *)start stopTime:(NSDate *)stop streamCallback:(StreamBlock)block;

- (void)findRecordFileByDevice:(NSString *)devName Channel:(int)nChannel videoType:(int)nType atDay:(NSDate *)day completedHandle:(StreamBlock)block;

@end
