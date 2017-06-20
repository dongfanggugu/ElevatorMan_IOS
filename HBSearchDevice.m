//
//  HBSearchDevice.m
//  MyUI
//
//  Created by wangzhen on 15-6-25.
//  Copyright (c) 2015年 wangzhen. All rights reserved.
//

#import "HBSearchDevice.h"
#import "HBSearchedDeviceInfo.h"
#import "GCDAsyncUdpSocket.h"
#import "NSError+HbError.h"

#define PROTOCOL_HEADER "HBneTautOf8inDp_@"

typedef void(^GetDeviceLocalBlock)(BOOL success,BOOL finish, HBSearchedDeviceInfo *device);

static const int UdpReceiveTimeOut = 3;
static const int ListerPort = 27156;

@interface HBSearchDevice()

@property (nonatomic,strong)GCDAsyncUdpSocket *socket;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,copy) GetDeviceLocalBlock block;

@end

@implementation HBSearchDevice

+ (void)searchDevice:(SearchDeviceBlock)block;
{
    NSError *error = [NSError errorWithHbCode:ErrorUnknown];
    NSMutableArray *deviceArray = [[NSMutableArray alloc] init];
    HBSearchDevice *searchDevice = [[HBSearchDevice alloc] init];
    if (searchDevice && [searchDevice initSocket]) {
        __weak typeof(searchDevice) weakSearchDevice = searchDevice;
        searchDevice.block = ^(BOOL success, BOOL finish, HBSearchedDeviceInfo *device)
        {
            if (device) {
                __block BOOL isSearched = NO;
                [deviceArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    HBSearchedDeviceInfo *findDevice = (HBSearchedDeviceInfo *)obj;
                    if ([device.serialNO compare:findDevice.serialNO options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                        isSearched = YES;
                        *stop = YES;
                    };
                }];
                if (!isSearched) {
                    [deviceArray addObject:device];
                }
                __strong typeof(weakSearchDevice) strongSearchDevice = weakSearchDevice;
                [strongSearchDevice resetTimer];
            }
            if(finish)
            {
                block([NSError errorWithHbCode:ErrorSuccess], deviceArray);
            }
            
        };
        [searchDevice getDevice];
    } else {
        error = [NSError errorWithHbCode:ErrorNetworkDisconnected];
        block(error, deviceArray);
    }
}

- (id)init
{
    if(self=[super init]) {
        _socket=[[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return self;
}

- (void)timer:(id)sender
{
    if(_timer) {
        [_timer invalidate];
        _timer=nil;
    }
    [self close];
    
    NSLog(@"timer end ......");
    self.block(YES,YES,nil);
}

- (void)close
{
    if(!_socket.isClosed) {
        [_socket close];
    }
    if(_timer) {
        [_timer invalidate];
        _timer=nil;
    }
}

- (BOOL)initSocket
{
    NSError *error = nil;
    [_socket setIPv4Enabled:YES];
    [_socket setIPv6Enabled:NO];
    if (![_socket bindToPort:ListerPort error:&error]) {
        NSLog(@"Error binding: %@", error);
        return NO;
    }
    if (![_socket beginReceiving:&error]) {
        NSLog(@"Error receiving: %@", error);
        return NO;
    }
    if (![_socket enableBroadcast:YES error:&error]) {
        NSLog(@"Error enableBroadcast: %@", error);
        return NO;
    }
    
    return YES;
}

-(void)getDevice
{
    if (_socket != nil) {
        Byte buffer[25] = {0};
        memcpy(buffer, PROTOCOL_HEADER, strlen(PROTOCOL_HEADER));
        buffer[24] = 0xa8;
        NSData *data = [NSData dataWithBytes:buffer length:25];
        [_socket sendData:data toHost:@"255.255.255.255" port:ListerPort withTimeout:-1 tag:0];
        [self resetTimer];
    }
}

- (void)resetTimer
{
    if(self.timer) {
        [self.timer invalidate];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:UdpReceiveTimeOut target:self selector:@selector(timer:) userInfo:nil repeats:NO];
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    NSLog(@"did send %ld", tag);
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    Byte *ret = (Byte *)[data bytes];
//    printf("\nRecv: %lu\n", (unsigned long)[data length]);
//    
//    for (int i = 0; i < [data length]; i++) {
//        printf("%02x", ret[i]);
//    }
//    printf("\n");
    if ([data length] == 89) {
        HBSearchedDeviceInfo *dev = [[HBSearchedDeviceInfo alloc] init];
        
        NSString * macaddress = [[NSString alloc] initWithFormat:@"%02x%02x%02x%02x%02x%02x", ret[25], ret[26], ret[27], ret[28], ret[29], ret[30]];
        dev.serialNO = [macaddress substringFromIndex:[macaddress length]-8];
        dev.ip = [[NSString alloc] initWithFormat:@"%d.%d.%d.%d", ret[34], ret[33], ret[32], ret[31]];
        dev.port =(ret[39] | (ret[40] << 8));
        Byte devNameBuffer[32] = {0};
        for (int i = 0; i < 32; i++) {
            devNameBuffer[i] = ret[41 + i];
        }
        
        dev.name = [NSString stringWithCString:(const char *)devNameBuffer encoding:NSUTF8StringEncoding];
        
        self.block(YES,NO,dev);
    }
    NSString *host = nil;
    uint16_t port = 0;
    [GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
    NSLog(@"from: %@:%hu", host, port);
}

- (void)dealloc
{
    [self close];
}

@end
