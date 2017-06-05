//
//  MaintExceptionView.m
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/5.
//
//

#import "MaintExceptionView.h"
#import "DatePickerDialog.h"

@interface MaintExceptionView () <DatePickerDialogDelegate>

@end

@implementation MaintExceptionView

+ (id)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MaintExceptionView" owner:nil options:nil];
    
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
    
    _btnSubmit.layer.masksToBounds = YES;
    
    _btnSubmit.layer.cornerRadius = 5;
    
    [_btnPlan addTarget:self action:@selector(clickModify) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnSubmit addTarget:self action:@selector(clickSubmit) forControlEvents:UIControlEventTouchUpInside];
    
    _tvException.layer.masksToBounds = YES;
    
    _tvException.layer.cornerRadius = 5;
    
    _tvException.layer.borderColor = [Utils getColorByRGB:@"#f1f1f1"].CGColor;
    
    _tvException.layer.borderWidth = 1;
}

- (void)clickModify
{
    DatePickerDialog *dialog = [DatePickerDialog viewFromNib];
    
    dialog.delegate = self;
    
    [dialog show];
}

- (void)clickSubmit
{
    if (_delegate && [_delegate respondsToSelector:@selector(onClickSubmit)]) {
        [_delegate onClickSubmit];
    }
}

- (void)onPickerDate:(NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateStr = [format stringFromDate:date];
    _lbPlan.text = dateStr;
    
}

@end
