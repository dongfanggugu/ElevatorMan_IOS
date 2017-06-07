//
//  RepairPayHeaderView.m
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/7.
//
//

#import "RepairPayHeaderView.h"

@interface RepairPayHeaderView ()

@property (weak, nonatomic) IBOutlet UIButton *btnAdd;

@end

@implementation RepairPayHeaderView

+ (id)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RepairPayHeaderView" owner:nil options:nil];
    if (0 == array.count) {
        return nil;
    }
    
    return array[0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [_btnAdd addTarget:self action:@selector(clickAdd) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickAdd
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClickAdd)]) {
        [_delegate onClickAdd];
    }
}

@end
