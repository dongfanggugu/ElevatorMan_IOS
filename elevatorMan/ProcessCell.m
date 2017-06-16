//
// Created by changhaozhang on 2017/6/10.
// Copyright (c) 2017 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "ProcessCell.h"

@interface ProcessCell ()

@property (weak, nonatomic) IBOutlet UIView *viewIndex;

@property (weak, nonatomic) IBOutlet UIView *viewTop;

@property (weak, nonatomic) IBOutlet UIView *viewBottom;

@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation ProcessCell
+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ProcessCell" owner:nil options:nil];
    if (0 == array.count)
    {
        return nil;
    }

    return array[0];
}

+ (NSString *)identifier
{
    return @"process_cell";
}

+ (CGFloat)cellHeight
{
    return 88;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.selectionStyle = UITableViewCellSelectionStyleNone;

    _viewIndex.layer.masksToBounds = YES;

    _viewIndex.layer.cornerRadius = 10;

    _btn.hidden = YES;

    [_btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setIsHere:(BOOL)isHere
{
    if (isHere)
    {
        _viewIndex.backgroundColor = RGB(TITLE_COLOR);
    }
    else
    {
        _viewIndex.backgroundColor = RGB(FONT_GRAY);
    }

}

- (void)clickBtn
{
    if (_onClickBtn)
    {
        _onClickBtn();
    }
}
- (void)setOnClickBtn:(void (^)())onClickBtn
{
    _btn.hidden = NO;

    _onClickBtn = onClickBtn;
}

- (void)setLocation:(Process_Location)location
{

    if (Location_Middle == location)
    {
        _viewTop.hidden = NO;
        _viewBottom.hidden = NO;
        return;
    }
    if (Location_Head == location)
    {
        _viewTop.hidden = YES;
        _viewBottom.hidden = NO;
        return;
    }

    if (Location_Tail == location)
    {
        _viewTop.hidden = NO;
        _viewBottom.hidden = YES;
        return;
    }
}

@end
