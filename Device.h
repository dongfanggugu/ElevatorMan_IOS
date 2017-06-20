//
//  Device.h
//  hbydtSDKDemo
//
//  Created by wangzhen on 16/4/14.
//  Copyright © 2016年 wangzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DeviceLoginType) {
    lanIPLogin,
    vvLogin,
    domainLogin,
    smsLogin,
};

typedef void (^StartPreviewBlock)(NSError *error, int width, int height);

@class Viewport;

@interface Device : NSObject

// 设备序列号
@property (strong, nonatomic) NSString *serialNO;

@property (strong, nonatomic) NSString *userName;

@property (strong, nonatomic) NSString *password;

// 设备IP
@property (strong, nonatomic) NSString *lanIP;

@property (nonatomic) int lanPort;

// vvid
@property (strong, nonatomic) NSString *vveyeID;

@property (nonatomic) int vveyeRemotePort;

@property (nonatomic) int vveyeLocalPort;

@property (strong, nonatomic) NSString *domain;

// 端口
@property (nonatomic) int domainPort;

@property (strong, nonatomic) NSString *deviceID;

@property (nonatomic, assign) DeviceLoginType deviceLoginType;

@property (nonatomic, assign) BOOL isLogin;

// 设备登录
- (void)loginWithBlick:(void(^)(BOOL loginStatus))block;

//ip登录，获取设备序列号
- (NSString *)getDeviceSerialNO;

- (void)logout;

// 设备预览
- (void)realplay:(Viewport *)view completedHandle:(void(^)(NSError *error))block;

- (void)smsRealplay:(Viewport *)view;

- (void)stopRealplay;

- (void)smsPlayback:(Viewport *)view;

// 设备回放
- (void)playback:(Viewport *)view;

- (void)stopPlayback;

- (void)findRecordFileByChannel:(int)channelIndx atDay:(NSDate *)day completedHandle:(void (^)(NSError *error, NSArray *filesList))block;

- (void)playbackByChannel:(int)index andView:(Viewport *)view from:(NSDate *)start completedCallback:(StartPreviewBlock)block;
@end
