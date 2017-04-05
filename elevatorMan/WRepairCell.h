//
//  WRepairCell.h
//  elevatorMan
//
//  Created by 长浩 张 on 2017/1/12.
//
//

#ifndef WRepairCell_h
#define WRepairCell_h

@interface WRepairCell : UITableViewCell

+ (id)viewFromNib;

+ (CGFloat)cellHeigh;

+ (NSString *)identifier;

@property (weak, nonatomic) IBOutlet UILabel *lbIndex;

@property (weak, nonatomic) IBOutlet UILabel *lbTel;

@property (weak, nonatomic) IBOutlet UILabel *lbCreateTime;

@property (weak, nonatomic) IBOutlet UILabel *lbDescription;

@end

#endif /* WRepairCell_h */
