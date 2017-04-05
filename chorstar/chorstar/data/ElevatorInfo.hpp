//
//  ElevatorInfo.hpp
//  chorstar
//
//  Created by 长浩 张 on 16/4/4.
//  Copyright © 2016年 长浩 张. All rights reserved.
//

#ifndef ElevatorInfo_hpp
#define ElevatorInfo_hpp

#include "PrefixHeader.h"
#include <stdio.h>
#include <string>
#include "json.h"

class ElevatorInfo
{
public:
    ElevatorInfo(Json::Value value);
    ~ElevatorInfo();
    
    CC_PROPERTY(std::string, id, Id);
    CC_PROPERTY(std::string, unitCode, UnitCode);
    CC_PROPERTY(std::string, liftNum, LiftNum);
    CC_PROPERTY(std::string, num, Num);
};

#endif /* ElevatorInfo_hpp */
