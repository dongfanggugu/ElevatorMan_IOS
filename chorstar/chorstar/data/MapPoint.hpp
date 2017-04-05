//
//  MapPoint.hpp
//  chorstar
//
//  Created by 长浩 张 on 16/4/4.
//  Copyright © 2016年 长浩 张. All rights reserved.
//

#ifndef MapPoint_hpp
#define MapPoint_hpp
#include "PrefixHeader.h"
#include <stdio.h>

struct MapPoint
{
    double lat;
    double lng;
};

typedef MapPoint MapPoint;

inline MapPoint MapPointMake(double lat, double lng)
{
    MapPoint mapPoint;
    mapPoint.lat = lat;
    mapPoint.lng = lng;
    
    return mapPoint;
}

#endif /* MapPoint_hpp */
