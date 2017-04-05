//
//  AlarmInfo.hpp
//  chorstar
//
//  Created by 长浩 张 on 16/4/4.
//  Copyright © 2016年 长浩 张. All rights reserved.
//

#ifndef AlarmInfo_hpp
#define AlarmInfo_hpp

#include "PrefixHeader.h"
#include <string>
#include "json.h"
#include "WorkerInfo.hpp"
#include "CommunityInfo.hpp"
#include "ElevatorInfo.hpp"

class AlarmInfo
{
public:
    AlarmInfo(Json::Value value);
    ~AlarmInfo();
    
private:
    
    CC_PROPERTY(std::string, alarmTime, AlarmTime);
    CC_PROPERTY(WorkerInfo *, alarmUserInfo, AlarmUserInfo);
    CC_PROPERTY(CommunityInfo *, communityInfo, CommunityInfo);
    CC_PROPERTY(ElevatorInfo *, elevatorInfo, ElevatorInfo);
    CC_PROPERTY(std::string, id, Id);
    CC_PROPERTY(std::string, remark, Remark);
    CC_PROPERTY(std::string, state, State);
    CC_PROPERTY(std::string, userState, UserState);
    CC_PROPERTY(std::string, abandon, Abandon);
    CC_PROPERTY(std::string, receivedTime, ReceivedTime);
    
};

#endif /* AlarmInfo_hpp */
