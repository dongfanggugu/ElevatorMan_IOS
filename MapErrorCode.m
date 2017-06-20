//
//  MapErrorCode.m
//  MyUI
//
//  Created by wangzhen on 15-6-25.
//  Copyright (c) 2015年 wangzhen. All rights reserved.
//

#import "MapErrorCode.h"
#import "HBNetSDK.h"
#import "NSError+HbError.h"

#define HBERRORDOMAN @"net.hbgk.hbydt.hbydtpro.hberror"
#define YDTERRORDOMAN @"net.hbgk.hbydt.hbydtpro.ydterror"

@implementation MapErrorCode

+ (NSError *)mapYdtError:(int)code
{
    NSString *errDescription = nil;
    switch (code) {
        case YdtErrorUnknow:                       // -1500      //未知错误
            errDescription = NSLocalizedString(@"HBYDT_ERROR_UNKNOWN", @"YdtError");
            break;
            
        case YdtErrorInvalidParam:                 // -1501      //参数错误
            errDescription = NSLocalizedString(@"HBYDT_ERROR_INVALID_PARAM", @"YdtError");
            break;
            
        case YdtErrorBadNetwork:                   // -1502      //网络异常
            errDescription = NSLocalizedString(@"HBYDT_ERROR_BAD_NETWORK", @"YdtError");
            break;
            
        case YdtErrorParseXmlFailed:              // -1503           //解析XML异常
            errDescription = NSLocalizedString(@"HBYDT_ERROR_PARSE_XML_FAILED", @"YdtError");
            break;
            
            //账户相关
        case YdtAccountErrorUnknown:                         //-1000			//未知错误
            errDescription = NSLocalizedString(@"HBYDT_ERR_ACCOUNT_UNKNOWN", @"YdtError");
            break;
            
        case YdtAccountErrorNotExist:                       // -1001			//未找到注册用户
            errDescription = NSLocalizedString(@"HBYDT_ERR_ACCOUNT_NOT_EXIST", @"YdtError");
            break;
            
        case YdtAccountErrorWrongName:                      // -1002			//用户名为空或者非法
            errDescription = NSLocalizedString(@"HBYDT_ERR_ACCOUNT_WRONG_NAME", @"YdtError");
            break;
            
        case YdtAccountErrorWrongPhone:                    //-1003			//手机号为空或非法
            errDescription = NSLocalizedString(@"HBYDT_ERR_ACCOUNT_WRONG_MOBILE", @"YdtError");
            break;
            
        case YdtAccountErrorWrongEmail:                     // -1004			//Email为空或非法
            errDescription = NSLocalizedString(@"HBYDT_ERR_ACCOUNT_WRONG_EMAIL", @"YdtError");
            break;
            
        case YdtAccountErrorWrongUserId:                    // -1005			//用户Id为空或非法
            errDescription = NSLocalizedString(@"HBYDT_ERR_ACCOUNT_WRONG_USERID", @"YdtError");
            break;
            
        case YdtAccountErrorWrongPassword:                  // -1006			//密码为空或非法
            errDescription = NSLocalizedString(@"HBYDT_ERR_ACCOUNT_WRONG_PASSWORD", @"YdtError");
            break;
            
        case YdtAccountErrorWrongParamter:                 // -1007			//参数格式非法
            errDescription = NSLocalizedString(@"HBYDT_ERR_ACCOUNT_WRONG_PARAMETER", @"YdtError");
            break;
            
        case YdtAccountErrorNameAlreadyRegistered:         // -1008			//用户名已注册
            errDescription = NSLocalizedString(@"HBYDT_ERR_ACCOUNT_NAME_ALREADY_REGISTERED", @"YdtError");
            break;
            
        case YdtAccountErrorPhoneAlreadyRegistered:       // -1009			//手机号已注册
            errDescription = NSLocalizedString(@"HBYDT_ERR_ACCOUNT_MOBILE_ALREADY_REGISTERED", @"YdtError");
            break;
            
        case YdtAccountErrorEmailAlreadyRegistered:        // -1010 			//邮箱已注册
            errDescription = NSLocalizedString(@"HBYDT_ERR_ACCOUNT_EMAIL_ALREADY_REGISTERED", @"YdtError");
            break;
            
        case YdtAccountErrorCreateUserIdFailed:            // -1011 			//创建用户Id失败
            errDescription = NSLocalizedString(@"HBYDT_ERR_ACCOUNT_CREATE_USERID_FAILED", @"YdtError");
            break;
            
        case YdtAccountErrorSearchTableFailed:             // -1012 			//查找用户表失败
            errDescription = NSLocalizedString(@"HBYDT_ERR_ACCOUNT_SEARCH_TABLE_FAILED", @"YdtError");
            break;
            
        case YdtAccountErrorUpdateTableFailed:             // -1013 			//更新用户表失败
            errDescription = NSLocalizedString(@"HBYDT_ERR_ACCOUNT_UPDATE_TABLE_FAILED", @"YdtError");
            break;
            
        case YdtAccountErrorInsertTableFailed:             // -1014 			//插入用户表失败
            errDescription = NSLocalizedString(@"HBYDT_ERR_ACCOUNT_INSERT_TABLE_FAILED", @"YdtError");
            break;
            
        case YdtAccountErrorDeleteTableFailed:             // -1015 			//删除用户表失败
            errDescription = NSLocalizedString(@"HBYDT_ERR_ACCOUNT_DELETE_TABLE_FAILED", @"YdtError");
            break;
            
        case YdtAccountErrorEncryptPasswordFailed:         // -1016 			//密码加密失败
            errDescription = NSLocalizedString(@"HBYDT_ERR_ACCOUNT_ENCRYPT_PASSWORD_FAILED", @"YdtError");
            break;
            
        case YdtAccountErrorDismatchPassword:          // -1017 			//用户名、密码不匹配
            errDescription = NSLocalizedString(@"HBYDT_ERR_ACCOUNT_NAME_DISMATCH_PASSWORD", @"YdtError");
            break;
            
        case YdtAccountErrorWrongKeyword:                   // -1018 			//非法的唯一性标识字段
            errDescription = NSLocalizedString(@"HBYDT_ERR_ACCOUNT_WRONG_KEYWORD", @"YdtError");
            break;
            
            //设备相关
        case YdtDeviceErrorUnknown:                          // -2000 			//未知错误
            errDescription = NSLocalizedString(@"HBYDT_ERR_DEVICE_UNKNOWN", @"YdtError");
            break;
            
        case YdtDeviceErrorNotFind:                         // -2001 			//未找到设备
            errDescription = NSLocalizedString(@"HBYDT_ERR_DEVICE_NOT_FIND", @"YdtError");
            break;
            
        case YdtDeviceErrorWrongSn:                         // -2002 			//序列号为空或非法
            errDescription = NSLocalizedString(@"HBYDT_ERR_DEVICE_WRONG_SN", @"YdtError");
            break;
            
        case YdtDeviceErrorWrongResisterType:              // -2003 			//非法的设备注册类型
            errDescription = NSLocalizedString(@"HBYDT_ERR_DEVICE_WRONG_REGISTER_TYPE", @"YdtError");
            break;
            
        case YdtDeviceErrorWrongBoxSn:                      // -2004 			//一点通盒子序列号为空或非法
            errDescription = NSLocalizedString(@"HBYDT_ERR_DEVICE_WRONG_BOXSN", @"YdtError");
            break;
            
        case YdtDeviceErrorWrongDeviceId:                  // -2005 			//设备Id为空或非法
            errDescription = NSLocalizedString(@"HBYDT_ERR_DEVICE_WRONG_DEVICE_ID", @"YdtError");
            break;
            
        case YdtDeviceErrorCreateDeviceIdFailed:          // -2006 			//创建设备ID失败
            errDescription = NSLocalizedString(@"HBYDT_ERR_DEVICE_CREATE_DEVICE_ID_FAILED", @"YdtError");
            break;
            
        case YdtDeviceErrorSearchTableFailed:              // -2007 			//查询设备表失败
            errDescription = NSLocalizedString(@"HBYDT_ERR_DEVICE_SEARCH_TABLE_FAILED", @"YdtError");
            break;
            
        case YdtDeviceErrorInsertTableFailed:              // -2008 			//插入设备表失败
            errDescription = NSLocalizedString(@"HBYDT_ERR_DEVICE_INSERT_TABLE_FAILED", @"YdtError");
            break;
            
        case YdtDeviceErrorUpdateTableFailed:              // -2009 			//更新设备表失败
            errDescription = NSLocalizedString(@"HBYDT_ERR_DEVICE_UPDATE_TABLE_FAILED", @"YdtError");
            break;
            
        case YdtDeviceErrorDeleteTabeFailed:              // -2010 			//删除设备表失败
            errDescription = NSLocalizedString(@"HBYDT_ERR_DEVICE_DELETE_TABLE_FAILED", @"YdtError");
            break;
            
        case YdtDeviceErrorDeviceFindError:                       // -2011 			//设备查找错误
            errDescription = NSLocalizedString(@"HBYDT_ERR_DEVICE_FIND_ERROR", @"YdtError");
            break;
            
        case YdtDeviceErrorNoValidGnOrVvid:              // -2012 			//获取空闲虚拟网令牌（GN或VV）失败
            errDescription = NSLocalizedString(@"HBYDT_ERR_DEVICE_NOT_FIND_IDLE_GN_VV", @"YdtError");
            break;
            
        case YdtDeviceErrorDeviceHasOwner:                        // -2013 			//设备已被绑定到用户
            errDescription = NSLocalizedString(@"HBYDT_ERR_DEVICE_HAS_OWNER", @"YdtError");
            break;
            
        case YdtDeviceErrorBoundToYdtBox:                  // -2014 			//设备已被绑定到一点通盒子
            errDescription = NSLocalizedString(@"HBYDT_ERR_DEVICE_BOUND_TO_YDTBOX", @"YdtError");
            break;
            
        case YdtDeviceErrorBoundToUserFailed:             // -2015 			//设备绑定到用户失败
            errDescription = NSLocalizedString(@"HBYDT_ERR_DEVICE_BOUND_TO_USER_FAILED", @"YdtError");
            break;
            
        case YdtDeviceErrorYdtBoxHasNoToken:              // -2018 			//一点通盒子还没有获取到令牌
            errDescription = NSLocalizedString(@"HBYDT_ERR_DEVICE_YDTBOX_HAS_NO_TOKEN", @"YdtError");
            break;
            
        case YdtDeviceErrorNotOperatedByOwner:            // -2019 			//对设备的操作不是由其所有者执行
            errDescription = NSLocalizedString(@"HBYDT_ERR_DEVICE_NOT_OPERATED_BY_OWNER", @"YdtError");
            break;
            
        case YdtDeviceErrorUnboundFailed:                   // -2020 			//设备解绑失败
            errDescription = NSLocalizedString(@"HBYDT_ERR_DEVICE_UNBOUND_FAILED", @"YdtError");
            break;
            
        case YdtDeviceErrorDeleteMasterRecordFailed:      // -2021 			//删除设备主记录失败
            errDescription = NSLocalizedString(@"HBYDT_ERR_DEVICE_DELETE_MASTER_RECORD_FAILED", @"YdtError");
            break;
            
            //流媒体相关
        case YdtSmsErrorUnknown:                             // -3000 			//未知错误
            errDescription = NSLocalizedString(@"HBYDT_ERR_SMS_UNKNOWN", @"YdtError");
            break;
            
        case YdtSmsErrorNotFindHost:                       // -3001 			//未找到流媒体主机
            errDescription = NSLocalizedString(@"HBYDT_ERR_SMS_NOT_FIND_HOST", @"YdtError");
            break;
            
        case YdtSmsErrorWrongHostIp:                       // -3002 			//主机IP为空或格式非法
            errDescription = NSLocalizedString(@"HBYDT_ERR_SMS_WRONG_HOST_IP", @"YdtError");
            break;
            
        case YdtSmsErrorWronfHostPort:                     // -3003 			//主机端口为空或格式非法
            errDescription = NSLocalizedString(@"HBYDT_ERR_SMS_WRONG_HOST_PORT", @"YdtError");
            break;
            
        case YdtSmsErrorWrongHostUserId:                   // -3004 			//主机的所有者ID为空或非大于0数字
            errDescription = NSLocalizedString(@"HBYDT_ERR_SMS_WRONG_HOST_USERID", @"YdtError");
            break;
            
        case YdtSmsErrorWrongDeviceId:                      // -3005 			//设备ID未空或非大于0数字
            errDescription = NSLocalizedString(@"HBYDT_ERR_SMS_WRONG_DEVICEID", @"YdtError");
            break;
            
        case YdtSmsErrorNotFindTargetHost:                // -3006 			//推送设备时未找到目标主机
            errDescription = NSLocalizedString(@"HBYDT_ERR_SMS_NOT_FIND_TARGET_HOST", @"YdtError");
            break;
            
        case YdtSmsErrorEmptyDeviceListXML:                // -3007 			//从主机获取设备列表时返回XML为空
            errDescription = NSLocalizedString(@"HBYDT_ERR_SMS_EMPTY_DEVICELIST_XML", @"YdtError");
            break;
            
        case YdtSmsErrorParseDeviceListXml:         // -3008 			//从主机获取设备列表时解析XML失败
            errDescription = NSLocalizedString(@"HBYDT_ERR_SMS_PARSE_DEVICELIST_XML_FAILED", @"YdtError");
            break;
            
        case YdtSmsErrorUnreachableHost:                    // -3009 			//主机无法连接
            errDescription = NSLocalizedString(@"HBYDT_ERR_SMS_UNREACHABLE_HOST", @"YdtError");
            break;
            
        case YdtSmsErrorHostNoResponse:                    // -3010 			//主机无回复
            errDescription = NSLocalizedString(@"HBYDT_ERR_SMS_HOST_NO_RESPONSE", @"YdtError");
            break;
            
        case YdtSmsErrorParseHostDataFailed:               // -3011 			//从主机获取主机模块数据时解析XML失败
            errDescription = NSLocalizedString(@"HBYDT_ERR_SMS_PARSE_HOSTDATA_FAILED", @"YdtError");
            break;
            
        case YdtSmsErrorPushDeviceFailed:                  // -3012 			//向主机推送设备失败
            errDescription = NSLocalizedString(@"HBYDT_ERR_SMS_PUSH_DEVICE_FAILED", @"YdtError");
            break;
            
        case YdtSmsErrorPushDeviceNoResponse:             // -3013 			//向主机推送设备时，主机无回复
            errDescription = NSLocalizedString(@"HBYDT_ERR_SMS_PUSH_DEVICE_NO_RESPONSE", @"YdtError");
            break;
            
        case YdtSmsErrorPushDeviceNotSupport:             // -3017			//不允许向主机推送VV设备
            errDescription = NSLocalizedString(@"HBYDT_ERR_SMS_PUSH_DEVICE_NOT_SUPPORT", @"YdtError");
            break;
            
        case YdtErrorDismatchSn:					// -3018			//没有可用的（开启、连接正常、负载正常）主机
            errDescription = NSLocalizedString(@"HBYDT_ERR_SMS_NO_AVAILABLE_HOST", @"YdtError");
            break;
            
            //短信及验证码相关
        case YdtAuthcodeErrorUnknown:                        // -4000 			//未知错误
            errDescription = NSLocalizedString(@"HBYDT_ERR_AUTHCODE_UNKNOWN", @"YdtError");
            break;
            
        case YdtAuthcodeErrorDismatchAuthcode:                       // -4003 			//用户提交的验证码与系统保存的对应验证码不匹配
            errDescription = NSLocalizedString(@"HBYDT_ERR_AUTHCODE_DISMATCH", @"YdtError");
            break;
            
        case YdtAuthcodeErrorWrongAddressType:             // -4004 			//错误的验证码发送目标类型，正常为手机短信或邮件。
            errDescription = NSLocalizedString(@"HBYDT_ERR_AUTHCODE_WRONG_ADDRESS_TYPE", @"YdtError");
            break;
            
        case YdtAuthcodeErrorTooOften:                      // -4005 			//验证码请求的太频繁
            errDescription = NSLocalizedString(@"HBYDT_ERR_AUTHCODE_TOO_OFTEN", @"YdtError");
            break;
            
        case YdtAuthcodeErrorSendtoMobileFailed:          // -4006 			//验证码发送到短信失败
            errDescription = NSLocalizedString(@"HBYDT_ERR_AUTHCODE_SEND_TO_MOBILE_FAILED", @"YdtError");
            break;
            
        case YdtAuthcodeErrorSendtoEmailFailed:           // -4007 			//验证码发送到邮箱失败
            errDescription = NSLocalizedString(@"HBYDT_ERR_AUTHCODE_SEND_TO_EMAIL_FAILED", @"YdtError");
            break;
            
            //客户端访问相关
        case YdtAccessErrorUnknown:                          // -5000 			//未知错误
            errDescription = NSLocalizedString(@"HBYDT_ERR_ACCESS_UNKNOWN", @"YdtError");
            break;
            
        case YdtAccessErrorInvalidToken:                    // -5001 			//Token失效
            errDescription = NSLocalizedString(@"HBYDT_ERR_ACCESS_INVALID_TOKEN", @"YdtError");
            break;
            
        default:
            errDescription = NSLocalizedString(@"HBYDT_ERROR_UNKNOWN", @"YdtError");
            break;
    }
    NSDictionary *userInfo = nil;
    
    if (errDescription) {
        userInfo = @{
                     NSLocalizedDescriptionKey: errDescription
                     };
    }
    NSError *error =[NSError errorWithDomain:YDTERRORDOMAN code:code userInfo:userInfo];
    return error;
}

