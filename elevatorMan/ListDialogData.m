//
//  ListDialogData.m
//  owner
//
//  Created by 长浩 张 on 2017/5/23.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "ListDialogData.h"

@implementation ListDialogData

- (id)initWithKey:(NSString *)key content:(NSString *)content
{
    if (self = [super init]) {
        self.key = key;
        self.content = content;
    }
    
    return self;
}

- (NSString *)getShowContent
{
    return _content;
}

- (NSString *)getKey
{
    return _key;
}


@end
