//
//  WRepairCell.m
//  elevatorMan
//
//  Created by 长浩 张 on 2017/1/12.
//
//

#import <Foundation/Foundation.h>
#import "WRepairCell.h"

@implementation WRepairCell

+ (id)viewFromNib {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"WRepairCell" owner:nil options:nil];
    if (0 == array.count) {
        return nil;
    }

    return array[0];
}

+ (CGFloat)cellHeigh {
    return 64;
}

+ (NSString *)identifier {
    return @"w_repair_cell";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _lbIndex.layer.masksToBounds = YES;
    _lbIndex.layer.cornerRadius = 20;
}

@end