+ (NSError *)mapYdtError:(int)code description:(NSString *)description
{
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey:description
                               };
    
    NSError *error =[NSError errorWithDomain:YDTERRORDOMAN code:code userInfo:userInfo];
    return error;
}

+ (NSError *)mapNetsdkError:(int)code
{
    NSString *errDescription = nil;
    switch (code) {
        case HB_NET_NOERROR:
            errDescription = NSLocalizedString(@"HB_NET_NOERROR", @"NetSdkError");         // 没有错误
            break;
        case HB_NET_PASSWORD_ERROR:
            errDescription = NSLocalizedString(@"HB_NET_PASSWORD_ERROR", @"NetSdkError");  // 用户名密码错误
            code = ErrorWrongPassword;
            break;
        case HB_NET_NOENOUGHPRI:
            errDescription = NSLocalizedString(@"HB_NET_NOENOUGHPRI", @"NetSdkError");     // 权限不足
            code = ErrorNOPermission;
            break;
        case HB_NET_NOINIT:
            errDescription = NSLocalizedString(@"HB_NET_NOINIT", @"NetSdkError");          // 没有初始化
            break;
        case HB_NET_CHANNEL_ERROR:
            errDescription = NSLocalizedString(@"HB_NET_CHANNEL_ERROR", @"NetSdkError");          // 通道号错误
            break;
        case HB_NET_OVER_MAXLINK:
            errDescription = NSLocalizedString(@"HB_NET_OVER_MAXLINK", @"NetSdkError");          // 连接到DVR的客户端个数超过最大
            break;
        case HB_NET_VERSIONNOMATCH:
            errDescription = NSLocalizedString(@"HB_NET_VERSIONNOMATCH", @"NetSdkError");          // 版本不匹配
            break;
        case HB_NET_NETWORK_FAIL_CONNECT:
            errDescription = NSLocalizedString(@"HB_NET_NETWORK_FAIL_CONNECT", @"NetSdkError");          // 连接服务器失败
            break;
        case HB_NET_NETWORK_SEND_ERROR:
            errDescription = NSLocalizedString(@"HB_NET_NETWORK_SEND_ERROR", @"NetSdkError");          // 向服务器发送失败
            break;
        case HB_NET_NETWORK_RECV_ERROR:
            errDescription = NSLocalizedString(@"HB_NET_NETWORK_RECV_ERROR", @"NetSdkError");          // 从服务器接收数据失败
            break;
        case HB_NET_NETWORK_RECV_TIMEOUT:
            errDescription = NSLocalizedString(@"HB_NET_NETWORK_RECV_TIMEOUT", @"NetSdkError");         // 从服务器接收数据超时
            code = ErrorNetworkTimeout;
            break;
        case HB_NET_NETWORK_ERRORDATA:
            errDescription = NSLocalizedString(@"HB_NET_NETWORK_ERRORDATA", @"NetSdkError");         // 传送的数据有误
            break;
        case HB_NET_ORDER_ERROR:
            errDescription = NSLocalizedString(@"HB_NET_ORDER_ERROR", @"NetSdkError");         // 调用次序错误
            break;
        case HB_NET_OPERNOPERMIT:
            errDescription = NSLocalizedString(@"HB_NET_OPERNOPERMIT", @"NetSdkError");         // 无此权限
            code = ErrorNOPermission;
            break;
        case HB_NET_COMMANDTIMEOUT:
            errDescription = NSLocalizedString(@"HB_NET_COMMANDTIMEOUT", @"NetSdkError");         // DVR命令执行超时
            break;
        case HB_NET_ERRORSERIALPORT:
            errDescription = NSLocalizedString(@"HB_NET_ERRORSERIALPORT", @"NetSdkError");         // 串口号错误
            break;
        case HB_NET_ERRORALARMPORT:
            errDescription = NSLocalizedString(@"HB_NET_ERRORALARMPORT", @"NetSdkError");         // 报警端口错误
            break;
        case HB_NET_PARAMETER_ERROR:
            errDescription = NSLocalizedString(@"HB_NET_PARAMETER_ERROR", @"NetSdkError");         // 参数错误
            code = ErrorInvalidParament;
            break;
        case HB_NET_CHAN_EXCEPTION:
            errDescription = NSLocalizedString(@"HB_NET_CHAN_EXCEPTION", @"NetSdkError");         // 服务器通道处于错误状态
            break;
        case HB_NET_NODISK:
            errDescription = NSLocalizedString(@"HB_NET_NODISK", @"NetSdkError");         // 没有硬盘
            break;
        case HB_NET_ERRORDISKNUM:
            errDescription = NSLocalizedString(@"HB_NET_ERRORDISKNUM", @"NetSdkError");         // 硬盘号错误
            break;
        case HB_NET_DISK_FULL:
            errDescription = NSLocalizedString(@"HB_NET_DISK_FULL", @"NetSdkError");         // 服务器硬盘满
            break;
        case HB_NET_DISK_ERROR:
            errDescription = NSLocalizedString(@"HB_NET_DISK_ERROR", @"NetSdkError");         // 服务器硬盘出错
            break;
        case HB_NET_NOSUPPORT:
            errDescription = NSLocalizedString(@"HB_NET_NOSUPPORT", @"NetSdkError");         // 服务器不支持
            break;
        case HB_NET_BUSY:
            errDescription = NSLocalizedString(@"HB_NET_BUSY", @"NetSdkError");         // 服务器忙
            break;
        case HB_NET_MODIFY_FAIL:
            errDescription = NSLocalizedString(@"HB_NET_MODIFY_FAIL", @"NetSdkError");         // 服务器修改不成功
            break;
        case HB_NET_PASSWORD_FORMAT_ERROR:
            errDescription = NSLocalizedString(@"HB_NET_PASSWORD_FORMAT_ERROR", @"NetSdkError");         // 密码输入格式不正确
            break;
        case HB_NET_DISK_FORMATING:
            errDescription = NSLocalizedString(@"HB_NET_DISK_FORMATING", @"NetSdkError");         // 硬盘正在格式化，不能启动操作
            break;
        case HB_NET_DVRNORESOURCE:
            errDescription = NSLocalizedString(@"HB_NET_DVRNORESOURCE", @"NetSdkError");         // DVR资源不足
            break;
        case HB_NET_DVROPRATEFAILED:
            errDescription = NSLocalizedString(@"HB_NET_DVROPRATEFAILED", @"NetSdkError");         // DVR操作失败
            break;
        case HB_NET_OPENHOSTSOUND_FAIL:
            errDescription = NSLocalizedString(@"HB_NET_OPENHOSTSOUND_FAIL", @"NetSdkError");         // 打开PC声音失败
            break;
        case HB_NET_DVRVOICEOPENED:
            errDescription = NSLocalizedString(@"HB_NET_DVRVOICEOPENED", @"NetSdkError");         // 服务器语音对讲被占用
            break;
        case HB_NET_TIMEINPUTERROR:
            errDescription = NSLocalizedString(@"HB_NET_TIMEINPUTERROR", @"NetSdkError");         // 时间输入不正确
            break;
        case HB_NET_NOSPECFILE:
            errDescription = NSLocalizedString(@"HB_NET_NOSPECFILE", @"NetSdkError");         // 回放时服务器没有指定的文件
            break;
        case HB_NET_CREATEFILE_ERROR:
            errDescription = NSLocalizedString(@"HB_NET_CREATEFILE_ERROR", @"NetSdkError");         // 创建文件出错
            break;
        case HB_NET_FILEOPENFAIL:
            errDescription = NSLocalizedString(@"HB_NET_FILEOPENFAIL", @"NetSdkError");         // 打开文件出错
            break;
        case HB_NET_OPERNOTFINISH:
            errDescription = NSLocalizedString(@"HB_NET_OPERNOTFINISH", @"NetSdkError");         // 上次的操作还没有完成
            break;
        case HB_NET_GETPLAYTIMEFAIL:
            errDescription = NSLocalizedString(@"HB_NET_GETPLAYTIMEFAIL", @"NetSdkError");         // 获取当前播放的时间出错
            break;
        case HB_NET_PLAYFAIL:
            errDescription = NSLocalizedString(@"HB_NET_PLAYFAIL", @"NetSdkError");         // 播放出错
            break;
        case HB_NET_FILEFORMAT_ERROR:
            errDescription = NSLocalizedString(@"HB_NET_FILEFORMAT_ERROR", @"NetSdkError");         // 文件格式不正确
            break;
        case HB_NET_DIR_ERROR:
            errDescription = NSLocalizedString(@"HB_NET_DIR_ERROR", @"NetSdkError");         // 路径错误
            break;
        case HB_NET_ALLOC_RESOUCE_ERROR:
            errDescription = NSLocalizedString(@"HB_NET_ALLOC_RESOUCE_ERROR", @"NetSdkError");         // 资源分配错误
            break;
        case HB_NET_AUDIO_MODE_ERROR:
            errDescription = NSLocalizedString(@"HB_NET_AUDIO_MODE_ERROR", @"NetSdkError");         // 声卡模式错误
            break;
        case HB_NET_NOENOUGH_BUF:
            errDescription = NSLocalizedString(@"HB_NET_NOENOUGH_BUF", @"NetSdkError");         // 缓冲区太小
            break;
        case HB_NET_CREATESOCKET_ERROR       :
            errDescription = NSLocalizedString(@"HB_NET_CREATESOCKET_ERROR", @"NetSdkError");         // 创建SOCKET出错
            break;
        case HB_NET_SETSOCKET_ERROR          :
            errDescription = NSLocalizedString(@"HB_NET_SETSOCKET_ERROR", @"NetSdkError");
            break;      // 设置SOCKET出错
        case HB_NET_MAX_NUM                  :
            errDescription = NSLocalizedString(@"HB_NET_MAX_NUM", @"NetSdkError");
            break;      // 个数达到最大
        case HB_NET_USERNOTEXIST             :
            errDescription = NSLocalizedString(@"HB_NET_USERNOTEXIST", @"NetSdkError");
            break;      // 用户不存在
        case HB_NET_WRITEFLASHERROR          :
            errDescription = NSLocalizedString(@"HB_NET_WRITEFLASHERROR", @"NetSdkError");
            break;      // 写FLASH出错
        case HB_NET_UPGRADEFAIL              :
            errDescription = NSLocalizedString(@"HB_NET_UPGRADEFAIL", @"NetSdkError");
            break;      // DVR升级失败
        case HB_NET_CARDHAVEINIT             :
            errDescription = NSLocalizedString(@"HB_NET_CARDHAVEINIT", @"NetSdkError");
            break;      // 解码卡已经初始化过
        case HB_NET_PLAYERFAILED             :
            errDescription = NSLocalizedString(@"HB_NET_PLAYERFAILED", @"NetSdkError");
            break;      // 播放器中错误
        case HB_NET_MAX_USERNUM              :
            errDescription = NSLocalizedString(@"HB_NET_MAX_USERNUM", @"NetSdkError");
            break;      // 用户数达到最大
        case HB_NET_GETLOCALIPANDMACFAIL     :
            errDescription = NSLocalizedString(@"HB_NET_GETLOCALIPANDMACFAIL", @"NetSdkError");
            break;      // 获得客户端的IP地址或物理地址失败
        case HB_NET_NOENCODEING              :
            errDescription = NSLocalizedString(@"HB_NET_NOENCODEING", @"NetSdkError");
            break;      // 该通道没有编码
        case HB_NET_IPMISMATCH               :
            errDescription = NSLocalizedString(@"HB_NET_IPMISMATCH", @"NetSdkError");
            break;      // IP地址不匹配
        case HB_NET_MACMISMATCH              :
            errDescription = NSLocalizedString(@"HB_NET_MACMISMATCH", @"NetSdkError");
            break;      // MAC地址不匹配
        case HB_NET_UPGRADELANGMISMATCH      :
            errDescription = NSLocalizedString(@"HB_NET_UPGRADELANGMISMATCH", @"NetSdkError");
            break;      // 升级文件语言不匹配
        case HB_NET_USERISALIVE              :
            errDescription = NSLocalizedString(@"HB_NET_USERISALIVE", @"NetSdkError");
            break;      // 用户已登录
        case HB_NET_UNKNOWNERROR             :
            errDescription = NSLocalizedString(@"HB_NET_UNKNOWNERROR", @"NetSdkError");
            break;      // 未知错误
            
        case HB_NET_IPERR                    :
            errDescription = NSLocalizedString(@"HB_NET_IPERR", @"NetSdkError");
            break;      // IP地址不匹配
        case HB_NET_MACERR                   :
            errDescription = NSLocalizedString(@"HB_NET_MACERR", @"NetSdkError");
            break;      // MAC地址不匹配
        case HB_NET_PSWERR                   :
            errDescription = NSLocalizedString(@"HB_NET_PSWERR", @"NetSdkError");
            code = ErrorWrongPassword;
            break;      // 密码不匹配
        case HB_NET_USERERR                  :
            errDescription = NSLocalizedString(@"HB_NET_USERERR", @"NetSdkError");
            break;      // 用户名不匹配
        case HB_NET_USERISFULL               :
            errDescription = NSLocalizedString(@"HB_NET_USERISFULL", @"NetSdkError");
            break;      // 主机用户满
        case NO_PERMISSION:        // 用户没有权限
            errDescription = NSLocalizedString(@"NO_PERMISSION", @"NetSdkError");
            code = ErrorNOPermission;
            break;
        default:
            errDescription = NSLocalizedString(@"HB_NET_UNKNOWNERROR", @"NetSdkError");
            code = ErrorUnknown;
            break;
    }
    NSDictionary *userInfo = nil;
    
    if (errDescription) {
        userInfo = @{
                     NSLocalizedDescriptionKey: errDescription
                     };
    }
    NSError *error =[NSError errorWithDomain:HBERRORDOMAN code:code userInfo:userInfo];
    return error;
}
@end
