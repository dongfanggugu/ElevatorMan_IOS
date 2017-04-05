//
//  DateUtil.m
//  elevatorMan
//
//  Created by 长浩 张 on 15/12/14.
//
//

#import <Foundation/Foundation.h>
#import "DateUtil.h"

#define ONE_DAY 24 * 3600

@interface DateUtil()

@end

@implementation DateUtil


/**
 *  获取由字符串定义的两个日期的天数间隔
 *
 *  @param start <#start description#>
 *  @param end   <#end description#>
 *
 *  @return <#return value description#>
 */
+ (NSInteger)getIntervalDaysFromStringStart:(NSString *)start end:(NSString *)end {
    NSDate *startDate = [self yyyyMMddFromString:start];
    NSDate *endDate = [self yyyyMMddFromString:end];
    return [self getIntervalDaysFromStart:startDate end:endDate];
}


/**
 *  获取由NSDate定义的两个日期的天数间隔
 *
 *  @param start <#start description#>
 *  @param end   <#end description#>
 *
 *  @return <#return value description#>
 */
+ (NSInteger)getIntervalDaysFromStart:(NSDate *)start end:(NSDate *)end {
    NSDate *startDate = [self initDateWithDate:start hour:@"00" minute:@"00" second:@"00"];
    NSDate *endDate = [self initDateWithDate:end hour:@"01" minute:@"00" second:@"00"];
    
    if ( 1 == [startDate compare:endDate]) {
        return -1;
    }
    
    long long intervalSeconds = [[NSNumber numberWithDouble:[endDate timeIntervalSinceDate:startDate]] longLongValue];
    long long daySeconds = 24 * 3600 ;
    
    NSInteger intervalDays = intervalSeconds / daySeconds;
    
    return intervalDays;
}


/**
 *  通过字符串初始化日期和时间
 *
 *  @param dateStr <#dateStr description#>
 *  @param hour    <#hour description#>
 *  @param minute  <#minute description#>
 *  @param second  <#second description#>
 *
 *  @return <#return value description#>
 */
+ (NSDate *)initDateWithString:(NSString *)dateStr hour:(NSString *)hour minute:(NSString *)minute
                        second:(NSString *)second {
    NSDate *date = [self yyyyMMddFromString:dateStr];
    return [self addTimeToDate:date hour:hour minute:minute second:second];
}

/**
 *  通过NDDate形式的时间初始化时间
 *
 *  @param date   <#date description#>
 *  @param hour   <#hour description#>
 *  @param minute <#minute description#>
 *  @param second <#second description#>
 *
 *  @return <#return value description#>
 */
+ (NSDate *)initDateWithDate:(NSDate *)date hour:(NSString *)hour minute:(NSString *)minute
                     second:(NSString *)second {
    return [self addTimeToDate:date hour:hour minute:minute second:second];
}


/**
 *  在日期后面添加时间
 *
 *  @param date   <#date description#>
 *  @param hour   <#hour description#>
 *  @param minute <#minute description#>
 *  @param second <#second description#>
 *
 *  @return <#return value description#>
 */
+ (NSDate *)addTimeToDate:(NSDate *)date hour:(NSString *)hour minute:(NSString *)minute
                   second:(NSString *)second {
    NSString *dateStr = [self yyyyMMddFromDate:date];
    NSString *timeStr = [NSString stringWithFormat:@"%@:%@:%@", hour, minute, second];
    
    NSString *dateAndTimeStr = [NSString stringWithFormat:@"%@ %@", dateStr, timeStr];
    
    return [self yyyyMMddHHmmssFromString:dateAndTimeStr];
}

/**
 *  计算两个时间点相差的秒数
 *
 *  @param start <#start description#>
 *  @param end   <#end description#>
 *
 *  @return <#return value description#>
 */
+ (long long)getIntervalSecondsFromStart:(NSDate *)start end:(NSDate *)end {
    if ( 1 == [start compare:end]) {
        return -1;
    }
    
    return [[NSNumber numberWithDouble:[end timeIntervalSinceDate:start]] longLongValue];
}

/**
 根据格式化输出时间字符串
 **/
+ (NSString *)yyyyMMddFromDate:(NSDate *)date {
    NSString *format = @"yyyy-MM-dd";
    return [self stringFromDate:date format:format];
}

+ (NSString *)yyyyMMddHHmmssFromDate:(NSDate *)date {
    NSString *format = @"yyyy-MM-dd HH:mm:ss";
    return [self stringFromDate:date format:format];
}


+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:date];
}


/**
 根据格式化字符串输出时间
 **/
+ (NSDate *)dateFromString:(NSString *)dateStr format:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter dateFromString:dateStr];
}

+ (NSDate *)yyyyMMddFromString:(NSString *)dateStr {
    NSString *format = @"yyyy-MM-dd";
    return [self dateFromString:dateStr format:format];
}

+ (NSDate *)yyyyMMddHHmmssFromString:(NSString *)dateStr {
    NSString *format = @"yyyy-MM-dd HH:mm:ss";
    return [self dateFromString:dateStr format:format];
}

+ (NSDate *)addToDate:(NSDate *) date days:(NSInteger)days {
    long long seconds = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] longLongValue];
    long long intervalSeconds = days * ONE_DAY;
    return [NSDate dateWithTimeIntervalSince1970:seconds + intervalSeconds];
}

@end
