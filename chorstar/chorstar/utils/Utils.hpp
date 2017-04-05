//
//  Utils.hpp
//  chorstar
//
//  Created by 长浩 张 on 16/4/5.
//  Copyright © 2016年 长浩 张. All rights reserved.
//

#ifndef Utils_hpp
#define Utils_hpp

#include "PrefixHeader.h"
#include <stdio.h>
#include <string>
#include <vector>


/**
 *  根据分隔符分隔字符串
 *
 *  @param src     <#src description#>
 *  @param seprate <#seprate description#>
 *
 *  @return <#return value description#>
 */
std::vector<std::string> spliteString(std::string src, std::string seprate);


/**
 *  字符串转换为毫秒数
 *
 *  @param dateStr <#dateStr description#>
 *
 *  @return <#return value description#>
 */
long stringToSeconds(std::string dateStr);


/**
 *  获取当前毫秒数
 *
 *  @return <#return value description#>
 */
long getCurrentSeconds();


#endif /* Utils_hpp */
