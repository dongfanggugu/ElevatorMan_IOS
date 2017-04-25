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

+ (CGFloat)cellHeightWithText:(NSString *)text
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat width = (screenWidth - 8 - 8 - 8) / 2;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    
    label.font = [UIFont systemFontOfSize:14];
    
    label.numberOfLines = 0;
    
    label.text = text;
    
    [label sizeToFit];
    
    CGFloat originHeight = [self cellHeight] - 8 - 8 - 8 - 21;
    
    CGFloat diff = label.frame.size.height - originHeight;
    
    return [self cellHeight] + diff + 2 + 2;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
