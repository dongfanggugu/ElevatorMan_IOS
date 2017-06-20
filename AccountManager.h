//
//  AccountManager.h
//  hbydtSDKDemo
//
//  Created by wangzhen on 16/4/14.
//  Copyright © 2016年 wangzhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YdtNetSdk.h"
@class Device;
@class YdtUserInfo;
@class YdtVervificationCodeInfo;

@interface AccountManager : NSObject

// 一点通是否已登录
@property (nonatomic) int isLogin;

// 一点通操作对象
@property (strong, nonatomic) YdtNetSdk *ydtNetSdk;
// 账号下设备
@property (strong, nonatomic) NSMutableSet<Device *> *devices;

+ (instancetype)sharedManager;

- (void)loginByName:(NSString *)name andPassword:(NSString *)pwd completedBlock:(void (^)(int result, YdtUserInfo *user)) block;

// 通过用户名获取账号信息，判断用户是否存在
- (void)getAccount:(NSString *)name completedBlock:(void (^)(int result, YdtUserInfo *user)) block;

//
- (void)getCheckCodeByName:(NSString *)name andLanguage:(NSString *)language completedBlock:(void(^)(int result, YdtVervificationCodeInfo *codeInfo)) block;

// [ydtNetCtrl registerLoginWithAddress:<#(NSString *)#> Code:<#(NSString *)#> SID:<#(NSString *)#> Block:<#^(int result, HBYdtUserInfo *user)block#>]
// [ydtNetCtrl setPassword:<#(NSString *)#> Block:<#^(int result)block#>]
// [ydtNetCtrl findPasswordLoginWithAddress:<#(NSString *)#> Code:<#(NSString *)#> SID:<#(NSString *)#> Block:<#^(int result, HBYdtUserInfo *user)block#>]

- (void)addDevice:(Device *)device;

- (void)deleteDevice:(Device *)device;

- (void)setDeviceListOfAccoutFromServer:(NSArray *)deviceList;

- (NSArray *)getdeviceListFromLocal;

@end
