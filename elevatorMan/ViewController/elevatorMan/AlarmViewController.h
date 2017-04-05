//
//  AlarmViewController.h
//  elevatorMan
//
//  Created by 长浩 张 on 16/7/4.
//
//

#ifndef AlarmViewController_h
#define AlarmViewController_h

#import <UIKit/UIKit.h>
#import "BaseViewController.h"


typedef NS_ENUM(NSInteger, AlarmType)
{
    TYPE_RECEIVED,
    TYPE_ARRIVED
};

@interface AlarmViewController : BaseViewController

@property (strong, nonatomic) NSString *alarmId;

@property (nonatomic) AlarmType state;

@end

#endif /* AlarmViewController_h */
