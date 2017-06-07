//
//  RepairPayCell.h
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/7.
//
//

#import <UIKit/UIKit.h>

@interface RepairPayCell : UITableViewCell

+ (id)cellFromNib;

+ (NSString *)identifier;

+ (CGFloat)cellHeight;

@property (weak, nonatomic) IBOutlet UILabel *lbItem;

@property (weak, nonatomic) IBOutlet UILabel *lbMoney;

@property (strong, nonatomic) void(^onClickDel)();


@end
