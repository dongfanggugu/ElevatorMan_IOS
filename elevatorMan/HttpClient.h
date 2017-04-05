//
//  HttpClient.h
//  HereTripHTTPTest
//
//  Created by 甘泉 on 14-9-4.
//  Copyright (c) 2014年 Heretrip (Beijing) Technology Co.,Ltd. All rights reserved.
//

#import <AFHTTPRequestOperationManager.h>


#pragma mark - URL定义

#define LOGIN_URL @"login"


#pragma mark HttpClient
@interface HttpClient : AFHTTPRequestOperationManager


//@property (nonatomic, weak)id <HttpRequestDelegate>delegate;



@property (nonatomic ,strong)NSString * URLString;

+(instancetype)sharedClient;

- (void)post:(NSString *)URLString
   parameter:(id)parameter
     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success;

- (void)view:(UIView *)view post:(NSString *)URLString
   parameter:(id)parameter
     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success;

- (void)view:(UIView *)view post:(NSString *)URLString
   parameter:(id)parameter
     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failed:(void(^)(id responseObject))failed;

- (void)resetUrl;

- (void)logoutBackTosignIn;


@end
