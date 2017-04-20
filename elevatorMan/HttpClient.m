//
//  HttpClient.m
//  HereTripHTTPTest
//
//  Created by 甘泉 on 14-9-4.
//  Copyright (c) 2014年 Heretrip (Beijing) Technology Co.,Ltd. All rights reserved.
//

#import "HttpClient.h"
#import <APService.h>
#import "Utils.h"
#import "MaintenanceReminder.h"
#import "AppDelegate.h"


//define APIBASEURLSTRING @"http://182.92.177.247:8080/lift/mobile/"
//#define APIBASEURLSTRING @"http://192.168.0.82:8080/lift/mobile/"
//#define APIBASEURLSTRING @"http://123.57.10.16:8080/lift/mobile/"



#pragma mark - HttpClient implementation
@implementation HttpClient



+ (instancetype)sharedClient
{
    static HttpClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        

        NSString *server = [Utils getServer];
        
        _sharedClient = [[HttpClient alloc] initWithBaseURL:[NSURL URLWithString:server]];
        
        _sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
        _sharedClient.responseSerializer = [AFJSONResponseSerializer serializer];
        _sharedClient.responseSerializer.acceptableContentTypes = [_sharedClient.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];

    });
    
    return _sharedClient;
}



- (void)post:(NSString *)URLString
                      parameter:(id)parameter
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success {
    
    [self view:nil post:URLString parameter:parameter success:success failed:nil];
}

- (void)view:view post:(NSString *)URLString
   parameter:(id)parameter
     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success {
    
    [self view:view post:URLString parameter:parameter success:success failed:nil];
}

/**
 *  请求网络，需要使用页面的view用户阻塞用户界面的操作
 *
 *  @param view      <#view description#>
 *  @param URLString <#URLString description#>
 *  @param parameter <#parameter description#>
 *  @param success   <#success description#>
 *  @param failed    <#failed description#>
 */
- (void)view:(UIView *)view post:(NSString *)URLString
   parameter:(id)parameter
     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failed:(void (^)(id responseObject))failed {
    
    MBProgressHUD *hud = [HUDClass showLoadingHUD:view];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:1];
    NSMutableDictionary *head = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [head setObject:@"1" forKey:@"osType"];
    [head setObject:@"1.0" forKey:@"version"];
    [head setObject:@"" forKey:@"deviceId"];
    
    if (![URLString isEqualToString:LOGIN_URL]
        && ![URLString isEqualToString:@"registerRepair"]
        && ![URLString isEqualToString:@"checkVersion"]
        && ![URLString isEqualToString:@"getBranchs"]
        && ![URLString isEqualToString:@"resetPWD"]
        && ![URLString isEqualToString:@"propertyRegist"]) {
        [head setObject:[User sharedUser].accessToken  forKey:@"accessToken"];
        [head setObject:[User sharedUser].userId  forKey:@"userId"];
    }
    
    if (parameter) {
        [parameters setObject:parameter forKey:@"body"];
    }
    
    [parameters setObject:head forKey:@"head"];
    
    NSLog(@"request:%@", parameters);
    
    __weak HttpClient * weakself = self;
    
    [self POST:URLString parameters:parameters
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
           NSLog(@"response:%@", responseObject);
           
           if (hud) {
               [HUDClass hideLoadingHUD:hud];
           }
         
         if ([[[responseObject objectForKey:@"head"] objectForKey:@"rspCode"] isEqualToString:@"0"]) {
             success(operation, responseObject);
             
         } else {
             if (nil == failed) {
                 
                 //根据错误信息提示用户
                 NSString *msg = nil;
                 NSString *rspMsg = [[responseObject objectForKey:@"head"]objectForKey:@"rspMsg"];
                 if ([rspMsg containsString:@"系统错误"]) {
                     msg = [rspMsg substringFromIndex:5];
                 } else {
                     msg = rspMsg;
                 }
                 
                 if (nil == view) {
                     [HUDClass showHUDWithLabel:msg];
                 } else {
                     [HUDClass showHUDWithLabel:msg view:view];
                 }
                 
                 
                 NSString * msgCode = [[responseObject objectForKey:@"head"]objectForKey:@"rspCode"];
                 
                 if ([msgCode isEqualToString:@"-9"] || [msgCode isEqualToString:@"-3"])
                 {
                     
                     [weakself performSelector:@selector(logoutBackTosignIn) withObject:self afterDelay:1.0f];
                     
                 }
             } else {
                 failed(responseObject);
             }
         }
     }
       failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [HUDClass hideLoadingHUD:hud];
         [HUDClass showHUDWithLabel:@"网络连接错误，请稍后再试!"];
         
         if (failed != nil)
         {
             [weakself performSelector:@selector(logoutBackTosignIn) withObject:self afterDelay:1.0f];
         }
     }];
    
}

- (void)logoutBackTosignIn
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (appDelegate.bgCheckTimer)
    {
        [appDelegate.bgCheckTimer invalidate];
        
        appDelegate.bgCheckTimer = nil;
    }
    
    
    if (appDelegate.locationTimer)
    {
        [appDelegate.locationTimer invalidate];
        appDelegate.locationTimer = nil;
    }
    
    

    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogged"];
    
    [MaintenanceReminder cancelMaintenanceNofity];
    
    [[User sharedUser] clearUserInfo];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    [UIApplication sharedApplication].delegate.window.rootViewController = [storyBoard instantiateViewControllerWithIdentifier:@"signviewcontroller"];
}

/**
 *  根据保存的用户的值重新设置服务器地址
 */
- (void)resetUrl {
    NSString *server = [Utils getServer];
    self.baseURL = [NSURL URLWithString:server];
    NSLog(@"baseURL changed to %@", server);
}

@end
