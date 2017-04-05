//
//  RequestHeader.cpp
//  chorstar
//
//  Created by 长浩 张 on 16/4/4.
//  Copyright © 2016年 长浩 张. All rights reserved.
//

#include "RequestHead.hpp"
using namespace std;

RequestHead::RequestHead(string osType, string deviceId, string accessToken,
                         string userId)
{
    this->osType = osType;
    this->deviceId = deviceId;
    this->accessToken = accessToken;
    this->userId = userId;
}

RequestHead::~RequestHead()
{
    
}

Json::Value RequestHead::getHead()
{
    Json::Value head;
    head["osType"] = this->osType;
    head["deviceId"] = this->deviceId;
    head["accessToken"] = this->accessToken;
    head["userId"] = this->userId;
    
    return head;
}
