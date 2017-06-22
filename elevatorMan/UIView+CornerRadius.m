//
//  UIView+CornerRadius.m
//  owner
//
//  Created by 长浩 张 on 2017/4/27.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "UIView+CornerRadius.h"

@implementation UIView (CornerRadius)

- (void)clipCornerWithTopLeft:(BOOL)topLeft
                  andTopRight:(BOOL)topRight
                andBottomLeft:(BOOL)bottomLeft
               andBottomRight:(BOOL)bottomRight
{
    CGRect frame = self.bounds;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:(topLeft == YES ? UIRectCornerTopLeft : 0) |
                                                           (topRight == YES ? UIRectCornerTopRight : 0) |
                                                           (bottomLeft == YES ? UIRectCornerBottomLeft : 0) |
                                                           (bottomRight == YES ? UIRectCornerBottomRight : 0)
                                                         cornerRadii:CGSizeMake(5, 5)];
    // 创建遮罩层
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;   // 轨迹
    self.layer.mask = maskLayer;

}

@end
