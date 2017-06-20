//
//  YdtNetSdk.h
//  YdtNetSdkV2
//
//  Created by sun lin on 16/4/19.
//  Copyright © 2016年 hbzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YdtUserInfo.h"
#import "YdtSdkError.h"

@interface YdtNetSdk : NSObject

/**
 *  初始化开发者信息
 *
 *  @param developerId 开发者ID。
 *  @param appId       应用ID。
 *  @param appKey      应用Key。
 *
 *  @return 成功返回YES，失败返回NO。
 */
- (BOOL)initWithDeveloperId:(NSString *)developerId
                      appId:(NSString *)appId
                     appKey:(NSString *)appKey
                       imei:(NSString *)imei;

/**
 *  获取演示设备
 *
 *  @param handler 结果回调。
 */
- (void)getDemoDevicesWithCompletionHandler:(void(^)(YdtDeviceInfo *deviceInfo))handler;

/**
 *  登录一点通账户
 *
 *  @param name     账户名。
 *  @param password 密码。
 *  @param block    登录结果回调。
 */
- (void)loginYdtWithName:(NSString *)name
                password:(NSString *)password
                  pushId:(NSString *)pushId
    completionHandler:(void (^)(YdtUserInfo *userInfo))handler;

/**
 *  通过第三方QQ登录一点通
 *
 *  @param nickName 昵称。
 *  @param openId   QQ返回的openId。
 *  @param handler  结果回调。
 */
- (void)loginYdtByQQWithNickname:(NSString *)nickName
                          openId:(NSString *)openId
                          pushId:(NSString *)pushId
               completionHandler:(void (^)(YdtUserInfo *userInfo))handler;

/**
 *  通过第三方微信登录一点通
 *
 *  @param nickName 昵称。
 *  @param openId   微信返回的openId。
 *  @param handler  结果回调。
 */
- (void)loginYdtByWeiXinWithNickname:(NSString *)nickName
                              openId:(NSString *)openId
                              pushId:(NSString *)pushId
                   completionHandler:(void (^)(YdtUserInfo *userInfo))handler;

/**
 *  通过第三方微博登录一点通
 *
 *  @param nickName 昵称。
 *  @param openId   微博返回的openId。
 *  @param handler  结果回调。
 */
- (void)loginYdtByWeiBoWithNickname:(NSString *)nickName
                             openId:(NSString *)openId
                             pushId:(NSString *)pushId
                  completionHandler:(void (^)(YdtUserInfo *userInfo))handler;

/**
 *  注销账户
 */
- (void)logoutYdtWithCompletionHandler:(void (^)(int result))handler;

/**
 *  获取账户下的设备
 *
 *  @param handler 结果回调。
 */
- (void)getDevicesBelongsToAccountWithCompletionHandler:(void (^)(YdtDeviceInfo *deviceInfo))handler;

/**
 *  通过序列号添加设备
 *
 *  @param deviceId       设备ID。
 *  @param deviceName     设备名。
 *  @param deviceUser     设备的用户名。
 *  @param devicePassword 设备的密码。
 *  @param channelCount   设备通道数。
 *  @param handler        添加结果回调。
 *
 *  @note 如果添加成功，返回的设备参数中，仅地理位置信息有效。
 */
- (void)addDeviceBySnWithDeviceId:(NSString *)deviceId
                       deviceName:(NSString *)deviceName
                       deviceUser:(NSString *)deviceUser
                   devicePassword:(NSString *)devicePassword
                     channelCount:(int)channelCount
                completionHandler:(void (^)(YdtDeviceInfo *deviceInfo))handler;

/**
 *  通过域名添加设备
 *
 *  @param deviceSn       设备序列号。
 *  @param deviceName     设备名。
 *  @param deviceUser     设备用户名。
 *  @param devicePassword 设备密码。
 *  @param domain         域名。
 *  @param domainPort     映射端口。
 *  @param channelCount   通道数。
 *  @param handler        添加结果回调。
 */
