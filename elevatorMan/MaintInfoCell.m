//
//  MaintInfoCell.m
//  elevatorMan
//
//  Created by 长浩 张 on 2017/4/20.
//
//

#import "MaintInfoCell.h"

@implementation MaintInfoCell


+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MaintInfoCell" owner:nil options:nil];
    
    if (0 == array.count) {
        return nil;
    }
    
    return array[0];
}

+ (NSString *)identifier
{
    return @"maint_info_cell";
}

+ (CGFloat)cellHeight
{
    return 66;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
