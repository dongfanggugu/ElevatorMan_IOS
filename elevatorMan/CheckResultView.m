//
//  CheckResultView.m
//  owner
//
//  Created by changhaozhang on 2017/6/5.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "CheckResultView.h"

@implementation CheckResultView

+ (id)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CheckResultView" owner:nil options:nil];

    if (0 == array.count)
    {
        return nil;
    }

    return array[0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    _tvContent.userInteractionEnabled = NO;
    _tvContent.layer.masksToBounds = YES;
    _tvContent.layer.cornerRadius = 5;
    _tvContent.layer.borderWidth = 1;
    _tvContent.layer.borderColor = [UIColor grayColor].CGColor;

}

@end
