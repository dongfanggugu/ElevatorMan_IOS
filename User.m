//
//  User.m
//  elevatorMan
//
//  Created by Cove on 15/6/18.
//
//

#import "User.h"

@implementation User


+ (instancetype)sharedUser
{
    static User *_sharedUser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        
        _sharedUser = [[User alloc] init];
        
    });
    
    return _sharedUser;
}


- (void)setUserInfo
{

    [[NSUserDefaults standardUserDefaults] setObject:self.userName forKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] setObject:self.userType forKey:@"userType"];
    [[NSUserDefaults standardUserDefaults] setObject:self.accessToken forKey:@"accessToken"];
    [[NSUserDefaults standardUserDefaults] setObject:self.userId forKey:@"userId"];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.name forKey:@"name"];
    [[NSUserDefaults standardUserDefaults] setObject:self.age forKey:@"age"];
    [[NSUserDefaults standardUserDefaults] setObject:self.operation forKey:@"operation"];
    [[NSUserDefaults standardUserDefaults] setObject:self.sex forKey:@"sex"];
    [[NSUserDefaults standardUserDefaults] setObject:self.tel forKey:@"tel"];
    [[NSUserDefaults standardUserDefaults] setObject:self.branch forKey:@"branch"];
    [[NSUserDefaults standardUserDefaults] setObject:self.branchId forKey:@"branch_id"];
    [[NSUserDefaults standardUserDefaults] setObject:self.picUrl forKey:@"picUrl"];
    
    [[NSUserDefaults standardUserDefaults] setObject:_homeProvince forKey:@"home_province"];
    [[NSUserDefaults standardUserDefaults] setObject:_homeCity forKey:@"home_city"];
    [[NSUserDefaults standardUserDefaults] setObject:_homeZone forKey:@"home_zone"];
    [[NSUserDefaults standardUserDefaults] setObject:_homeAddress forKey:@"home_address"];
    
    [[NSUserDefaults standardUserDefaults] setObject:_workProvince forKey:@"work_province"];
    [[NSUserDefaults standardUserDefaults] setObject:_workCity forKey:@"work_city"];
    [[NSUserDefaults standardUserDefaults] setObject:_workZone forKey:@"work_zone"];
    [[NSUserDefaults standardUserDefaults] setObject:_workAddress forKey:@"work_address"];
    
    [[NSUserDefaults standardUserDefaults] setObject:_signUrl forKey:@"sign_url"];

}


- (void)getUserInfo
{
    self.userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    self.userType = [[NSUserDefaults standardUserDefaults] objectForKey:@"userType"];
    self.userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    self.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    
    self.name = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    self.age = [[NSUserDefaults standardUserDefaults] objectForKey:@"age"];
    self.operation = [[NSUserDefaults standardUserDefaults] objectForKey:@"operation"];
    self.sex = [[NSUserDefaults standardUserDefaults] objectForKey:@"sex"];
    self.tel = [[NSUserDefaults standardUserDefaults] objectForKey:@"tel"];
    self.branch = [[NSUserDefaults standardUserDefaults] objectForKey:@"branch"];
    self.branchId = [[NSUserDefaults standardUserDefaults] objectForKey:@"branch_id"];
    self.picUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"picUrl"];
    
    _homeProvince = [[NSUserDefaults standardUserDefaults] objectForKey:@"home_province"];
    _homeCity = [[NSUserDefaults standardUserDefaults] objectForKey:@"home_city"];
    _homeZone = [[NSUserDefaults standardUserDefaults] objectForKey:@"home_zone"];
    _homeAddress = [[NSUserDefaults standardUserDefaults] objectForKey:@"home_address"];
    
    _workProvince = [[NSUserDefaults standardUserDefaults] objectForKey:@"work_province"];
    _workCity = [[NSUserDefaults standardUserDefaults] objectForKey:@"work_city"];
    _workZone = [[NSUserDefaults standardUserDefaults] objectForKey:@"work_zone"];
    _workAddress = [[NSUserDefaults standardUserDefaults] objectForKey:@"work_address"];

    _signUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"sign_url"];
}

- (void)clearUserInfo
{
    //self.userName =nil;
    self.userType = nil;
    self.userId = nil;
    self.accessToken = nil;
    
    self.name = nil;
    self.age = nil;
    self.operation = nil;
    self.sex = nil;
    self.tel = nil;
    self.branch = nil;
    self.branchId = nil;
    self.picUrl = nil;
    
    _homeProvince = nil;
    _homeCity = nil;
    _homeZone = nil;
    _homeAddress = nil;
    
    _workProvince = nil;
    _workCity = nil;
    _workZone = nil;
    _workAddress = nil;
    
    _signUrl = nil;
    
    //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userType"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"accessToken"];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"name"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"age"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"operation"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sex"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tel"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"branch"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"branch_id"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"picUrl"];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"home_province"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"home_city"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"home_zone"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"home_address"];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"work_province"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"work_city"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"work_zone"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"work_address"];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sign_url"];
    
}


@end
