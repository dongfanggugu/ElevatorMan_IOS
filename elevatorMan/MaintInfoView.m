//
//  MaintInfoView.m
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/5.
//
//

#import "MaintInfoView.h"
#import "DatePickerDialog.h"

@interface MaintInfoView () <DatePickerDialogDelegate>

@end

@implementation MaintInfoView

+ (id)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MaintInfoView" owner:nil options:nil];
    if (0 == array.count) {
        return nil;
    }
    
    return array[0];
}

+ (CGFloat)viewHeight
{
    return 450;
}

+ (CGFloat)basicInfoHeight
{
    return 235;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _btnStart.layer.masksToBounds = YES;
    
    _btnStart.layer.cornerRadius = 5;
    
    _btnException.layer.masksToBounds = YES;
    
    _btnException.layer.cornerRadius = 5;
    
    _btnMake.layer.masksToBounds = YES;
    
    _btnMake.layer.cornerRadius = 5;
    
    [_btnStretch addTarget:self action:@selector(clickStretch) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnPlan addTarget:self action:@selector(clickPlan) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnStart addTarget:self action:@selector(clickStart) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnException addTarget:self action:@selector(clickException) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnMake addTarget:self action:@selector(clickMake) forControlEvents:UIControlEventTouchUpInside];
    
}


- (void)clickMake
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClickMake)]) {
        [_delegate onClickMake];
    }
}

- (void)clickException
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClickException)]) {
        [_delegate onClickException];
    }
}


/**
 点击出发、到达
 */
- (void)clickStart
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClickStart)]) {
        [_delegate onClickStart];
    }
}


/**
 拖动界面
 */
- (void)clickStretch
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClickStretch)]) {
        [_delegate onClickStretch];
    }
}


/**
 修改维保计划时间
 */
- (void)clickPlan
{
    DatePickerDialog *dialog = [DatePickerDialog viewFromNib];
    
    dialog.delegate = self;
    
    [dialog show];
}


- (void)onPickerDate:(NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateStr = [format stringFromDate:date];
    _lbPlan.text = dateStr;

}
@end
