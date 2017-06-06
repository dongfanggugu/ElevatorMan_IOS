//
//  MainOrderInfoView.m
//  owner
//
//  Created by 长浩 张 on 2017/3/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainOrderInfoView.h"

@interface MainOrderInfoView ()

@property (weak, nonatomic) IBOutlet UIButton *btnDetail;

@property (weak, nonatomic) IBOutlet UIButton *btnLink;

@property (weak, nonatomic) IBOutlet UIButton *btnPlan;


@end

@implementation MainOrderInfoView

+ (id)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MainOrderInfoView" owner:nil options:nil];
    
    if (0 == array.count) {
        return nil;
    }
    
    return array[0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _btnPlan.layer.masksToBounds = YES;
    _btnPlan.layer.cornerRadius = 5;
    
    
    [_btnPlan addTarget:self action:@selector(clickPlan) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnDetail addTarget:self action:@selector(clickDetail) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnChange addTarget:self action:@selector(clickChange) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnLink addTarget:self action:@selector(clickLink) forControlEvents:UIControlEventTouchUpInside];
}


- (void)clickDetail
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClickDetailButton:)]) {
        [_delegate onClickDetailButton:self];
    }
}

- (void)clickPlan
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClickPlanButton:)]) {
        [_delegate onClickPlanButton:self];
    }
}

- (void)clickLink
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClickLinkButton:)]) {
        [_delegate onClickLinkButton:self];
    }
}

- (void)clickChange
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClickChangeButton:)]) {
        [_delegate onClickChangeButton:self];
    }
}

@end
