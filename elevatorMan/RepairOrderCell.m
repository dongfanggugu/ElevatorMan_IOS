//
//  RepairOrderCell.m
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/6.
//
//

#import "RepairOrderCell.h"

@implementation RepairOrderCell


+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RepairOrderCell" owner:nil options:nil];
    
    if (0 == array.count) {
        return nil;
    }
    
    return array[0];
}

+ (NSString *)identifier
{
    return @"repair_order_cell";
}

+ (CGFloat)cellHeight
{
    return 74;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _lbIndex.layer.masksToBounds = YES;
    
    _lbIndex.layer.cornerRadius = 8;
}



@end
