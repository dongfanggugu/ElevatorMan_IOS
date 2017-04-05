//
//  chorstar.m
//  chorstar
//
//  Created by 长浩 张 on 16/4/3.
//  Copyright © 2016年 长浩 张. All rights reserved.
//

#include "Chorstar.h"

#include "PrefixHeader.h"
#include "curl.h"
#include <iostream>
#include "AlarmInfo.hpp"
#include "RequestHead.hpp"
#include "sqlite3.h"
#include "KnowledgeInfo.hpp"
#include <vector>
#include "Utils.hpp"


using namespace std;
using namespace Json;

string getLatestTime(string);

void updateKnowledge(string, string);

bool hasUnassigned(string response, int waitSeconds);

bool hasUnfinished(string response);

int updateKnowledgeDB(string, string, string, string, string, string, string, string, string, string);


string getVersion()
{
    return curl_version();
}

/**
 *  libcurl请求网络回调函数
 *
 *  @param buffer   <#buffer description#>
 *  @param size     <#size description#>
 *  @param nmemb    <#nmemb description#>
 *  @param response <#response description#>
 *
 *  @return <#return value description#>
 */
size_t writeFunction(void *buffer, size_t size, size_t nmemb, void *response)
{
    if (response == NULL)
    {
        return 0;
    }
    size_t len = size * nmemb;
    ((string *)response)->append((char *)buffer, len);
    
    return len;
}
/**
 *  request for the lastest update of the knowledge
 *
 *  @param dbpath   <#dbpath description#>
 *  @param address  <#address description#>
 *  @param osType   <#osType description#>
 *  @param deviceId <#deviceId description#>
 *  @param token    <#token description#>
 *  @param userId   <#userId description#>
 */
void requestKnowledgeUpdate(string dbpath, string address, string osType, string deviceId, string token,
                            std::string userId)
{
    RequestHead *head = new RequestHead(osType, deviceId, token, userId);
    Value root;
    root["head"] = head->getHead();
    delete head;
    
    Json::Value body;
    body["createTime"] = getLatestTime(dbpath);
    root["body"] = body;
    
    string url = address + "getKnowledge";
    
    FastWriter writer;
    string strRequest = writer.write(root);
    
    CURL *curl = curl_easy_init();
    CURLcode res;
    
    string response;
    
    
    if (curl)
    {
        curl_slist *plist = curl_slist_append(NULL, "Content-Type:application/json;charset=UTF-8");
        
        curl_easy_setopt(curl, CURLOPT_HTTPHEADER, plist);
        
        curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
        curl_easy_setopt(curl, CURLOPT_TIMEOUT, 30);
        curl_easy_setopt(curl, CURLOPT_COOKIEFILE, "/tmp/cookie.txt");
        curl_easy_setopt(curl, CURLOPT_POSTFIELDS, strRequest.c_str());
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, writeFunction);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &response);
        
        res = curl_easy_perform(curl);
        
        cout << endl;
        cout << "res:" << res << endl;
    }
    
    curl_easy_cleanup(curl);
    //cout << "response" << gResponse << endl;
    
    if (0 == res)
    {
        updateKnowledge(dbpath, response);
    }
}

/**
 *  更新知识库
 *
 *  @param dbpath <#dbpath description#>
 *  @param json   <#json description#>
 */
void updateKnowledge(std::string dbpath, std::string json)
{
    Json::Reader reader;
    Json::Value root;
    
    if (reader.parse(json, root))
    {
        Json::Value head = root["head"];
        std::string rspCode = head["rspCode"].asString();
        if (rspCode != "0")
        {
            cout << "request knowledge update failed";
            return;
        }
        
        Json::Value body = root["body"];
        int count = body.size();
        cout << "count:" << count << endl;
        
        Json::ValueIterator ite = body.begin();
        for (;ite != body.end(); ite++)
        {
            string id = (*ite)["id"].asString();
            string brand = (*ite)["brand"].asString();
            string content = (*ite)["content"].asString();
            string keywords = (*ite)["keywords"].asString();
            string knType = (*ite)["kntype"].asString();
            string model = (*ite)["model"].asString();
            string parts = (*ite)["parts"].asString();
            string title = (*ite)["title"].asString();
            string createTime = (*ite)["createTime"].asString();
            
            int result = updateKnowledgeDB(dbpath, id, brand, content, keywords, knType, model,
                                           parts, title, createTime);
            cout << "result:" << result << endl;
        }
    }
}



/**
 *  get the latest time of the knowledge
 *
 *  @param dbpath <#dbpath description#>
 *
 *  @return <#return value description#>
 */