- (void)addDeviceByDomainWithDeviceSn:(NSString *)deviceSn
                           deviceName:(NSString *)deviceName
                           deviceUser:(NSString *)deviceUser
                       devicePassword:(NSString *)devicePassword
                         deviceDomain:(NSString *)domain
                     deviceDomainPort:(int)domainPort
                         channelCount:(int)channelCount
                    completionHandler:(void (^)(YdtDeviceInfo *deviceInfo))handler;

/**
 *  删除设备
 *
 *  @param deviceId 设备ID。
 *  @param handler  删除结果回调。
 */
- (void)deleteDeviceWithDeviceId:(NSString *)deviceId
               completionHandler:(void (^)(int result))handler;

/**
 *  修改设备信息
 *
 *  @param deviceId   要修改的设备的设备ID。
 *  @param deviceName 设备名称。
 *  @param deviceUser 设备的用户名。
 *  @param password   设备的密码。
 *  @param domainPort 域名映射端口。
 *  @param handler    修改结果回调。
 */
- (void)modifyDeviceWithDeviceId:(NSString *)deviceId
                      deviceName:(NSString *)deviceName
                      deviceUser:(NSString *)deviceUser
                  devicePassword:(NSString *)password
                      domainPort:(int)domainPort
               completionHandler:(void (^)(int result))handler;

/**
 *  不登录获取指定设备信息
 *
 *  @param deviceSn 设备序列号。
 *  @param handler  获取结果回调。
 */
- (void)getSpecifiedDeviceWithoutLoginWithDeviceSn:(NSString *)deviceSn
                                 completionHandler:(void (^)(YdtDeviceInfo *deviceInfo))handler;

/**
 *  获取设备的流媒体服务器信息
 *
 *  @param deviceId 设备ID。
 *  @param hanlder  结果回调。
 */
- (void)getSmsServerInfoWithDeviceId:(NSString *)deviceId
                   completionHandler:(void (^)(YdtSmsServerInfo *smsServerInfo))handler;

/**
 *  获取验证码
 *
 *  @param address  手机号或邮箱。
 *  @param language 语言，zh_CN - 中文，en_US － 英文。
 */
- (void)getVerificationCodeWithAddress:(NSString *)address
                             language:(NSString *)language
                    completionHandler:(void (^)(YdtVervificationCodeInfo *codeInfo))handler;

/**
 *  注册并登录
 *
 *  @param address          手机号或邮箱。
 *  @param verificationCode 验证码。
 *  @param handler          结果回调。
 */
- (void)registerAndLoginWithAddress:(NSString *)address
                   verificationCode:(NSString *)verificationCode
                             pushId:(NSString *)pushId
                  completionHandler:(void (^)(YdtUserInfo *userInfo))handler;

/**
 *  设置账户密码
 *
 *  @param password 密码。
 *  @param handler  结果回调。
 */
- (void)setAccountPassword:(NSString *)password
         completionHandler:(void (^)(int result))handler;

/**
 *  获取账户信息
 *
 *  @param accountName 账户名或手机号或邮箱。
 *  @param handler     结果回调。
 */
- (void)getAccountInfoWithName:(NSString *)accountName
             completionHandler:(void (^)(YdtUserInfo *userInfo))handler;

/**
 *  找回密码并登录
 *
 *  @param address 用户名或手机号或邮箱。
 *  @param handler 结果回调。
 */
- (void)findPasswordAndLoginWithName:(NSString *)name
                       verificationCode:(NSString *)verificationCode
                              pushId:(NSString *)pushId
                      completionHandler:(void (^)(YdtUserInfo *userInfo))handler;

/**
 *  修改账户密码
 *
 *  @param oldPassword 旧密码。
 *  @param newPassword 新密码。
 *  @param handler     结果回调。
 */
