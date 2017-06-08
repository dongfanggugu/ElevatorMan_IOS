//
//  ComAlarmCell.h
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/8.
//
//

#import <UIKit/UIKit.h>

@interface ComAlarmCell : UITableViewCell

+ (id)cellFromNib;

@property (weak, nonatomic) IBOutlet UILabel *lbIndex;

@end
