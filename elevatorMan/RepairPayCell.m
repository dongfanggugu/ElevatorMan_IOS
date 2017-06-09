//
//  RepairPayCell.m
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/7.
//
//

#import "RepairPayCell.h"

@interface RepairPayCell ()

@property(weak, nonatomic) IBOutlet UIButton *btnDel;

@end

@implementation RepairPayCell

+ (id)cellFromNib {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RepairPayCell" owner:nil options:nil];

    if (0 == array.count) {
        return nil;
    }

    return array[0];
}

+ (NSString *)identifier {
    return @"repair_pay_cell";
}

+ (CGFloat)cellHeight {
    return 66;
}


- (void)awakeFromNib {
    [super awakeFromNib];

    self.selectionStyle = UITableViewCellSelectionStyleNone;

    [_btnDel addTarget:self action:@selector(clickDel) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickDel {
    if (_onClickDel) {
        _onClickDel();
    }
}


@end
