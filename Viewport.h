//
//  Viewport.h
//  HBPlaySDK
//
//  Created by wangzhen on 15-1-13.
//  Copyright (c) 2015年 wangzhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Viewport : UIView

@property bool bFastRender;

- (void)render: (void *)frame;
- (void)clearFrame;

@end
