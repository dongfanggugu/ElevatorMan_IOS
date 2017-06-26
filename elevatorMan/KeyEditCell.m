//
//  KeyEditCell.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/12/14.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeyEditCell.h"

@interface KeyEditCell ()

@end

@implementation KeyEditCell

+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"KeyEditCell" owner:nil options:nil];

    if (0 == array.count)
    {
        return nil;
    }

    return array[0];
}

+ (NSString *)identifier
{
    return @"key_edit_cell";
}

+ (CGFloat)cellHeight
{
    return 44;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    _lbUnit.hidden = YES;
}

@end
