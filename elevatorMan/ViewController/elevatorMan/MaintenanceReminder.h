//
//  MaintenanceReminder.h
//  elevatorMan
//
//  Created by 长浩 张 on 15/12/14.
//
//

#ifndef MaintenanceReminder_h
#define MaintenanceReminder_h


#endif /* MaintenanceReminder_h */

/**
 ** 指定维保计划的提醒时间，包括维保计划完成提醒，维保计划制定提醒以及维保超期提醒。
 ** 提醒的规则:查找距离当前时间最近的提醒，然后设置每天上午10:00:00提醒一次，当用
 ** 户进入维保页面时，会取消之前设置的提醒，并重新设置提醒
 */
@interface MaintenanceReminder : NSObject

/**
 *  下一次电梯维保提醒距离当前时间的秒数
 *
 *  @param today      <#today description#>
 *  @param remindDate <#remindDate description#>
 */
+ (long long)getPlanDoneReminderIntervalSecondsFromNowToDeadDate:(NSDate *)deadDate;

/**
 *  下一次制定维保计划提醒距离当前时间的秒数
 *
 *  @param lastFinishedDate <#lastFinishedDate description#>
 *
 *  @return <#return value description#>
 */
+ (long long)getPlanMakeReminderIntervalSecondsFromNowByLastFinishedDate:(NSDate *)lastFinishedDate;

/**
 *  下一次维保过期距离当前时间的秒数
 *
 *  @param setPlanMakeReminderByIntervalSecons <#setPlanMakeReminderByIntervalSecons description#>
 *  @param intervale                           <#intervale description#>
 *
 *  @return <#return value description#>
 */
+ (long long)getDeadLineReminderIntervalSecondsFromNowByLastFinishedDate:(NSDate *)lastFinishedDate;


/**
 *  设置维保计划完成的提醒
 *
 *  @param intervale <#intervale description#>
 */
+ (void)setPlanDoneReminderByIntervalSecons:(long long)intervale;


/**
 *  设置计划制定的提醒
 *
 *  @param intervale <#intervale description#>
 */
+ (void)setPlanMakeReminderByIntervalSecons:(long long)intervale;


/**
 *  设置维保过期的提醒
 *
 *  @param intervale <#intervale description#>
 */
+ (void)setDeadLineReminderByIntervalSecons:(long long)intervale;


/**
 *  取消所有的维保通知
 */
+ (void)cancelMaintenanceNofity;

@end
