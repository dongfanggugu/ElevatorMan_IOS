//
//  DatePickerDialog.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/12/14.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DatePickerDialog.h"

@interface DatePickerDialog()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) IBOutlet UIButton *btnOK;

@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

@end

@implementation DatePickerDialog

+ (id)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"DatePickerDialog" owner:nil options:nil];
    if (0 == array.count)
    {
        return nil;
    }
    
    return array[0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.7];
    
    [_btnOK addTarget:self action:@selector(onClickOk) forControlEvents:UIControlEventTouchUpInside];
    [_btnCancel addTarget:self action:@selector(onClickCancel) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setDateMode
{
    _datePicker.datePickerMode = UIDatePickerModeDate;
}

- (void)onClickOk
{
    if (_delegate)
    {
        [_delegate onPickerDate:[_datePicker date]];
    }
    if (self.superview)
    {
        [self removeFromSuperview];
    }
}

- (void)onClickCancel
{
    if (self.superview)
    {
        [self removeFromSuperview];
    }
}

- (void)show
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.frame = appDelegate.window.bounds;
        
    [appDelegate.window addSubview:self];
    
    [appDelegate.window bringSubviewToFront:self];
}

@end
