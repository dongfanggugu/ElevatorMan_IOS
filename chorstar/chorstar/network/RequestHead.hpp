//
//  RequestHead.hpp
//  chorstar
//
//  Created by 长浩 张 on 16/4/4.
//  Copyright © 2016年 长浩 张. All rights reserved.
//

#ifndef RequestHead_hpp
#define RequestHead_hpp

#include "PrefixHeader.h"

class RequestHead
{
public:
    RequestHead(std::string osType, std::string deviceId, std::string accessToken,
                std::string userId);
    ~RequestHead();
    
    Json::Value getHead();
    
    CC_PROPERTY(std::string, osType, OsType);
    CC_PROPERTY(std::string, userId, UserId);
    CC_PROPERTY(std::string, deviceId, DeviceId);
    CC_PROPERTY(std::string, accessToken, AccessToken);
};

#endif /* RequestHeader_hpp */
