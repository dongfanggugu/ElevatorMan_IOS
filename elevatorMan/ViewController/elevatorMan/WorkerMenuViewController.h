//
//  WorkerMenuViewController.h
//  elevatorMan
//
//  Created by Cove on 15/6/23.
//
//

#import <UIKit/UIKit.h>

@protocol AlarmCancelDelegate <NSObject>

- (void)onReceiveAlarmCancelMessage;

@end

@interface WorkerMenuViewController : UIViewController

@property (strong, nonatomic) id <AlarmCancelDelegate> delegate;

@end
