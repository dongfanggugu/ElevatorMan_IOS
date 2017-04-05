//
//  chorstar.h
//  chorstar
//
//  Created by 长浩 张 on 16/4/3.
//  Copyright © 2016年 长浩 张. All rights reserved.
//

#include "stdio.h"
#include <string>
#include <vector>
#include "data/KnowledgeInfo.hpp"

std::string getVersion();

std::vector<CKnowledgeInfo *>* cqueryBySelection(std::string dbpath, std::string brand,
                                                std::string keyword);
/**
 *  查询知识库的品牌
 *
 *  @param dbpath <#dbpath description#>
 *
 *  @return <#return value description#>
 */
std::vector<std::string>* cqueryBrand(std::string dbpath);

/**
 *  请求更新知识库
 *
 *  @param dbpath   <#dbpath description#>
 *  @param address  <#address description#>
 *  @param osType   <#osType description#>
 *  @param deviceId <#deviceId description#>
 *  @param token    <#token description#>
 *  @param userId   <#userId description#>
 */
void requestKnowledgeUpdate(std::string dbpath, std::string address, std::string osType,
                            std::string deviceId, std::string token, std::string userId);
/**
 *  判断是否有未处理的报警任务
 *
 *  @param address    <#address description#>
 *  @param osType     <#osType description#>
 *  @param deviceId   <#deviceId description#>
 *  @param std::token <#std::token description#>
 *  @param userId     <#userId description#>
 *
 *  @return <#return value description#>
 */
bool hasAlarmUnassigned(std::string address, std::string osType, std::string deviceId, std::string token,
              std::string userId);


/**
 *  判断是否有没有完成的任务
 *
 *  @param address  <#address description#>
 *  @param osType   <#osType description#>
 *  @param deviceId <#deviceId description#>
 *  @param token    <#token description#>
 *  @param userId   <#userId description#>
 *
 *  @return <#return value description#>
 */
bool hasAlarmUnfinished(std::string address, std::string osType, std::string deviceId, std::string token,
              std::string userId);

/**
 *  判断未指派的报警是否超期
 *
 *  @param alarmTime <#alarmTime description#>
 *
 *  @return <#return value description#>
 */
bool showUnassignedAlarm(std::string alarmTime, int timeout);
