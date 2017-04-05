//
//  KnowledgeInfo.hpp
//  chorstar
//
//  Created by 长浩 张 on 16/4/5.
//  Copyright © 2016年 长浩 张. All rights reserved.
//

#ifndef KnowledgeInfo_hpp
#define KnowledgeInfo_hpp

#include "../PrefixHeader.h"
#include <stdio.h>
#include <string>

class CKnowledgeInfo
{
public:
    CKnowledgeInfo(std::string knId, std::string title, std::string keywords, std::string knType,
                  std::string brand);
    ~CKnowledgeInfo();


    
    CC_PROPERTY(std::string, knId, KnId);
    CC_PROPERTY(std::string, title, Title);
    CC_PROPERTY(std::string, keywords,Keywords);
    CC_PROPERTY(std::string, knType, KnType);
    CC_PROPERTY(std::string, brand, Brand);
};

#endif /* KnowledgeInfo_hpp */
