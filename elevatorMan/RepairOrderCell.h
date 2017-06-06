//
//  RepairOrderCell.h
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/6.
//
//

#import <UIKit/UIKit.h>

@interface RepairOrderCell : UITableViewCell

+ (id)cellFromNib;

+ (NSString *)identifier;

+ (CGFloat)cellHeight;

@property (weak, nonatomic) IBOutlet UILabel *lbIndex;

@property (weak, nonatomic) IBOutlet UILabel *lbName;

@property (weak, nonatomic) IBOutlet UILabel *lbState;

@property (weak, nonatomic) IBOutlet UILabel *lbLink;

@property (weak, nonatomic) IBOutlet UILabel *lbDate;

@end
