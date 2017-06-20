//
//  HBSearchedDeviceInfo.m
//  MyUI
//
//  Created by wangzhen on 15-6-25.
//  Copyright (c) 2015年 wangzhen. All rights reserved.
//

#import "HBSearchedDeviceInfo.h"

@implementation HBSearchedDeviceInfo

+ (instancetype)initWithSerial:(NSString *)sn ip:(NSString *)ip name:(NSString *)name port:(int)port
{
    HBSearchedDeviceInfo *cur = [[super alloc] init];
    if (cur) {
        cur.serialNO = [sn copy];
        cur.ip = [ip copy];
        cur.name = [name copy];
        cur.port = port;
    }
    return cur;
}

- (void)setSerialNO:(NSString *)serialNO
{
    _serialNO = serialNO;
}

- (void)setIp:(NSString *)ip
{
    _ip = ip;
}

- (void)setName:(NSString *)name
{
    _name = name;
}

- (void)setPort:(int)port
{
    _port = port;
}

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"<%@:%p, \"%@ %@ %@ %d\">", [self class], self, self.serialNO, self.ip, self.name, self.port];
}

@end
