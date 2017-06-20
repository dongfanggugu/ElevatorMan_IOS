//
//  HBSearchedDeviceInfo.h
//  MyUI
//
//  Created by wangzhen on 15-6-25.
//  Copyright (c) 2015年 wangzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBSearchedDeviceInfo : NSObject

@property (nonatomic) int addStatus;
@property (nonatomic, strong) NSString *serialNO;
@property (nonatomic, strong) NSString *ip;
@property (nonatomic, strong) NSString *name;
@property (nonatomic) int port;

+ (instancetype)initWithSerial:(NSString *)sn ip:(NSString *)ip name:(NSString *)name port:(int)port;

@end
