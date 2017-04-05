//
//  PlanViewController.h
//  elevatorMan
//
//  Created by 长浩 张 on 15/12/10.
//
//

#ifndef PlanViewController_h
#define PlanViewController_h
#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"


#endif /* PlanViewController_h */

@interface PlanViewController : BaseTableViewController


@property (strong, nonatomic) NSString *flag;

@property (strong, nonatomic) NSString *liftId;

@property (strong, nonatomic) NSString *liftNum;

@property (strong, nonatomic) NSString *mainDate;

@property (strong, nonatomic) NSString *mainType;

@property (strong, nonatomic) NSString *planMainDate;

@property (strong, nonatomic) NSString *planMainType;

@property (strong, nonatomic) NSString *address;

@end
