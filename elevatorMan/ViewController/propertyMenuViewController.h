//
//  propertyMenuViewController.h
//  elevatorMan
//
//  Created by Cove on 15/6/23.
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol AlarmCancelDelegate<NSObject>

- (void)onReceivedAlarmCancel;

- (void)onReceivedAlarmFinished;

@end

@interface propertyMenuViewController : BaseViewController

@property (weak, nonatomic) id<AlarmCancelDelegate> delegate;

@end
