//
//  Constant.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/12/14.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef Constant_h
#define Constant_h


#define ALARM_ASSIGN_TIME_OUT 300

#pragma mark - 客服电话

#define Custom_Service @"400-919-6333"


#pragma mark - 用户类型

typedef NS_ENUM(NSInteger, RoleType)
{
    Role_Com = 1,
    ROle_Pro,
    Role_Worker
};


#pragma mark - 电梯商城

typedef NS_ENUM(NSInteger, Market_Type) {

    Market_Lift,  //整体销售

    Market_Decorate,  //电梯装潢

    Market_Msg  //留言
};


#endif /* Constant_h */
