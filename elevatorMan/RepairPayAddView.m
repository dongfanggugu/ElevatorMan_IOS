//
//  RepairPayAddView.m
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/7.
//
//

#import "RepairPayAddView.h"


@interface RepairPayAddView ()

@property (weak, nonatomic) IBOutlet UIButton *btnConfirm;

@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

@end

@implementation RepairPayAddView

+ (id)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RepairPayAddView" owner:nil options:nil];
    if (0 == array.count) {
        return nil;
    }
    
    return array[0];
}

- (void)show
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIWindow *window = appDelegate.window;
    
    self.frame = window.bounds;
    
    [window addSubview:self];
    
    [window bringSubviewToFront:self];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.7];
    
    _tfItem.leftViewMode = UITextFieldViewModeAlways;
    
    _tfItem.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 30)];
    
    _tfMoney.leftViewMode = UITextFieldViewModeAlways;
    
    _tfMoney.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 30)];
    
    _btnConfirm.layer.masksToBounds = YES;
    
    _btnConfirm.layer.cornerRadius = 5;
    
    _btnCancel.layer.masksToBounds = YES;
    
    _btnCancel.layer.cornerRadius = 5;
    
    [_btnConfirm addTarget:self action:@selector(clickConfirm) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnCancel addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickConfirm
{
    if (0 == _tfItem.text.length) {
        [HUDClass showHUDWithLabel:@"收费项目不能为空!"];
        return;
    }
    
    if (0 == _tfMoney.text.length || 0 == _tfMoney.text.floatValue) {
        [HUDClass showHUDWithLabel:@"请正确填写项目费用!"];
        return;
    }
    
    NSString *item = _tfItem.text;
    
    CGFloat fee = _tfMoney.text.floatValue;
    
    if (_delegate && [_delegate respondsToSelector:@selector(onClickConfirm:fee:)]) {
        [_delegate onClickConfirm:item fee:fee];
    }
    
    if (self.superview) {
        [self removeFromSuperview];
    }
}

- (void)clickCancel
{
    if (self.superview) {
        [self removeFromSuperview];
    }
}

@end
