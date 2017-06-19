//
//  UITableView+CoverView.m
//  owner
//
//  Created by 长浩 张 on 2017/5/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "UITableView+CoverView.h"

@implementation UITableView (CoverView)


- (void)showCopyWrite
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, -50, self.frame.size.width, 30)];
    label.text = @"怡墅（中融智达提供）";
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [Utils getColorByRGB:@"#AAAAAA"];
    label.textAlignment = NSTextAlignmentCenter;

    [self addSubview:label];
}

@end
