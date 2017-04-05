//
//  AlarmResultViewController.h
//  elevatorMan
//
//  Created by 长浩 张 on 16/3/30.
//
//

#ifndef AlarmResultViewController_h
#define AlarmResultViewController_h

#import "BaseTableViewController.h"

@interface AlarmResultViewController : BaseTableViewController

@property (strong, nonatomic) NSString *project;

@property (strong, nonatomic) NSString *address;

@property (strong, nonatomic) NSString *liftCode;

@property (strong, nonatomic) NSString *alarmTime;

@property (strong, nonatomic) NSString *savedCount;

@property (strong, nonatomic) NSString *injuredCount;

@property (strong, nonatomic) NSString *picUrl;

@end


#endif /* AlarmResultViewController_h */