string getLatestTime(string dbpath)
{
    sqlite3 *db;
    int result = sqlite3_open(dbpath.c_str(), &db);
    if (result != SQLITE_OK)
    {
        return "";
    }
    
    string createTime;
    
    string sql = "select max(createTime) from knowledge";
    
    sqlite3_stmt *stmp = NULL;
    
    if (sqlite3_prepare_v2(db, sql.c_str(), -1, &stmp, NULL) == SQLITE_OK)
    {
        if (sqlite3_step(stmp) == SQLITE_ROW)
        {
            const unsigned char *value = sqlite3_column_text(stmp, 0);
            
            createTime = (const char *)value;
            
            cout << "create time:" << createTime << endl;
        }
        sqlite3_finalize(stmp);
    }
    
    sqlite3_close(db);
    
    cout << "create time:" << createTime << endl;
    
    return createTime;
}


string getSel(vector<string> selArgs);

/**
 *  根据品牌和关键字查询知识库
 *
 *  @param dbpath <#dbpath description#>
 *  @param db     <#db description#>
 *  @param sql    <#sql description#>
 */
vector<CKnowledgeInfo *>* cqueryBySelection(string dbpath, string brand, string keyword)
{
    sqlite3 *db;
    
    int result = sqlite3_open(dbpath.c_str(), &db);
    if (result != SQLITE_OK)
    {
        return nullptr;
    }
    
    //seprate the keywords with space
    vector<string> keywordList = spliteString(keyword, " ");
    
    vector<string> selArgs;
    
    if (keywordList.size() > 0)
    {
        for (int i = 0; i < keywordList.size(); i++)
        {
            string key = keywordList[i];
            string selTitle = "title like '%" + key + "%'";
            string selKeywords = "keywords like '%" + key + "%'";
            selArgs.push_back(selTitle);
            selArgs.push_back(selKeywords);
        }
    }
    
    string sql;
    
    if (brand == "全部")
    {
        if (0 == selArgs.size())
        {
            sql = "select id, title, keywords, kntype, brand from knowledge";
        }
        else
        {
            sql = "select id, title, keywords, kntype, brand from knowledge where " + getSel(selArgs);
        }
    }
    else
    {
        if (0 == selArgs.size())
        {
            sql = "select id, title, keywords, kntype, brand from knowledge where brand like '%" + brand + "%'";
        }
        else
        {
            sql = "select id, title, keywords, kntype, brand from knowledge where brand like '%" + brand
            + "%'"+ " and " + getSel(selArgs);
        }
    }
    
    sqlite3_stmt *stmp = NULL;
    
    vector<CKnowledgeInfo *>* knowledgeList = new vector<CKnowledgeInfo *>();
    
    if (sqlite3_prepare_v2(db, sql.c_str(), -1, &stmp, NULL) == SQLITE_OK)
    {
        while (sqlite3_step(stmp) == SQLITE_ROW)
        {
            const unsigned char *kId = sqlite3_column_text(stmp, 0);
            const unsigned char *title = sqlite3_column_text(stmp, 1);
            const unsigned char *keywords = sqlite3_column_text(stmp, 2);
            const unsigned char *kntype = sqlite3_column_text(stmp, 3);
            const unsigned char *brand = sqlite3_column_text(stmp, 4);
            
            CKnowledgeInfo *info = new CKnowledgeInfo((char *)kId, (char *)title, (char *)keywords,
                                                    (char *)kntype, (char *)brand);
            knowledgeList->push_back(info);
        }
        
        sqlite3_finalize(stmp);
    }
    sqlite3_close(db);
    
    return knowledgeList;
}

vector<string>* cqueryBrand(string dbpath)
{
    sqlite3 *db;
    
    int result = sqlite3_open(dbpath.c_str(), &db);
    if (result != SQLITE_OK)
    {
        return nullptr;
    }
    
    string sql = "select distinct brand from knowledge";
    
    sqlite3_stmt *stmp = NULL;
    
    vector<string> *brandList = new vector<string>();
    
    if (sqlite3_prepare_v2(db, sql.c_str(), -1, &stmp, NULL) == SQLITE_OK)
    {
        while (sqlite3_step(stmp) == SQLITE_ROW)
        {
            const unsigned char *brand = sqlite3_column_text(stmp, 0);
            brandList->push_back((char *)brand);
        }
        
        sqlite3_finalize(stmp);
    }
    
    sqlite3_close(db);
    
    return brandList;
}


/**
 *  generate sql seletions by selection args
 *
 *  @param selArgs <#selArgs description#>
 *
 *  @return <#return value description#>
 */
string getSel(vector<string> selArgs)
{
    string result = "";
    for (int i = 0; i < selArgs.size(); i++)
    {
        string sel  = selArgs[i];
        if (i != selArgs.size() - 1)
        {
            result += sel + " OR ";
        }
        else
        {
            result += sel;
        }
    }
    return result;
}

