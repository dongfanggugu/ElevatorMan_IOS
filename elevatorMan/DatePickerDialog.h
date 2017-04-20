//
//  DatePickerDialog.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/12/14.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef DatePickerDialog_h
#define DatePickerDialog_h

@protocol DatePickerDialogDelegate <NSObject>

- (void)onPickerDate:(NSDate *)date;

@end

@interface DatePickerDialog : UIView

+ (id)viewFromNib;

- (void)setDateMode;

- (void)show;

@property (weak, nonatomic) id<DatePickerDialogDelegate> delegate;

@end


#endif /* DatePickerDialog_h */
