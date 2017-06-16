//
//  AlarmInfoView.m
//  elevatorMan
//
//  Created by 长浩 张 on 16/6/28.
//
//

#import <Foundation/Foundation.h>
#import "AlarmInfoView.h"

@interface AlarmInfoView ()

@property (weak, nonatomic) IBOutlet UIButton *telBtn;

@property (strong, nonatomic) void (^onClickTel)(NSString *tel);

@end

@implementation AlarmInfoView


+ (id)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"AlarmInfoView" owner:nil options:nil];
    if (0 == array.count)
    {
        return nil;
    }

    return [[array[0] subviews] objectAtIndex:0];

}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)onClickTel:(void (^)(NSString *tel))clickTel
{
    _onClickTel = clickTel;
    _propertyTel.userInteractionEnabled = YES;
    [_propertyTel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(clickTel)]];
}


- (void)clickTel
{
    NSString *tel = _propertyTel.text;
    _onClickTel(tel);
}


@end
