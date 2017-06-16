//
//  MainOrderDetailCell.m
//  owner
//
//  Created by 长浩 张 on 2017/5/25.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "MainOrderDetailCell.h"

@interface MainOrderDetailCell ()


@end

@implementation MainOrderDetailCell


+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MainOrderDetailCell" owner:nil options:nil];

    if (0 == array.count)
    {
        return nil;
    }

    return array[0];
}

+ (CGFloat)cellHeight
{
    return 800;
}

+ (NSString *)identifier
{
    return @"main_order_detail_cell";
}


- (void)awakeFromNib
{
    [super awakeFromNib];

    self.selectionStyle = UITableViewCellSelectionStyleNone;

    _lbContent.userInteractionEnabled = NO;

    _lbContent.layer.masksToBounds = YES;

    _lbContent.layer.cornerRadius = 5;

    _lbContent.layer.borderWidth = 1;

    _lbContent.layer.borderColor = [Utils getColorByRGB:@"#f1f1f1"].CGColor;

    _btn.layer.masksToBounds = YES;

    _btn.layer.cornerRadius = 5;
}


@end
