//
//  ProMaintenanceDetail.h
//  elevatorMan
//
//  Created by 长浩 张 on 15/12/17.
//
//

#ifndef ProMaintenanceDetail_h
#define ProMaintenanceDetail_h

#import "ProBaseTableViewController.h"

@interface ProMaintenanceDetail : ProBaseTableViewController

@property (nonatomic, copy) NSString *worker;

@property (copy, nonatomic) NSString *workerSign;

@property (copy, nonatomic) NSString *propertySign;

@property (copy, nonatomic) NSString *enterFlag;

@end

#endif /* ProMaintenanceDetail_h */
