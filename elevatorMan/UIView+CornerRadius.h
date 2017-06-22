//
//  UIView+CornerRadius.h
//  owner
//
//  Created by 长浩 张 on 2017/4/27.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CornerRadius)

- (void)clipCornerWithTopLeft:(BOOL)topLeft
               andTopRight:(BOOL)topRight
             andBottomLeft:(BOOL)bottomLeft
            andBottomRight:(BOOL)bottomRight;

@end
