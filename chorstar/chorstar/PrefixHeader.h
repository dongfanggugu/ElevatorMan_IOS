//
//  PrefixHeader.h
//  chorstar
//
//  Created by 长浩 张 on 16/4/4.
//  Copyright © 2016年 长浩 张. All rights reserved.
//

#ifndef PrefixHeader_h
#define PrefixHeader_h

#include "stdio.h"
#include <string>
#include "../jsoncpp/include/json/json.h"

#define CC_PROPERTY(varType, varName, funName)\
private:varType varName;\
public:varType get##funName(void);\
public:void set##funName(varType var);



#endif /* PrefixHeader_h */
