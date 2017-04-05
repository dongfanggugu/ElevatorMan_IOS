//
//  AlarmReceivedViewController.h
//  elevatorMan
//
//  Created by 长浩 张 on 16/3/24.
//
//

#ifndef AlarmReceivedViewController_h
#define AlarmReceivedViewController_h

#import "BaseViewController.h"

#pragma mark -- AlarmInfo

@interface AlarmInfo : NSObject

@property (strong, nonatomic) NSString *alarmId;

@property (strong, nonatomic) NSString *project;

@property (strong, nonatomic) NSString *date;

@property NSInteger userState;


@end



#pragma mark -- AlarmCell

@interface AlarmCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelProject;

@property (weak, nonatomic) IBOutlet UILabel *labelDate;

@property (weak, nonatomic) IBOutlet UILabel *labelState;

@property (weak, nonatomic) IBOutlet UILabel *labelIndex;

- (void)setColorWithIndex:(NSInteger)index;

@end


@interface AlarmReceivedViewController : BaseViewController

@end

#endif /* AlarmReceivedViewController_h */
