//
//  User.h
//  elevatorMan
//
//  Created by Cove on 15/6/18.
//
//

#import <Foundation/Foundation.h>

#define    UserTypeWorker   @"3"
#define    UserTypeAdmin    @"2"


@interface User : NSObject


@property (nonatomic ,strong)NSString *userId;

@property (nonatomic ,strong)NSString *accessToken;

@property (nonatomic ,strong)NSString *userName;

@property (nonatomic, strong)NSString *userType;

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSNumber *age;

@property (strong, nonatomic) NSString *operation;

@property (strong, nonatomic) NSNumber *sex;

@property (strong, nonatomic) NSString *tel;

@property (strong, nonatomic) NSString *branch;

@property (strong, nonatomic) NSString *picUrl;

@property (strong, nonatomic) NSString *homeProvince;

@property (strong, nonatomic) NSString *homeCity;

@property (strong, nonatomic) NSString *homeZone;

@property (strong, nonatomic) NSString *homeAddress;

@property (strong, nonatomic) NSString *workProvince;

@property (strong, nonatomic) NSString *workCity;

@property (strong, nonatomic) NSString *workZone;

@property (strong, nonatomic) NSString *workAddress;

@property (strong, nonatomic) NSString *first;

@property (strong, nonatomic) NSString *branchId;

@property (copy, nonatomic) NSString *signUrl;

//是否加入怡墅相关业务
@property (assign, nonatomic) BOOL joinVilla;

@property (copy, nonatomic) NSString *server;

+(instancetype)sharedUser;

- (void)setUserInfo;

- (void)getUserInfo;

- (void)clearUserInfo;

@end
