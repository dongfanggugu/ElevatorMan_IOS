//
//  MaintenanceReminder.m
//  elevatorMan
//
//  Created by 长浩 张 on 15/12/14.
//
//X

#import <Foundation/Foundation.h>
#import "MaintenanceReminder.h"
#import "DateUtil.h"


#define ONE_DAY 24 * 3600

@implementation MaintenanceReminder
/**
 *  下一次电梯维保提醒距离当前时间的秒数
 *
 *  @param today      <#today description#>
 *  @param remindDate <#remindDate description#>
 */
+ (long long)getPlanDoneReminderIntervalSecondsFromNowToDeadDate:(NSDate *)deadDate {
    
    long long interval = 0;
    
    NSDate *initToday = [DateUtil initDateWithDate:[NSDate date] hour:@"10" minute:@"00" second:@"00"];
    NSDate *initDeadDate = [DateUtil initDateWithDate:deadDate hour:@"10" minute:@"00" second:@"00"];
    
    long long intervalSeconds = [DateUtil getIntervalSecondsFromStart:initToday end:initDeadDate];
    
    //如果大于等于3天，返回距离截止日三天的时间间隔
    if (intervalSeconds >= ONE_DAY * 3) {
        interval = [DateUtil getIntervalSecondsFromStart:[NSDate date] end:initDeadDate];
        interval -= ONE_DAY * 3;
        
    } else if (intervalSeconds < ONE_DAY * 3) {
        //如果小于三天，如果小于10点，返回到今天10点的时间差，
        //否则返回到明天上午10:00:00的时间差
        if (1 == [[NSDate date] compare:initToday]) {
            NSDate *tomorrow = [DateUtil addToDate:[NSDate date] days:1];
            NSDate *remindTime = [DateUtil initDateWithDate:tomorrow hour:@"10" minute:@"00" second:@"00"];
            interval = [DateUtil getIntervalSecondsFromStart:[NSDate date] end:remindTime];
        } else {
            interval = [DateUtil getIntervalSecondsFromStart:[NSDate date] end:initToday];
        }
        
    }
    
    
    return interval;
}


/**
 *  下一次指定维保计划提醒距离当前时间的秒数
 *
 *  @param lastFinishedDate <#lastFinishedDate description#>
 *
 *  @return <#return value description#>
 */
+ (long long)getPlanMakeReminderIntervalSecondsFromNowByLastFinishedDate:(NSDate *)lastFinishedDate {
    if (nil == lastFinishedDate) {
        return -1;
    }
    long long interval = 0;
    
    NSDate *initToday = [DateUtil initDateWithDate:[NSDate date] hour:@"10" minute:@"00" second:@"00"];
    NSDate *initFinshedDate = [DateUtil initDateWithDate:lastFinishedDate hour:@"10" minute:@"00" second:@"00"];
    
    long long intervalSeconds = [DateUtil getIntervalSecondsFromStart:initFinshedDate end:initToday];
    
    
    if (intervalSeconds < ONE_DAY * 3) {
        //如果小于3天，返回距离上次维保三天的时间间隔
        NSDate *remindDate = [DateUtil addToDate:lastFinishedDate days:3];
        NSDate *remindTime = [DateUtil initDateWithDate:remindDate hour:@"10" minute:@"00" second:@"00"];
        interval = [DateUtil getIntervalSecondsFromStart:[NSDate date] end:remindTime];
        
    } else {
        //如果大于等于3天，如果现在小于10点，返回到今天10点的时间差，否则返回到明天上午10点的时间差
        if (1 == [[NSDate date] compare:initToday]) {
            NSDate *tomorrow = [DateUtil addToDate:[NSDate date] days:1];
            NSDate *remindTime = [DateUtil initDateWithDate:tomorrow hour:@"10" minute:@"00" second:@"00"];
            interval = [DateUtil getIntervalSecondsFromStart:[NSDate date] end:remindTime];
        } else {
            interval = [DateUtil getIntervalSecondsFromStart:[NSDate date] end:initToday];
        }
    }
    
    return interval;
}

/**
 *  返回下一次维保过期提醒的时间距离当前时间的秒数
 *
 *  @param lastFinishedDate <#lastFinishedDate description#>
 *
 *  @return <#return value description#>
 */