/**
 *  更新或者插入知识库数据
 *
 *  @param dbpath     <#dbpath description#>
 *  @param id         <#id description#>
 *  @param brand      <#brand description#>
 *  @param content    <#content description#>
 *  @param keywords   <#keywords description#>
 *  @param knType     <#knType description#>
 *  @param model      <#model description#>
 *  @param parts      <#parts description#>
 *  @param title      <#title description#>
 *  @param createTime <#createTime description#>
 *
 *  @return <#return value description#>
 */
int updateKnowledgeDB(string dbpath, string id, string brand, string content, string keywords,
                       string knType, string model, string parts, string title, string createTime)
{
    cout << "sql path:" << dbpath << endl;
    sqlite3 *db;
    int result = sqlite3_open(dbpath.c_str(), &db);
    if (result != SQLITE_OK)
    {
        cout << "open knowledge database failed!" << endl;
        return 0;
    }
    
    string sqlQuery = "select count(*) from knowledge where id = '" + id + "'";
    
    
    int curCount = 0;
    
    sqlite3_stmt *stmp = NULL;
    
    if (sqlite3_prepare_v2(db, sqlQuery.c_str(), -1, &stmp, NULL) == SQLITE_OK)
    {
        if (sqlite3_step(stmp))
        {
            curCount = sqlite3_column_int(stmp, 0);
        }
    }
    sqlite3_finalize(stmp);
    cout << "curCount:" << curCount << endl;
    
    int uResult = 0;
    
    stmp = NULL;
    if (curCount)
    {
        string sqlUpdate = "update knowledge set id = ?, brand = ?, content = ?, keywords = ?, knType \
        = ?, model = ?, parts = ?, title = ?, createTime = ?, up = 0, down = 0 where id = ?";
        
//        string sqlUpdate = "update knowledge set id = '" + id + "', brand = '" + brand + "', content = \
//        '" + content + "', keywords = '" + keywords + "', knType = '" + knType + "', model = '" + model + \
//        "', parts = '" + parts + "', title = '" + title + "', createTime = '" + createTime + \
//        "' where id = '" + id + "'";
        
        if (sqlite3_prepare_v2(db, sqlUpdate.c_str(), -1, &stmp, NULL) == SQLITE_OK)
        {
            sqlite3_bind_text(stmp, 1, id.c_str(), -1, NULL);
            sqlite3_bind_text(stmp, 2, brand.c_str(), -1, NULL);
            sqlite3_bind_text(stmp, 3, content.c_str(), -1, NULL);
            sqlite3_bind_text(stmp, 4, keywords.c_str(), -1, NULL);
            sqlite3_bind_text(stmp, 5, knType.c_str(), -1, NULL);
            sqlite3_bind_text(stmp, 6, model.c_str(), -1, NULL);
            sqlite3_bind_text(stmp, 7, parts.c_str(), -1, NULL);
            sqlite3_bind_text(stmp, 8, title.c_str(), -1, NULL);
            sqlite3_bind_text(stmp, 9, createTime.c_str(), -1, NULL);
            sqlite3_bind_text(stmp, 10, id.c_str(), -1, NULL);
        }
        
        cout << "content:" << content << endl;
        
        int uResult = sqlite3_step(stmp);
        cout << "update result:" << uResult << endl;
        if (uResult != SQLITE_DONE)
        {
            cout << "update failed! failed code:" << uResult << endl;
        }
        
        sqlite3_finalize(stmp);
    }
    else
    {
        string sqlInsert = "insert into knowledge values(?, ?, ?, ?, ?, ?, ?, ?, ?, 0, 0)";
        if (sqlite3_prepare_v2(db, sqlInsert.c_str(), -1, &stmp, NULL) == SQLITE_OK)
        {
            sqlite3_bind_text(stmp, 1, id.c_str(), -1, NULL);
            sqlite3_bind_text(stmp, 2, title.c_str(), -1, NULL);
            sqlite3_bind_text(stmp, 3, keywords.c_str(), -1, NULL);
            sqlite3_bind_text(stmp, 4, content.c_str(), -1, NULL);
            sqlite3_bind_text(stmp, 5, knType.c_str(), -1, NULL);
            sqlite3_bind_text(stmp, 6, parts.c_str(), -1, NULL);
            sqlite3_bind_text(stmp, 7, brand.c_str(), -1, NULL);
            sqlite3_bind_text(stmp, 8, model.c_str(), -1, NULL);
            sqlite3_bind_text(stmp, 9, createTime.c_str(), -1, NULL);
        }
        
        uResult = sqlite3_step(stmp);
        if (uResult != SQLITE_DONE)
        {
            cout << "insert failed, fail code:" << uResult << endl;
        }
    }
    
    return uResult;
}

