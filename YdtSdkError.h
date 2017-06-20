//
//  YdtSdkError.h
//  YdtNetSdkV2
//
//  Created by sun lin on 16/4/19.
//  Copyright © 2016年 hbzh. All rights reserved.
//

#ifndef YdtSdkError_h
#define YdtSdkError_h

NS_ENUM(NSInteger){
    //成功
    YdtErrorSuccess                 = 0,
    
    //未知错误
    YdtErrorUnknow                  = -1500,
    
    //参数错误
    YdtErrorInvalidParam            = -1501,
    
    //网络异常
    YdtErrorBadNetwork              = -1502,
    
    //解析XML失败
    YdtErrorParseXmlFailed          = -1503,
    
    //未登录
    YdtErrorNotLogin                = -1504,
    
    //未初始化
    YdtErrorUninitialized           = -1505,
    
    //序列号不匹配
    YdtErrorDismatchSn              = -1506,
    
    /**
     * 账户相关错误码
     */
    //未知错误
    YdtAccountErrorUnknown          = -1000,
    
    //账户不存在
    YdtAccountErrorNotExist         = -1001,
    
    //账户名为空或非法
    YdtAccountErrorWrongName        = -1002,
    
    //手机号为空或非法
    YdtAccountErrorWrongPhone       = -1003,
    
    //邮箱为空或非法
    YdtAccountErrorWrongEmail       = -1004,
    
    //用户ID为空或非法
    YdtAccountErrorWrongUserId           = -1005,
    
    //用户密码为空或非法
    YdtAccountErrorWrongPassword         = -1006,
    
    //参数格式非法
    YdtAccountErrorWrongParamter         = -1007,
    
    //用户名已注册
    YdtAccountErrorNameAlreadyRegistered = -1008,
    
    //手机号已注册
    YdtAccountErrorPhoneAlreadyRegistered= -1009,
    
    //邮箱已注册
    YdtAccountErrorEmailAlreadyRegistered= -1010,
    
    //创建用户ID失败
    YdtAccountErrorCreateUserIdFailed    = -1011,
    
    //查找用户表失败
    YdtAccountErrorSearchTableFailed     = -1012,
    
    //更新用户表失败
    YdtAccountErrorUpdateTableFailed     = -1013,
    
    //插入用户表失败
    YdtAccountErrorInsertTableFailed     = -1014,
    
    //删除用户表失败
    YdtAccountErrorDeleteTableFailed     = -1015,
    
    //密码加密失败
    YdtAccountErrorEncryptPasswordFailed = -1016,
    
    //用户名、密码不匹配
    YdtAccountErrorDismatchPassword      = -1017,
    
    //非法的唯一性标识字段
    YdtAccountErrorWrongKeyword          = -1018,
    
    /**
     * 设备相关错误码
     */
    //未知错误
    YdtDeviceErrorUnknown               = -2000,
    
    //未找到设备（设备未注册）
    YdtDeviceErrorNotFind               = -2001,
    
    //序列号为空或非法
    YdtDeviceErrorWrongSn               = -2002,
    
    //非法的设备注册类型
    YdtDeviceErrorWrongResisterType     = -2003,
    
    //一点通盒子序列号为空或非法
    YdtDeviceErrorWrongBoxSn            = -2004,
    
    //设备ID为空或非法
    YdtDeviceErrorWrongDeviceId         = -2005,
    
    //创建设备ID失败
    YdtDeviceErrorCreateDeviceIdFailed  = -2006,
    
    //查询设备表失败
    YdtDeviceErrorSearchTableFailed     = -2007,
    
    //插入设备表失败
    YdtDeviceErrorInsertTableFailed     = -2008,
    
    //更新设备表失败
    YdtDeviceErrorUpdateTableFailed     = -2009,
    
    //删除设备表失败
    YdtDeviceErrorDeleteTabeFailed      = -2010,
    
    //设备查找错误
    YdtDeviceErrorDeviceFindError       = -2011,
    
    //获取空闲虚拟网络令牌（GN或VV）失败
    YdtDeviceErrorNoValidGnOrVvid       = -2012,
    
    //设备已绑定到用户
    YdtDeviceErrorDeviceHasOwner        = -2013,
    
    //设备已绑定到一点通盒子
    YdtDeviceErrorBoundToYdtBox         = -2014,
    
    //绑定到用户失败
    YdtDeviceErrorBoundToUserFailed     = -2015,
    
    //一点通盒子还没有获取到令牌
    YdtDeviceErrorYdtBoxHasNoToken      = -2018,
    
    //对设备的操作不是其所有者执行
    YdtDeviceErrorNotOperatedByOwner    = -2019,
    
    //设备解绑失败
    YdtDeviceErrorUnboundFailed         = -2020,
    
    //删除设备主记录失败
    YdtDeviceErrorDeleteMasterRecordFailed = -2021,
    
    //设备ID为空或非法
    YdtDeviceErrorWrongDeviceId2        = -2022,
    
    //获取设备地理位置失败
    YdtDeviceErrorGetLocationFailed     = -2043,
    
    /**
     *  流媒体相关
     */
    //未知错误
    YdtSmsErrorUnknown                  = -3000,
    
    //未找到流媒体主机
    YdtSmsErrorNotFindHost              = -3001,
    
    //主机IP为空或非法
    YdtSmsErrorWrongHostIp              = -3002,
    
    //主机端口为空或非法
    YdtSmsErrorWronfHostPort            = -3003,
    
    //主机所有者ID为空或非大于0数字
    YdtSmsErrorWrongHostUserId          = -3004,
    
    //设备ID为空或非法
    YdtSmsErrorWrongDeviceId            = -3005,
    
    //推送设备时未找到目标主机
    YdtSmsErrorNotFindTargetHost        = -3006,
    
    //从主机获取设备列表时返回XML为空
    YdtSmsErrorEmptyDeviceListXML       = -3007,
    
    //从主机获取设备列表时解析XML失败
    YdtSmsErrorParseDeviceListXml       = -3008,
    
    //主机无法连接
    YdtSmsErrorUnreachableHost          = -3009,
    
    //主机无响应
    YdtSmsErrorHostNoResponse           = -3010,
    
    //从主机获取主机模块数据时解析XML失败
    YdtSmsErrorParseHostDataFailed      = -3011,
    
    //向主机推送设备失败
    YdtSmsErrorPushDeviceFailed         = -3012,
    
    //向主机推送设备时，主机无响应
    YdtSmsErrorPushDeviceNoResponse     = -3013,
    
    //不允许向主机推送VV设备
    YdtSmsErrorPushDeviceNotSupport     = -3017,
    
    /**
     * 短信及验证码相关错误
     */
    //未知错误
    YdtAuthcodeErrorUnknown             = -4000,
    
    //在系统中未找到已保存的所要求的验证码（即验证码失效）
    YdtAuthcodeErrorNotFindAuthcode     = -4001,
    
    //用户提交的验证码跟系统保存的验证码不匹配
    YdtAuthcodeErrorDismatchAuthcode    = -4003,
    
    //错误的验证码发送目标类型，正常为手机短信或邮件
    YdtAuthcodeErrorWrongAddressType    = -4004,
    
    //验证码请求太频繁
    YdtAuthcodeErrorTooOften            = -4005,
    
    //验证码发送到短信失败
    YdtAuthcodeErrorSendtoMobileFailed  = -4006,
    
    //验证码发送到邮箱失败
    YdtAuthcodeErrorSendtoEmailFailed   = -4007,
    
    /**
     * 客户端访问相关
     */
    //未知错误
    YdtAccessErrorUnknown               = -5000,
    
    //Token失效
    YdtAccessErrorInvalidToken          = -5001,
    
    //参数非法
    YdtAccessErrorIllegalParam          = -5003,
    
    //访问令牌与服务器端不一致，例如可能被踢下
    YdtAccessErrorDismatchToken         = -5021,
    
    /**
     * 报警相关
     */
    //授权错误
    YdtAlarmErrorNoPermission           = -10001,
    
    //系统错误
    YdtAlarmErrorSystemError            = -10002,
    
    //Token失效
    YdtAlarmErrorInvalidToken           = -10003,
    
    //设备不支持报警功能
    YdtAlarmErrorDeviceNotSupport       = -10101,
    
    /**
     *  开发者相关
     */
    //应用还未注册
    YdtDeveloperErrorAppUnregister      = -11019,
    
    //应用被冻结
    YdtDeveloperErrorAppFrozen          = -11020,
    
    //签名校验失败
    YdtDeveloperErrorSignError          = -11021,
};


/*
 * 设备分享类型
 */
typedef NS_ENUM(NSInteger, DeviceShareType){
    //用户自有设备
    DeviceShareTypeOwner = 0,
    
    //别人分享过来的设备
    DeviceShareTypeShared,
    
    //公共演示设备
    DeviceShareTypePublic,
};


/**
 *  流媒体设备在线状态
 */
typedef NS_ENUM(NSInteger, DeviceStatusInSms) {
    //在线
    DeviceStatusInSmsOnline = 0,
    
    //未知错误
    DeviceStatusInSmsUnknown = -1,
    
    //登录错误
    DeviceStatusInSmsLoginError = -2,
    
    //网络错误
    DeviceStatusInSmsNetError = -3,
};


/**
 *  绑定状态
 */
typedef NS_ENUM(NSInteger, AlarmBindFlag) {
    //禁止报警上传
    AlarmBindFlagDisableAlarmUpload = -1,
    
    //解绑
    AlarmBindFlagUnbunding,
    
    //绑定
    AlarmBindFlagBinding,
};


#endif /* YdtSdkError_h */
