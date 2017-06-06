//
//  RepairTaskMakeView.m
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/6.
//
//

#import "RepairTaskMakeView.h"
#import "DatePickerDialog.h"

@interface RepairTaskMakeView () <DatePickerDialogDelegate>

@end

@implementation RepairTaskMakeView

+ (id)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RepairTaskMakeView" owner:nil options:nil];
    
    if (0 == array.count) {
        return nil;
    }
    
    return array[0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _btnModify.layer.masksToBounds = YES;
    _btnModify.layer.cornerRadius = 5;
    
    _btnSubmit.layer.masksToBounds = YES;
    _btnSubmit.layer.cornerRadius = 5;
    
    [_btnModify addTarget:self action:@selector(clickModify) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnSubmit addTarget:self action:@selector(onClickSubmit) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickModify
{
    DatePickerDialog *dialog = [DatePickerDialog viewFromNib];
    
    dialog.delegate = self;
    
    [dialog show];
}

- (void)clickSubmit
{
    
}

- (void)onPickerDate:(NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateStr = [format stringFromDate:date];
    _lbPlan.text = dateStr;
}


@end
