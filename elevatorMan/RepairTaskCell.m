//
//  RepairTaskCell.m
//  owner
//
//  Created by 长浩 张 on 2017/3/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RepairTaskCell.h"

@implementation RepairTaskCell

+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RepairTaskCell" owner:nil options:nil];
    
    if (0 == array.count)
    {
        return nil;
    }
    
    return array[0];
}

+ (CGFloat)cellHeight
{
    return 130;
}

+(NSString *)identifier
{
    return @"repair_task_cell";
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
}

@end
