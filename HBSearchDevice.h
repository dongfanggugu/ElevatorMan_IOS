//
//  HBSearchDevice.h
//  MyUI
//
//  Created by wangzhen on 15-6-25.
//  Copyright (c) 2015年 wangzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HBSearchedDeviceInfo;

typedef void(^SearchDeviceBlock)(NSError *error, NSArray *devices);

@interface HBSearchDevice : NSObject

+ (void)searchDevice:(SearchDeviceBlock)block;

@end
