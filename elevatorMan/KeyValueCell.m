//
//  KeyValueCell.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/12/14.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeyValueCell.h"

@implementation KeyValueCell

+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"KeyValueCell" owner:nil options:nil];

    if (0 == array)
    {
        return nil;
    }

    return array[0];
}

+ (NSString *)identifier
{
    return @"key_value_cell";
}

+ (CGFloat)cellHeight
{
    return 44;
}

+ (CGFloat)cellHeightWithContent:(NSString *)content
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;

    CGFloat lbWidth = width - 8 - 100 - 8 - 8;

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, lbWidth, 0)];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.font = [UIFont systemFontOfSize:14];

    label.text = content;
    label.numberOfLines = 0;
    [label sizeToFit];

    // NSInteger rows = label.frame.size.height / label.font.lineHeight;


    CGFloat h = label.frame.size.height + 10 + 10;

    return h;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
