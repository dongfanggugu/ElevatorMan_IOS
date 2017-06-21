//
//  ContentCell.m
//  owner
//
//  Created by 长浩 张 on 2017/4/19.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "ContentCell.h"

@implementation ContentCell

+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ContentCell" owner:nil options:nil];

    if (0 == array.count)
    {
        return nil;
    }

    return array[0];
}

+ (NSString *)identifier
{
    return @"content_cell";
}

+ (CGFloat)cellHeight:(NSString *)content
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;

    CGFloat lbWidth = width - 8 - 8;

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, lbWidth, 0)];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.font = [UIFont systemFontOfSize:14];

    label.text = content;
    label.numberOfLines = 0;
    [label sizeToFit];

    CGFloat h = label.frame.size.height + 10 + 10;

    return h;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
