//
//  YdtUserInfo.h
//  YdtNetSdkV2
//
//  Created by sun lin on 16/4/19.
//  Copyright © 2016年 hbzh. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  一点通用户信息类
 */
@interface YdtUserInfo : NSObject
//错误码，当errorCode ＝ 0时，其他参数才有效
@property (nonatomic) int errorCode;

//用户ID
@property (nonatomic, copy) NSString *userId;

//用户名
@property (nonatomic, copy) NSString *userName;

//昵称
@property (nonatomic, copy) NSString *nickName;

//绑定的手机号
@property (nonatomic, copy) NSString *phoneNumber;

//绑定的邮箱
@property (nonatomic, copy) NSString *email;

//是否设置过密码
@property (nonatomic) BOOL isSetPassword;

@end


@interface YdtDeviceInfo : NSObject
//错误码
@property (nonatomic) int errorCode;

//设备绑定者账户名
@property (copy, nonatomic) NSString *ownerAccountName;

//设备绑定者手机号
@property (copy, nonatomic) NSString *ownerAccountPhone;

//设备绑定者邮箱
@property (copy, nonatomic) NSString *ownerAccountEmail;

//设备列表，存储的是YdtDeviceParam对象
@property (nonatomic, strong) NSMutableArray *deviceArray;
@end


/**
 *  设备参数信息
 */
@interface YdtDeviceParam : NSObject
//设备ID
@property (copy, nonatomic) NSString *deviceId;

//设备名称
@property (copy, nonatomic) NSString *deviceName;

//设备序列号
@property (copy, nonatomic) NSString *deviceSn;

//虚拟网络类型
//VV:威威
//GN:金万维
@property (copy, nonatomic) NSString *deviceNetType;

//当deviceNetType ＝ VV时，表示VveyeId
//当deviceNetType ＝ GN时，表示GNIp
@property (copy, nonatomic) NSString *deviceVNIp;

//当deviceNetType ＝ VV时，表示VveyeRemotePort
//当deviceNetType ＝ GN时，表示GNPort
@property (nonatomic) int deviceVNPort;

//设备用户名
@property (copy, nonatomic) NSString *deviceUser;

//设备密码
@property (copy, nonatomic) NSString *devicePassword;

//域名
@property (copy, nonatomic) NSString *deviceDomain;

//域名映射端口
@property (nonatomic) int deviceDomainPort;

//设备流媒体Ip
@property (copy, nonatomic) NSString *deviceStreamIp;

//设备的流媒体端口
@property (nonatomic) int deviceStreamPort;

//设备通道数
@property (nonatomic) int deviceChannelCount;

//设备分享类型
@property (nonatomic) int deviceShareType;

//设备所有者ID
@property (copy, nonatomic) NSString *deviceOwnerId;

//设备所有者名称
@property (copy, nonatomic) NSString *deviceOwnerName;

//设备所在省
@property (copy, nonatomic) NSString *deviceInProvince;

//设备所在城市
@property (copy, nonatomic) NSString *deviceInCity;

//设备所在经度
@property (copy, nonatomic) NSString *deviceLongitude;

//设备所在纬度
@property (copy, nonatomic) NSString *deviceLatitude;

@end


@interface YdtSmsServerInfo : NSObject
//
@property (nonatomic) int errorCode;

//
@property (copy, nonatomic) NSString *smsServerIp;

//
@property (nonatomic) int smsServerPort;

//
@property (nonatomic) int deviceStatus;

@end


@interface YdtVervificationCodeInfo : NSObject
//错误码
@property (nonatomic) int errorCode;

//验证码发往地址类型， 0 － 未知， 1 － 手机， 2 － 邮箱
@property (nonatomic) int addressType;

@end


@interface YdtAlarmInfo : NSObject
//错误码
@property (nonatomic) int errorCode;

//报警信息列表，存储的是YdtAlarmParam对象
@property (nonatomic, strong) NSArray *alarmArray;


@end


@interface YdtAlarmParam : NSObject
//报警信息JSON串
@property (copy, nonatomic) NSString *alarmJson;

//报警ID
@property (copy, nonatomic) NSString *alarmId;

//报警类型
@property (copy, nonatomic) NSString *alarmType;

//报警级别
@property (copy, nonatomic) NSString *alarmLevel;

//报警时间
@property (nonatomic) long alarmTime;

//报警上传时间
@property (nonatomic) long alarmUpTime;

//报警内容
@property (copy, nonatomic) NSString *alarmContent;

//报警设备序列号
@property (copy, nonatomic) NSString *deviceSn;

//报警设备地址
@property (copy, nonatomic) NSString *deviceIp;

//报警设备类型
@property (copy, nonatomic) NSString *deviceType;

//报警通道
@property (copy, nonatomic) NSString *channel;

//录像开始时间
@property (nonatomic) long recordBeginTime;

//录像结束时间
@property (nonatomic) long recordEndTime;

//录像下载地址
@property (copy, nonatomic) NSString *recordDownloadUrl;

//报警图片列表
@property (strong, nonatomic) NSMutableArray *pictureArray;

@end


@interface YdtAlarmPicutreParam : NSObject
//图片下载地址
@property (copy, nonatomic) NSString *downloadUrl;

//校验码
@property (copy, nonatomic) NSString *md5Code;

//图片大小，单位：字节
@property (nonatomic) int pictureSize;

@end


@interface PlatformDeviceInfo : NSObject

//错误码
@property (nonatomic) int errorCode;

//设备链表
@property (nonatomic, strong) NSMutableArray *deviceArray;

@end


@interface PlatformDeviceParam : NSObject

//平台分配的设备ID
@property (nonatomic, copy) NSString *deviceId;

//设备名称
@property (nonatomic, copy) NSString *deviceName;

//设备描述
@property (nonatomic, copy) NSString *deviceDesc;

//区域名称
@property (nonatomic, copy) NSString *regionName;

//通道数
@property (nonatomic) int channelCount;

//内网地址
@property (nonatomic, copy) NSString *lanAddress;

//内网端口
@property (nonatomic) int lanPort;

//外网地址
@property (nonatomic, copy) NSString *wanAddress;

//外网端口
@property (nonatomic) int wanPort;

//设备的用户名（针对平台）
@property (nonatomic, copy) NSString *deviceUser;

//设备的密码（针对平台）
@property (nonatomic, copy) NSString *devicePassword;

//设备的MAC地址
@property (nonatomic, copy) NSString *deviceMac;

//设备序列号
@property (nonatomic, copy) NSString *deviceSn;

//在线状态， 1 － 在线， 0 － 不在线
@property (nonatomic) int onlineState;

@end


