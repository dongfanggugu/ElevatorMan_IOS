//
//  KnowledgeInfo.cpp
//  chorstar
//
//  Created by 长浩 张 on 16/4/5.
//  Copyright © 2016年 长浩 张. All rights reserved.
//

#include "KnowledgeInfo.hpp"
#include "../utils/Utils.hpp"
using namespace std;

CKnowledgeInfo::CKnowledgeInfo(string knId, string title, string keywords, string knType, string brand)
{
    this->knId = knId;
    this->title = title;
    this->keywords = keywords;
    this->knType = knType;
    this->brand = brand;
}

CKnowledgeInfo::~CKnowledgeInfo()
{

}

string CKnowledgeInfo::getKnId()
{
    return this->knId;
}

string CKnowledgeInfo::getBrand()
{
    return this->brand;
}

string CKnowledgeInfo::getTitle()
{
    return this->title;
}

string CKnowledgeInfo::getKnType()
{
    return this->knType;
}

string CKnowledgeInfo::getKeywords()
{
    return this->keywords;
}
