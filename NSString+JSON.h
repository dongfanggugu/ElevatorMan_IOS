//
//  NSString+JSON.h
//  HBYDTPro2
//
//  Created by wangzhen on 16/1/28.
//  Copyright © 2016年 wangzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JSON)

+ (NSString *)jsonStringWithDictionary:(NSDictionary *)dictionary;

+ (NSString *)jsonStringWithArray:(NSArray *)array;

+ (NSString *)jsonStringWithString:(NSString *)string;

+ (NSString *)jsonStringWithObject:(id)object;

@end
