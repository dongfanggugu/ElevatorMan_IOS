//
//  AccountManager.m
//  hbydtSDKDemo
//
//  Created by wangzhen on 16/4/14.
//  Copyright © 2016年 wangzhen. All rights reserved.
//

#import "AccountManager.h"
#import "Device.h"
#import "YdtUserInfo.h"
#define YdtDeveloperID @"4b7ebe16c99af1daf3b37d7e01536c9f"

#define YdtAppID @"8tqukmaM7g4alfdBDTsV_w"

#define YdtAppKey @"737lRF8GWFyrC3DhK2TnXkLvPi8fsCXBxOCoSsP99tGPrmBD"

@interface AccountManager()

@property (strong, nonatomic) NSString *DeveloperID;

@property (strong, nonatomic) NSString *AppID;

@property (strong, nonatomic) NSString *AppKey;

// 一点通账号名
@property (strong, nonatomic) NSString *account;

// 一点通密码
@property (strong, nonatomic) NSString *password;

@property (strong, nonatomic) NSMutableArray *deviceListArray;

@end

@implementation AccountManager

//@synthesize ydtNetCtrl;
@synthesize DeveloperID;
@synthesize AppID;
@synthesize AppKey;

+ (instancetype)sharedManager
{
    static AccountManager *_shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareManager = [[AccountManager alloc] init];
    });
    return _shareManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        _ydtNetSdk = [[YdtNetSdk alloc] init];
        [_ydtNetSdk  initWithDeveloperId:YdtDeveloperID appId:YdtAppID appKey:YdtAppKey imei:nil];
//        [ydtNetCtrl ];
    }
    return self;
}

- (void)loginByName:(NSString *)name
        andPassword:(NSString *)pwd
     completedBlock:(void (^)(int result, YdtUserInfo *user)) block
{
    [_ydtNetSdk loginYdtWithName:name password:pwd pushId:nil completionHandler:^(YdtUserInfo *userInfo) {
    
        if (userInfo.errorCode == 0) {
            
            self.account = [name copy];
            self.password = [pwd copy];
        }
        if (block) {
            block(userInfo.errorCode,userInfo);
        }
    }];
}

- (void)getAccount:(NSString *)name
    completedBlock:(void (^)(int result, YdtUserInfo *user)) block
{
    [_ydtNetSdk getAccountInfoWithName:name completionHandler:^(YdtUserInfo *userInfo) {
       
        if (block) {
            block(userInfo.errorCode,userInfo);
        }
    }];
}

- (void)getCheckCodeByName:(NSString *)name
               andLanguage:(NSString *)language completedBlock:(void (^)(int, YdtVervificationCodeInfo *))block
{
    [_ydtNetSdk getVerificationCodeWithAddress:name language:language completionHandler:^(YdtVervificationCodeInfo *codeInfo) {
        
        if (block) {
            block(codeInfo.errorCode,codeInfo);
        }
        
    }];

}

- (void)addDevice:(Device *)device
{
//    [_ydtNetSdk ]
//    [_ydtNetSdk getDeviceWithDeviceSN:device.serialNO
//                                  Block:^(int result, HBYdtDeviceParam *device) {
//        ;
//    }];
}

- (void)setDeviceListOfAccoutFromServer:(NSArray *)deviceList {
    
    _deviceListArray = [NSMutableArray arrayWithCapacity:0];
    _deviceListArray = [NSMutableArray arrayWithArray:deviceList];
}
- (NSArray *)getdeviceListFromLocal {
    
    if (_deviceListArray.count > 0) {
        
        return _deviceListArray;
    }
    return nil;;
    
}
@end