+ (long long)getDeadLineReminderIntervalSecondsFromNowByLastFinishedDate:(NSDate *)lastFinishedDate {
    if (nil == lastFinishedDate) {
        return -1;
    }
    NSDate *deadLine = [DateUtil addToDate:lastFinishedDate days:15];
    
    return [self getPlanDoneReminderIntervalSecondsFromNowToDeadDate:deadLine];
}


+ (void)setPlanDoneReminderByIntervalSecons:(long long)intervale {
    
    NSArray *notificationArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    
    //取消之前的通知
    if (notificationArray != nil && notificationArray.count > 0) {
        for (UILocalNotification *notify in notificationArray) {
            if ([[notify.userInfo objectForKey:@"remindType"] isEqualToString:@"planDone"]) {
                [[UIApplication sharedApplication] cancelLocalNotification:notify];
                break;
            }
        }
    }
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification) {
        notification.alertBody = @"维保计划需要完成";
        notification.alertAction = @"维保计划需要完成";
        
        notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:intervale];
        
        notification.timeZone = [NSTimeZone systemTimeZone];
        
        notification.soundName = UILocalNotificationDefaultSoundName;
        
        NSMutableDictionary *notifyDic = [NSMutableDictionary dictionaryWithCapacity:1];
        [notifyDic setValue:@"planDone" forKey:@"remindType"];
    
        notification.userInfo = notifyDic;
        notification.repeatInterval = NSDayCalendarUnit;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

+ (void)setPlanMakeReminderByIntervalSecons:(long long)intervale {
    
    NSArray *notificationArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    
    //取消之前的通知
    if (notificationArray != nil && notificationArray.count > 0) {
        
        for (UILocalNotification *notify in notificationArray) {
            if ([[notify.userInfo objectForKey:@"remindType"] isEqualToString:@"planMake"]) {
                [[UIApplication sharedApplication] cancelLocalNotification:notify];
                break;
            }
        }
    }
    
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification) {
        notification.alertBody = @"您有电梯需要制定维保计划";
        notification.alertAction = @"您有电梯需要制定维保计划";
        
        notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:intervale];
        
        notification.timeZone = [NSTimeZone systemTimeZone];
        
        notification.soundName = UILocalNotificationDefaultSoundName;
        
        NSMutableDictionary *notifyDic = [NSMutableDictionary dictionaryWithCapacity:1];
        [notifyDic setValue:@"planMake" forKey:@"remindType"];
        
        notification.userInfo = notifyDic;
        notification.repeatInterval = NSDayCalendarUnit;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}


+ (void)setDeadLineReminderByIntervalSecons:(long long)intervale {
    
    NSArray *notificationArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
        
    //取消之前的通知
    if (notificationArray != nil && notificationArray.count > 0) {
        for (UILocalNotification *notify in notificationArray) {
            if ([[notify.userInfo objectForKey:@"remindType"] isEqualToString:@"deadLine"]) {
                [[UIApplication sharedApplication] cancelLocalNotification:notify];
                break;
            }
        }
    }
    
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification) {
        notification.alertBody = @"您有电梯维保即将过期";
        notification.alertAction = @"您有电梯维保即将过期";
        
        notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:intervale];
        
        notification.timeZone = [NSTimeZone systemTimeZone];
                
        notification.soundName = UILocalNotificationDefaultSoundName;
        
        NSMutableDictionary *notifyDic = [NSMutableDictionary dictionaryWithCapacity:1];
        [notifyDic setValue:@"deadLine" forKey:@"remindType"];
        
        notification.userInfo = notifyDic;
        notification.repeatInterval = NSDayCalendarUnit;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

/**
 *  取消所有的维保通知
 */
+ (void)cancelMaintenanceNofity {
    NSArray *notificationArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
    if (notificationArray != nil && notificationArray.count > 0) {
        for (UILocalNotification *notify in notificationArray) {
            if ([notify.userInfo objectForKey:@"remindType"] != nil) {
                [[UIApplication sharedApplication] cancelLocalNotification:notify];
                break;
            }
        }
    }

}

@end
