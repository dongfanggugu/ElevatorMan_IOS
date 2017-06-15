//
//  RepairProcessController.h
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/6.
//
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, Repair_Process)
{
    Repair_Start,
    Repair_Arrive
};

@interface RepairProcessController : BaseViewController

@property (assign, nonatomic) Repair_Process process;

@property (strong, nonatomic) NSDictionary *taskInfo;

@end
