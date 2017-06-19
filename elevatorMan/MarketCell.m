//
//  MarketCell.m
//  owner
//
//  Created by 长浩 张 on 2017/1/17.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MarketCell.h"

@interface MarketCell ()

@end

@implementation MarketCell

+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MarketCell" owner:nil options:nil];
    if (0 == array.count)
    {
        return nil;
    }

    return array[0];
}

+ (NSString *)identifier
{
    return @"market_cell";
}

+ (CGFloat)cellHeight
{
    return 80;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _lbTitle.layer.masksToBounds = YES;
    _lbTitle.layer.cornerRadius = 18;
}

@end
