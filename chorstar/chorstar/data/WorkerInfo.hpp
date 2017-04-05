//
//  WorkerInfo.hpp
//  chorstar
//
//  Created by 长浩 张 on 16/4/4.
//  Copyright © 2016年 长浩 张. All rights reserved.
//

#ifndef WorkerInfo_hpp
#define WorkerInfo_hpp

#include "PrefixHeader.h"
#include <stdio.h>
#include <string>
#include <vector>
#include "MapPoint.hpp"
#include "json.h"

using namespace std;

class WorkerInfo
{
public:
    WorkerInfo(Json::Value value);
    ~WorkerInfo();
private:
    
    CC_PROPERTY(string, name, Name);
    CC_PROPERTY(string, tel, Tel);
    CC_PROPERTY(string, lat, Lat);
    CC_PROPERTY(string, lng, Lng);
    CC_PROPERTY(string, state, State);
    CC_PROPERTY(string, userId, UserId);
    CC_PROPERTY(vector<MapPoint>, points, Points);
};


#endif /* WorkerInfo_hpp */
