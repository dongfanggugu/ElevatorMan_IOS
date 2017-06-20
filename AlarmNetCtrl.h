//
//  AlarmNetCtrl.h
//  YdtNetSdkV2
//
//  Created by sunlin on 16/4/22.
//  Copyright © 2016年 hbzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YdtSdkError.h"
#import "YdtUserInfo.h"

@interface AlarmNetCtrl : NSObject

/**
 *  获取报警访问令牌
 *
 *  @param userId 用户ID。
 */
- (void)getAlarmAccessTokenWithUserId:(NSString *)userId;

/**
 *  绑定设备报警
 *
 *  @param userId         用户ID。
 *  @param deviceSn       设备序列号。
 *  @param devicePassword 设备密码。
 *  @param shareType      设备分享类型。
 *  @param bindFlag       绑定标识。
 *  @param handler        结果回调。
 */
- (void)bindDeviceAlarmWithUserId:(NSString *)userId
                         deviceSn:(NSString *)deviceSn
                   devicePassword:(NSString *)devicePassword
                  deviceShareType:(DeviceShareType)shareType
                         bindFlag:(AlarmBindFlag)bindFlag
                completionHandler:(void (^)(int result))handler;

/**
 * 根据报警ID获取单条报警信息
 *
 * @param userId         用户ID。
 * @param alarmId        报警ID。
 * @param handler        结果回调。
 *      @param alarmInfo
 *          报警信息。
 */
- (void) getSingleAlarmWithUserId:(NSString *) userId
                          alarmId:(NSString *) alarmId
                completionHandler:(void (^)(YdtAlarmInfo *alarmInfo)) handler;

/*
 * 获取多条报警信息
 *
 * @param userId
 *      用户ID。
 * @param deviceSn
 *      设备序列号。
 * @param beginTime
 *      报警开始时间，自1970年以来的秒值。
 * @param endTime
 *      报警结束时间，自1970年以来的秒值。
 * @param startIndex
 *      开始序号，即从第startIndex条开始获取。
 * @param count
 *      要获取的报警条数。
 * @param handler
 *      获取结果回调。
 *      @param alarmInfo
 *          报警信息。
 */
- (void) getMultiAlarmWithUserId:(NSString *) userId
                        deviceSn:(NSString *) deviceSn
                       beginTime:(NSTimeInterval) beginTime
                         endTime:(NSTimeInterval) endTime
                      startIndex:(int) startIndex
                           count:(int) count
               completionHandler:(void (^)(YdtAlarmInfo *alarmInfo)) handler;

/**
 *  解析报警字符串
 *
 *  @param json 报警JSON串。
 *
 *  @return 报警参数结构体。
 */
- (YdtAlarmParam *)parseAlarmInfo:(NSString *)json;

@end
