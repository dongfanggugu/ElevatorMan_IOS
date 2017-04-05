//
//  ExceptionView.m
//  elevatorMan
//
//  Created by 长浩 张 on 2016/10/31.
//
//

#import <Foundation/Foundation.h>
#import "ExceptionView.h"

@interface ExceptionView()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelPlaceHolder;

@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

@property (weak, nonatomic) IBOutlet UIButton *btnConfirm;

@property (weak, nonatomic) IBOutlet UITextView *tvRemark;

@end

@implementation ExceptionView


+ (instancetype)viewFromNib
{
    NSLog(@"exception viewFromNib");
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ExceptionView" owner:nil options:nil];
    if (array.count < 1)
    {
        return nil;
    }
    
    return [[array[0] subviews] objectAtIndex:0];
}

- (void)layoutSubviews
{
    //设置边框
    [self initTextView];
    [self initConfirmBtn];
    [self initCancelBtn];
}

/**
 初始化文本输入框
 **/
- (void)initTextView
{
    _tvRemark.delegate = self;
}

/**
 初始化确认按钮
 **/
- (void)initConfirmBtn
{
    [_btnConfirm addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
}

- (void)confirm
{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(onClickConfirm:)])
    {
        NSString *remark = _tvRemark.text;
        [_delegate onClickConfirm:remark];
    }
    [self removeFromSuperview];
}

/**
 初始化取消按钮
 **/
- (void)initCancelBtn
{
    [_btnCancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
}

- (void)cancel
{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(onClickCancel)])
    {
        [_delegate onClickCancel];
    }
    
    [self removeFromSuperview];
}

#pragma mark -- UITextViewDelegate

/**
 处理UITextView的placeholder问题
 **/
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    _labelPlaceHolder.hidden = YES;
    return true;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSString *text = textView.text;
    
    if (0 == text)
    {
        _labelPlaceHolder.hidden = NO;
    }
    else
    {
        _labelPlaceHolder.hidden = YES;
    }
}

- (void)dealloc
{
    NSLog(@"exception dealloc");
}

@end
