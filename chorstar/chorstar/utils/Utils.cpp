//
//  Utils.cpp
//  chorstar
//
//  Created by 长浩 张 on 16/4/5.
//  Copyright © 2016年 长浩 张. All rights reserved.
//

#include "Utils.hpp"

using namespace std;


/**
 *  根据分隔符分隔字符创
 *
 *  @param src     <#src description#>
 *  @param seprate <#seprate description#>
 *
 *  @return <#return value description#>
 */
std::vector<std::string> spliteString(std::string src, std::string seprate)
{
    vector<string> strList;
    int seIndex = 0;
    
    do
    {
        string tempString = "";
        seIndex = src.find(seprate);
        
        if (-1 == seIndex)
        {
            tempString = src.substr(0, src.length());
            strList.push_back(tempString);
            break;
        }
        
        tempString = src.substr(0, seIndex);
        src.erase(0, seIndex + 1);
        strList.push_back(tempString);
    }
    while (true);
    
    return strList;
}

/**
 *  字符串转换为毫秒
 *
 *  @param dateStr <#dateStr description#>
 *
 *  @return 返回字符串毫秒数
 */
long stringToSeconds(std::string dateStr)
{
    tm tm;
    
    //秒
    time_t t;

    
    char buf[128] = {0};
    
    strcpy(buf, dateStr.c_str());
    strptime(buf, "%Y-%m-%d %H:%M:%S", &tm);
    
    tm.tm_isdst = -1;
    t = mktime(&tm);
    
    return t;
}

/**
 *  获取当前毫秒数
 *
 *  @return 毫秒数
 */
long getCurrentSeconds()
{
    time_t t;
    tm *local;
    tm *gmt;
    char buf[128] = {0};
    
    //获取当前的秒数
    t = time(NULL);
    
    //转换为本地时间
    local = localtime(&t);
    
    return t;
}
