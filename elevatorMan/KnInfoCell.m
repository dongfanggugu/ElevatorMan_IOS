//
//  KnInfoCell.m
//  owner
//
//  Created by 长浩 张 on 2017/5/26.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "KnInfoCell.h"

@implementation KnInfoCell

+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"KnInfoCell" owner:nil options:nil];

    if (0 == array.count)
    {
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
    return @"kn_info_cell";
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    _lbIndex.layer.masksToBounds = YES;

    _lbIndex.layer.cornerRadius = 15;
}


@end
