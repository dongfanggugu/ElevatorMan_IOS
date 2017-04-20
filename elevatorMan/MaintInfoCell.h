//
//  MaintInfoCell.h
//  elevatorMan
//
//  Created by 长浩 张 on 2017/4/20.
//
//

#import <UIKit/UIKit.h>

@interface MaintInfoCell : UITableViewCell

+ (id)cellFromNib;

+ (NSString *)identifier;

+ (CGFloat)cellHeight;


@property (weak, nonatomic) IBOutlet UILabel *labelProject;

@property (weak, nonatomic) IBOutlet UILabel *labelDate;

@end
