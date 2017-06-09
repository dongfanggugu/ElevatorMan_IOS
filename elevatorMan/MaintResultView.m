//
//  MaintResultView.m
//  owner
//
//  Created by changhaozhang on 2017/6/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "MaintResultView.h"

@interface MaintResultView ()

@property (weak, nonatomic) IBOutlet UIButton *btnBefore;

@property (weak, nonatomic) IBOutlet UIButton *btnAfter;

@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@end

@implementation MaintResultView

+ (id)viewFromNib {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MaintResultView" owner:nil options:nil];

    if (0 == array.count) {
        return nil;
    }

    return array[0];
}


- (void)awakeFromNib {
    [super awakeFromNib];

    _tvContent.layer.cornerRadius = 5;

    _tvContent.layer.masksToBounds = YES;

    _tvContent.layer.borderColor = RGB(FONT_GRAY).CGColor;

    _tvContent.layer.borderWidth = 1;

    _btnSubmit.layer.masksToBounds = YES;
    _btnSubmit.layer.cornerRadius = 5;

    _btnBefore.hidden = YES;

    _btnAfter.hidden = YES;

    _ivBefore.userInteractionEnabled = YES;

    [_ivBefore addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBefore)]];

    _ivAfter.userInteractionEnabled = YES;

    [_ivAfter addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAfter)]];

    [_btnBefore addTarget:self action:@selector(clickDelBefore) forControlEvents:UIControlEventTouchUpInside];

    [_btnAfter addTarget:self action:@selector(clickDelAfter) forControlEvents:UIControlEventTouchUpInside];

    [_btnSubmit addTarget:self action:@selector(clickSubmit) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickSubmit {
    if (_delegate && [_delegate respondsToSelector:@selector(onClickSubmit)]) {
        [_delegate onClickDelBefore];
    }
}

- (void)clickDelBefore {
    [self resetBefore];

    if (_delegate && [_delegate respondsToSelector:@selector(onClickDelBefore)]) {
        [_delegate onClickDelBefore];
    }
}

- (void)clickDelAfter {
    [self resetAfter];

    if (_delegate && [_delegate respondsToSelector:@selector(onClickDelAfter)]) {
        [_delegate onClickDelAfter];
    }

}

- (void)delAfter {
    [self resetAfter];
}

- (void)clickBefore {
    if (_delegate && [_delegate respondsToSelector:@selector(onClickBeforeImage)]) {
        [_delegate onClickBeforeImage];
    }
}

- (void)clickAfter {
    if (_delegate && [_delegate respondsToSelector:@selector(onClickAfterImage)]) {
        [_delegate onClickAfterImage];
    }
}

- (void)setImageBefore:(UIImage *)imageBefore {
    _ivBefore.image = imageBefore;

    _hasBefore = YES;

    if (!_showMode) {
        _btnBefore.hidden = NO;
    }
}

- (void)setImageAfter:(UIImage *)imageAfter {
    _ivAfter.image = imageAfter;

    _hasAfter = YES;

    if (!_showMode) {
        _btnAfter.hidden = NO;
    }
}


- (void)resetBefore {
    _ivBefore.image = [UIImage imageNamed:@"icon_photo"];;

    _hasBefore = NO;

    _btnBefore.hidden = YES;
}

- (void)resetAfter {
    _ivAfter.image = [UIImage imageNamed:@"icon_photo"];

    _hasAfter = NO;

    _btnAfter.hidden = YES;
}

- (void)setShowMode:(BOOL)showMode {
    _showMode = showMode;

    if (showMode) {
        _btnAfter.hidden = YES;

        _btnBefore.hidden = YES;

        _btnSubmit.hidden = YES;

        _tvContent.userInteractionEnabled = NO;

        _tvContent.scrollEnabled = NO;
    }
}

@end
