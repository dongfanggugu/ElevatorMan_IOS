//
//  AlarmBottomView.m
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/8.
//
//

#import "AlarmBottomView.h"

@implementation AlarmBottomView

+ (id)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"AlarmBottomView" owner:nil options:nil];

    if (0 == array.count)
    {
        return nil;
    }

    return array[0];
}

@end
