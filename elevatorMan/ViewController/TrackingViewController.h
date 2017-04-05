//
//  TrackingViewController.h
//  elevatorMan
//
//  Created by Cove on 15/6/16.
//
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"

@interface TrackingViewController : BaseViewController

@property (strong, nonatomic) NSString *alarmId;

- (void)getAlarmInfo;

@end
