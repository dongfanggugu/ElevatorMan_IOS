//
//  WRepairView.m
//  elevatorMan
//
//  Created by 长浩 张 on 2017/1/12.
//
//

#import <Foundation/Foundation.h>
#import "WRepairView.h"

@implementation WRepairView

+ (id)viewFromNib {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"WRepairView" owner:nil options:nil];
    if (0 == array.count) {
        return nil;
    }

    return array[0];
}

- (void)awakeFromNib {
    [super awakeFromNib];

    _tvContent.layer.masksToBounds = YES;
    _tvContent.layer.cornerRadius = 5;
    _tvContent.layer.borderWidth = 1;
    _tvContent.layer.borderColor = [UIColor grayColor].CGColor;
}

@end
