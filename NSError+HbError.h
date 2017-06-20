//
//  NSError+HbError.h
//  MyUI
//
//  Created by wangzhen on 15-6-25.
//  Copyright (c) 2015年 wangzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, Error) {
    ErrorSuccess = 0,
    ErrorUnknown = -1,
    ErrorNotSupported = -2,
    ErrorNotImplemented = -3,
    ErrorIOPending = -4,
    ErrorNullPointer = -5,
    ErrorNotInitialized = -6,
    ErrorInvalidParament = -10,
    ErrorNetworkDisconnected = -100,
    ErrorDeviceDisconnected = -101,
    ErrorNetworkTimeout = -102,
    ErrorDeviceAlreadyAdded = -103,
    ErrorDeviceSerialNotMacthed = -104,
    ErrorVVeyeStatus = -110,
    ErrorVVeyeQuery = -111,
    ErrorVVeyeAddPortV3 = -112,
    ErrorVVeyePortStatus = -113,
    ErrorAccountNameNotExit = -150,
    ErrorAccountAlreadyRegistered = -151,
    ErrorWrongPassword = -152,
    ErrorAlreadyLogin = -153,
    ErrorInvalidAccountToken = -154,
    ErrorDeviceUnregistered = -201,
    ErrorDeviceHasOwner = -202,
    ErrorTooManyUsers = -210,
    ErrorTooManyLinks = -211,
    ErrorNOPermission = -212,
    ErrorAlreadyOpened = -213,
    ErrorNoRecordFile = -214,
};

@interface NSError (HbError)

+ (NSError *)errorWithHbCode:(Error)code;

@end
