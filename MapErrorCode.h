//
//  MapErrorCode.h
//  MyUI
//
//  Created by wangzhen on 15-6-25.
//  Copyright (c) 2015年 wangzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapErrorCode : NSObject

+ (NSError *)mapYdtError:(int)code;

+ (NSError *)mapYdtError:(int)code description:(NSString *)description;

+ (NSError *)mapNetsdkError:(int)code;

@end
