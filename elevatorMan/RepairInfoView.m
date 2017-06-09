//
//  RepairInfoView.m
//  owner
//
//  Created by 长浩 张 on 2017/4/26.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "RepairInfoView.h"

@interface RepairInfoView ()

@property (weak, nonatomic) IBOutlet UILabel *lbTitleOrder;

@property (weak, nonatomic) IBOutlet UILabel *lbTitleTask;


@end

@implementation RepairInfoView

+ (id)viewFromNib {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RepairInfoView" owner:nil options:nil];

    if (0 == array) {
        return nil;
    }

    return array[0];
}

- (void)awakeFromNib {
    [super awakeFromNib];

    _lbFaultDes.userInteractionEnabled = NO;

    _lbFaultDes.layer.masksToBounds = YES;
    _lbFaultDes.layer.cornerRadius = 5;

    _lbFaultDes.layer.borderColor = RGB(BG_GRAY).CGColor;

    _lbFaultDes.layer.borderWidth = 1;

    _btnTask.layer.masksToBounds = YES;
    _btnTask.layer.cornerRadius = 5;

    _btnPay.layer.masksToBounds = YES;
    _btnPay.layer.cornerRadius = 5;


    _lbTitleOrder.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_blue"]];
    _lbTitleTask.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon_red"]];

    [_btnTask addTarget:self action:@selector(clickTask) forControlEvents:UIControlEventTouchUpInside];

    [_btnPay addTarget:self action:@selector(clickPay) forControlEvents:UIControlEventTouchUpInside];

    [_btnEvaluate addTarget:self action:@selector(clickEvaluate) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickTask {
    if (_delegate && [_delegate respondsToSelector:@selector(onClickTask)]) {
        [_delegate onClickTask];
    }
}

- (void)clickPay {
    if (_delegate && [_delegate respondsToSelector:@selector(onClickPay)]) {
        [_delegate onClickPay];
    }
}

- (void)clickEvaluate {
    if (_delegate && [_delegate respondsToSelector:@selector(onClickEvaluate)]) {
        [_delegate onClickEvaluate];
    }
}

@end
