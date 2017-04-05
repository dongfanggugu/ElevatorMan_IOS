//
//  CommunityInfo.hpp
//  chorstar
//
//  Created by 长浩 张 on 16/4/4.
//  Copyright © 2016年 长浩 张. All rights reserved.
//

#ifndef CommunityInfo_hpp
#define CommunityInfo_hpp

#include "PrefixHeader.h"
#include <stdio.h>
#include <string>
#include "json.h"

using namespace std;
using namespace Json;
class CommunityInfo
{
public:
    CommunityInfo(Value jsonValue);
    ~CommunityInfo();
  
    CC_PROPERTY(string, address, Address);
    CC_PROPERTY(string, id, Id);
    CC_PROPERTY(string, lat, Lat);
    CC_PROPERTY(string, lng, Lng);
    CC_PROPERTY(string, name, Name);
    CC_PROPERTY(string, propertyUtel, PropertyUtel);
};

#endif /* CommunityInfo_hpp */
