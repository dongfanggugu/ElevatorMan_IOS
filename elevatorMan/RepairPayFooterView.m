//
//  RepairPayFooterView.m
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/7.
//
//

#import "RepairPayFooterView.h"

@implementation RepairPayFooterView

+ (id)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RepairPayFooterView" owner:nil options:nil];
    if (0 == array.count) {
        return nil;
    }
    
    return array[0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _btnSubmit.layer.masksToBounds = YES;
    _btnSubmit.layer.cornerRadius = 5;
    
    [_btnSubmit addTarget:self action:@selector(clickSubmit) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickSubmit
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClickSubmit)]) {
        [_delegate onClickSubmit];
    }
}

@end
