//
//  AlarmProcessViewController.h
//  elevatorMan
//
//  Created by Cove on 15/6/26.
//
//

#import <UIKit/UIKit.h>
#import "WorkerMenuViewController.h"

@interface AlarmProcessViewController : UIViewController<AlarmCancelDelegate>

@property (nonatomic ,strong)NSString *alarmId;

@property NSInteger userState;

@end