/**
 *  判断是否有没有完成的报警
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
              std::string userId)
{
    RequestHead *head = new RequestHead(osType, deviceId, token, userId);
    Value root;
    root["head"] = head->getHead();
    delete head;
    
    string url = address + "getAlarmListByReceiveAndUnassign";
    FastWriter writer;
    string strRequest = writer.write(root);
    
    std::string response;
    CURL *curl = curl_easy_init();
    
    if (curl)
    {
        curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
        curl_easy_setopt(curl, CURLOPT_TIMEOUT, 30);
        curl_easy_setopt(curl, CURLOPT_COOKIEFILE, "/tmp/cookie.txt");
        curl_easy_setopt(curl, CURLOPT_POSTFIELDS, strRequest.c_str());
        //curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, writeFunction);
        //curl_easy_setopt(curl, CURLOPT_WRITEDATA, &gResponse);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &response);
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, writeFunction);
        
        CURLcode res = curl_easy_perform(curl);
        
        cout << endl << "res:" << res << endl;
        
        if (res == CURLE_OK)
        {
            //cout << "response:" + response;
            return hasUnassigned(response, 120);
        }
    
        
    }
    
    return false;
    
}

/**
 *  返回是否有未完成的报警
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
              std::string userId)
{
    RequestHead *head = new RequestHead(osType, deviceId, token, userId);
    Value root;
    root["head"] = head->getHead();
    delete head;
    
    Value body;
    body["scope"] = "unfinished";
    root["body"] = body;
    
    
    string url = address + "getAlarmListByRepairUserId";
    FastWriter writer;
    string strRequest = writer.write(root);
    
    std::string response;
    CURL *curl = curl_easy_init();
    
    if (curl)
    {
        curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
        curl_easy_setopt(curl, CURLOPT_TIMEOUT, 30);
        curl_easy_setopt(curl, CURLOPT_COOKIEFILE, "/tmp/cookie.txt");
        curl_easy_setopt(curl, CURLOPT_POSTFIELDS, strRequest.c_str());
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &response);
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, writeFunction);
        
        CURLcode res = curl_easy_perform(curl);
        
        cout << endl << "res:" << res << endl;
        
        if (res == CURLE_OK)
        {
            //cout << "response:" + response;
            return hasUnfinished(response);
        }
    
        
    }
    
    return false;
    
}

/**
 *  判断是否有未处理完成的报警
 *
 *  @param json <#json description#>
 *
 *  @return <#return value description#>
 */
bool hasUnfinished(string json)
{
    Json::Reader reader;
    Json::Value root;
    if (reader.parse(json, root))
    {
        Json::Value head = root["head"];
        string rspCode = head["rspCode"].asString();
        if (rspCode != "0")
        {
            cout << "res code:" << rspCode << endl;
            cout << "errMes:" << rspCode << root["rspMsg"].asString() << endl;
            return false;
        }
        
        Json::Value body = root["body"];
        int count = body.size();
        
        if (count > 0)
        {
            return true;
        }
        
    }
    return false;
}

bool hasUnassigned(string json, int waitSeconds)
{
    Json::Reader reader;
    Json::Value root;
    if (reader.parse(json, root))
    {
        Json::Value head = root["head"];
        string rspCode = head["rspCode"].asString();
        if (rspCode != "0")
        {
            cout << "res code:" << rspCode << endl;
            cout << "errMes:" << rspCode << root["rspMsg"].asString() << endl;
            return false;
        }
        
        Json::Value body = root["body"];
        int count = body.size();
        
        if (count > 0)
        {
            Json::ValueIterator ite = body.begin();
            for (;ite != body.end(); ite++)
            {
                string alarmTime = (*ite)["alarmTime"].asString();
                cout << "alarmTime:" << alarmTime << endl;
                long curSeconds = getCurrentSeconds();
                long alarmSeconds = stringToSeconds(alarmTime);
                long interval = curSeconds - alarmSeconds;
                
                if (interval > waitSeconds * 1.5)
                {
                    return false;
                }
            }
            
            return true;
        }
        
    }
    return false;
}

/**
 *  判断是否报警时间
 *
 *  @param alarmTime <#alarmTime description#>
 *  @param timeout   <#timeout description#>
 *
 *  @return <#return value description#>
 */
bool showUnassignedAlarm(std::string alarmTime, int timeout)
{
    long curSeconds = getCurrentSeconds();
    long alarmSeconds = stringToSeconds(alarmTime);
    long interval = curSeconds - alarmSeconds;
    
    if (interval > timeout)
    {
        return false;
    }
    return true;
}
