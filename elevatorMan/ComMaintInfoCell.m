//
// Created by changhaozhang on 2017/6/9.
//

#import "ComMaintInfoCell.h"

@implementation ComMaintInfoCell

+ (id)cellFromNib {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ComMaintInfoCell" owner:nil options:nil];

    if (0 == array.count) {
        return nil;
    }

    return array[0];
}

+ (CGFloat)cellHeight {
    return 82;
}

+ (NSString *)identifier {
    return @"com_maint_info_cell";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _lbIndex.layer.masksToBounds = YES;
    _lbIndex.layer.cornerRadius = 10;
}
@end