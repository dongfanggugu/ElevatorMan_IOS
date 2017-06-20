//
//  NSError+Error.m
//  MyUI
//
//  Created by wangzhen on 15-6-25.
//  Copyright (c) 2015年 wangzhen. All rights reserved.
//

#import "NSError+HbError.h"

static NSString *YDTErrorDomain = @"net.hbgk.hbydt.hbydtpro";

@implementation NSError (HbError)

+ (NSError *)errorWithHbCode:(Error)code
{
    NSString *errDescription = nil;
    switch (code) {
        case ErrorSuccess:
            errDescription = NSLocalizedString(@"ErrorSuccess", @"manager");
            break;
        case ErrorNotSupported:
            errDescription = NSLocalizedString(@"ErrorNotSupported", @"manager");
            break;
        case ErrorNotImplemented:
            errDescription = NSLocalizedString(@"ErrorNotImplemented", @"manager");
            break;
        case ErrorIOPending:
            errDescription = NSLocalizedString(@"ErrorIOPending", @"manager");
            break;
        case ErrorNullPointer:
            errDescription = NSLocalizedString(@"ErrorNullPointer", @"manager");
            break;
        case ErrorNotInitialized:
            errDescription = NSLocalizedString(@"ErrorNotInitialized", @"manager");
            break;
        case ErrorInvalidParament:
            errDescription = NSLocalizedString(@"ErrorInvalidParament", @"manager");
            break;
        case ErrorNetworkDisconnected:
            errDescription = NSLocalizedString(@"ErrorNetworkDisconnected", @"manager");
            break;
        case ErrorDeviceDisconnected:
            errDescription = NSLocalizedString(@"ErrorDeviceDisconnected", @"manager");
            break;
        case ErrorNetworkTimeout:
            errDescription = NSLocalizedString(@"ErrorNetworkTimeout", @"manager");
            break;
        case ErrorDeviceAlreadyAdded:
            errDescription = NSLocalizedString(@"ErrorDeviceAlreadyAdded", @"manager");
            break;
        case ErrorDeviceSerialNotMacthed:
            errDescription = NSLocalizedString(@"ErrorDeviceSerialNotMacthed", @"manager");
            break;
        case ErrorVVeyeStatus:
            errDescription = NSLocalizedString(@"ErrorVVeyeStatus", @"manager");
            break;
        case ErrorVVeyeQuery:
            errDescription = NSLocalizedString(@"ErrorVVeyeQuery", @"manager");
            break;
            
        case ErrorVVeyeAddPortV3:
            errDescription = NSLocalizedString(@"ErrorVVeyeAddPortV3", @"manager");
            break;
            
        case ErrorVVeyePortStatus:
            errDescription = NSLocalizedString(@"ErrorVVeyePortStatus", @"manager");
            break;
            
        case ErrorAccountNameNotExit:
            errDescription = NSLocalizedString(@"ErrorAccountNameNotExit", @"manager");
            break;
        case ErrorAccountAlreadyRegistered:
            errDescription = NSLocalizedString(@"ErrorAccountAlreadyRegistered", @"manager");
            break;
        case ErrorWrongPassword:
            errDescription = NSLocalizedString(@"ErrorWrongPassword", @"manager");
            break;
        case ErrorAlreadyLogin:
            errDescription = NSLocalizedString(@"ErrorAlreadyLogin", @"manager");
            break;
        case ErrorInvalidAccountToken:
            errDescription = NSLocalizedString(@"ErrorInvalidAccountToken", @"manager");
            break;
        case ErrorDeviceUnregistered:
            errDescription = NSLocalizedString(@"ErrorDeviceUnregistered", @"manager");
            break;
        case ErrorDeviceHasOwner:
            errDescription = NSLocalizedString(@"ErrorDeviceHasOwner", @"manager");
            break;
        case ErrorTooManyUsers:
            errDescription = NSLocalizedString(@"ErrorTooManyUsers", @"manager");
            break;
        case ErrorTooManyLinks:
            errDescription = NSLocalizedString(@"ErrorTooManyLinks", @"manager");
            break;
        case ErrorNOPermission:
            errDescription = NSLocalizedString(@"ErrorNOPermission", @"manager");
            break;
        
        case ErrorUnknown:
        default:
            errDescription = NSLocalizedString(@"ErrorUnknown", @"manager");
            break;
    }
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: errDescription
                               };
    NSError *error =[NSError errorWithDomain:YDTErrorDomain code:code userInfo:userInfo];
    return error;
}

@end
