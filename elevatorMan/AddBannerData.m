//
//  AddBannerData.m
//  owner
//
//  Created by 长浩 张 on 2017/1/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddBannerData.h"

@interface AddBannerData ()

@property (copy, nonatomic) NSString *picUrl;

@property (copy, nonatomic) NSString *clickUrl;

@end

@implementation AddBannerData

- (instancetype)initWithUrl:(NSString *)url clickUrl:(NSString *)clickUrl
{
    self = [super init];
    if (self)
    {
        _picUrl = url;
        _clickUrl = clickUrl;
    }

    return self;
}

- (NSString *)getPicUrl
{
    return _picUrl;
}

- (NSString *)getClickUrl
{
    return _clickUrl;
}

@end
