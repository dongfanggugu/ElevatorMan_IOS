//
//  DateUtil.h
//  elevatorMan
//
//  Created by 长浩 张 on 15/12/14.
//
//

#ifndef DateUtil_h
#define DateUtil_h


#endif /* DateUtil_h */

@interface DateUtil : NSObject


/**
 获取两个时间相差天数

 @param start <#start description#>
 @param end <#end description#>
 @return <#return value description#>
 */
+ (NSInteger)getIntervalDaysFromStart:(NSDate *)start end:(NSDate *)end;

+ (NSDate *)yyyyMMddFromString:(NSString *)dateStr;

+ (NSDate *)initDateWithDate:(NSDate *)date hour:(NSString *)hour minute:(NSString *)minute
                      second:(NSString *)second;
/**
 *  返回两个时间点相差的秒数
 *
 *  @param start <#start description#>
 *  @param end   <#end description#>
 *
 *  @return <#return value description#>
 */
+ (long long)getIntervalSecondsFromStart:(NSDate *)start end:(NSDate *)end;

/**
 *  在日期向后加天数
 *
 *  @param date <#date description#>
 *  @param days <#days description#>
 *
 *  @return <#return value description#>
 */
+ (NSDate *)addToDate:(NSDate *) date days:(NSInteger)days;

@end