- (void)modifyAccountOldPassword:(NSString *)oldPassword
                   toNewPassword:(NSString *)newPassword
               completionHandler:(void (^)(int result))handler;

/**
 *  设置昵称
 *
 *  @param nickName 昵称。
 *  @param handler  结果回调。
 */
- (void)setNickName:(NSString *)nickName
  completionHandler:(void (^)(int result))handler;

/**
 *  修改设备的位置信息
 *
 *  @param deviceSn 设备序列号。
 *  @param province 设备所在省。
 *  @param city     设备所在市。
 *  @param handler  结果回调。
 */
//- (void)modifyDeviceLocationWithDeviceSn:(NSString *)deviceSn
//                                province:(NSString *)province
//                                    city:(NSString *)city
//                       completionHandler:(void (^)(int result))handler;

/**
 *  将设备分享给另一个用户
 *
 *  @param deviceId 设备ID。
 *  @param userName 对方的用户名。
 *  @param handler  结果回调。
 */
//- (void)shareDevice:(NSString *)deviceId
//     toOtherAccount:(NSString *)accountName
//  completionHandler:(void (^)(int result))handler;

/**
 *   将设备分享给多个用户
 *
 *  @param deviceId 设备ID。
 *  @param othersId 多个用户ID集合，最多允许50个，ID之间用英文逗号分隔，例如1001，1005，1023
 *  @param handler  结果回调。
 */
//- (void)shareDevice:(NSString *)deviceId
//           toOthers:(NSString *)othersId
//  completionHandler:(void(^)(int result))handler;

/**
 *  绑定报警设备
 *
 *  @param deviceSn       设备序列号。
 *  @param devicePassword 设备密码。
 *  @param shareType      设备分享类型。
 *  @param bindFlag       绑定标识。
 *  @param handler        结果回调。
 */
- (void)bindDeviceAlarmWithDeviceSn:(NSString *)deviceSn
                     devicePassword:(NSString *)devicePassword
                          shareType:(DeviceShareType)shareType
                           bindFlag:(AlarmBindFlag)bindFlag
                  completionHandler:(void (^)(int result))handler;

/**
 *  获取指定报警信息
 *
 *  @param alarmId 报警ID。
 *  @param handler 结果回调。
 */
- (void)getSingleAlarmInfoWithAlarmId:(NSString *)alarmId
                    completionHandler:(void (^)(YdtAlarmInfo *alarmInfo))handler;

/**
 *  获取多条报警信息
 *
 *  @param deviceSn   设备序列号
 *  @param beginTime  开始时间，自1970年以来的秒值。
 *  @param endTime    结束时间，自1970年以来的秒值。
 *  @param startIndex 开始序列号，即从该条开始获取报警信息。
 *  @param count      获取报警条数。
 *  @param handler    结果回调。
 */
- (void)getMultiAlarmInfoWithDeviceSn:(NSString *)deviceSn
                            beginTime:(NSTimeInterval)beginTime
                              endTime:(NSTimeInterval)endTime
                           startIndex:(int)startIndex
                                count:(int)count
                      competionHander:(void (^)(YdtAlarmInfo *alarmInfo))handler;

/**
 *  解析报警字符串
 *
 *  @param json 报警JSON串。
 *
 *  @return 报警参数结构体。
 */
- (YdtAlarmParam *)parseAlarmInfo:(NSString *)json;

+ (NSString *)getErrorMessageWithErrorCode:(int)errorCode;

/**
 *  获取平台上的设备
 *
 *  @param address  平台地址（IP或域名）。
 *  @param port     平台端口。
 *  @param name     平台的用户名。
 *  @param password 平台的密码。
 *  @param handler  结果回调。
 */
+ (void)getDevicesFromPlatformWithAddress:(NSString *)address
                                     port:(int)port
                                     name:(NSString *)name
                                 password:(NSString *)password
                        completionHandler:(void(^)(PlatformDeviceInfo *devicesInfo))handler;

@end
