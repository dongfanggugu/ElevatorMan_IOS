//
//  PersonHeaderView.m
//  elevatorMan
//
//  Created by 长浩 张 on 2016/11/1.
//
//

#import <Foundation/Foundation.h>
#import "PersonHeaderView.h"

@interface PersonHeaderView()

@end

@implementation PersonHeaderView

+ (instancetype)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PersonHeaderView" owner:nil options:nil];
    
    if (0 == array.count)
    {
        return nil;
    }
    
    return [[array[0] subviews] objectAtIndex:0];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self initImageView];
}

- (void)initImageView
{
    _image.layer.masksToBounds = YES;
    _image.layer.cornerRadius = 40;
    
    _image.userInteractionEnabled = YES;
    [_image addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickImage)]];
}

- (void)onClickImage
{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(onClickIcon)])
    {
        [_delegate onClickIcon];
    }
}


@end
