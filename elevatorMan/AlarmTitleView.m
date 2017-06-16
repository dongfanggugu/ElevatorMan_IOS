//
//  AlarmTitleView.m
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/8.
//
//

#import "AlarmTitleView.h"

@interface AlarmTitleView ()


@end

@implementation AlarmTitleView

+ (id)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"AlarmTitleView" owner:nil options:nil];
    if (0 == array.count)
    {
        return nil;
    }

    return array[0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    [_btnNeed addTarget:self action:@selector(clickNeed) forControlEvents:UIControlEventTouchUpInside];

    [_btnSave addTarget:self action:@selector(clickSave) forControlEvents:UIControlEventTouchUpInside];

    [_btnFinish addTarget:self action:@selector(clickFinish) forControlEvents:UIControlEventTouchUpInside];

    [_btnRevoke addTarget:self action:@selector(clickRevoke) forControlEvents:UIControlEventTouchUpInside];
}

- (void)resetBtn
{
    [_btnNeed setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [_btnSave setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [_btnFinish setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [_btnRevoke setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void)clickNeed
{
    [self resetBtn];
    [_btnNeed setTitleColor:RGB(TITLE_COLOR) forState:UIControlStateNormal];

    if (_delegate && [_delegate respondsToSelector:@selector(onClickNeed)])
    {
        [_delegate onClickNeed];
    }
}

- (void)clickSave
{
    [self resetBtn];
    [_btnSave setTitleColor:RGB(TITLE_COLOR) forState:UIControlStateNormal];

    if (_delegate && [_delegate respondsToSelector:@selector(onClickSave)])
    {
        [_delegate onClickSave];
    }
}

- (void)clickFinish
{
    [self resetBtn];
    [_btnFinish setTitleColor:RGB(TITLE_COLOR) forState:UIControlStateNormal];

    if (_delegate && [_delegate respondsToSelector:@selector(onClickFinish)])
    {
        [_delegate onClickFinish];
    }
}

- (void)clickRevoke
{
    [self resetBtn];
    [_btnRevoke setTitleColor:RGB(TITLE_COLOR) forState:UIControlStateNormal];

    if (_delegate && [_delegate respondsToSelector:@selector(onClickRevoke)])
    {
        [_delegate onClickRevoke];
    }
}

@end
