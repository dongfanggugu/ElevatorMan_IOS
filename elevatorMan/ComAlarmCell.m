//
//  ComAlarmCell.m
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/8.
//
//

#import "ComAlarmCell.h"

@implementation ComAlarmCell

+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ComAlarmCell" owner:nil options:nil];
    
    if (0 == array.count) {
        return nil;
    }
    
    return array[0];
}

+ (CGFloat)cellHeight
{
    return 66;
}

+ (NSString *)identifier
{
    return @"com_alarm_cell";
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _lbIndex.layer.masksToBounds = YES;
    
    _lbIndex.layer.cornerRadius = 15;
}

@end
