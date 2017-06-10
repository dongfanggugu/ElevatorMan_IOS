//
//  KnMainCell.m
//  owner
//
//  Created by 长浩 张 on 2017/5/26.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "KnMainCell.h"

@interface KnMainCell ()

@property (weak, nonatomic) IBOutlet UIView *viewQA;

@property (weak, nonatomic) IBOutlet UIView *viewFault;

@property (weak, nonatomic) IBOutlet UIView *viewOp;

@property (weak, nonatomic) IBOutlet UIView *viewLaw;

@end

@implementation KnMainCell

+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"KnMainCell" owner:nil options:nil];

    if (0 == array.count)
    {
        return nil;
    }

    return array[0];
}

+ (NSString *)identifier
{
    return @"kn_main_cell";
}

+ (CGFloat)cellHeight
{
    return 300;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code

    self.selectionStyle = UITableViewCellSelectionStyleNone;

    _viewQA.layer.masksToBounds = YES;
    _viewQA.layer.cornerRadius = 45;

    _viewQA.userInteractionEnabled = YES;
    [_viewQA addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickQA)]];


    _viewFault.layer.masksToBounds = YES;
    _viewFault.layer.cornerRadius = 45;

    _viewFault.userInteractionEnabled = YES;
    [_viewFault addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickFault)]];

    _viewOp.layer.masksToBounds = YES;
    _viewOp.layer.cornerRadius = 45;

    _viewOp.userInteractionEnabled = YES;
    [_viewOp addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOp)]];

    _viewLaw.layer.masksToBounds = YES;
    _viewLaw.layer.cornerRadius = 45;

    _viewLaw.userInteractionEnabled = YES;
    [_viewLaw addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLaw)]];
}

- (void)clickQA
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClickQA)])
    {
        [_delegate onClickQA];
    }

}

- (void)clickFault
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClickFault)])
    {
        [_delegate onClickFault];
    }

}

- (void)clickOp
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClickOperation)])
    {
        [_delegate onClickOperation];
    }

}

- (void)clickLaw
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClickLaw)])
    {
        [_delegate onClickLaw];
    }

}


@end
