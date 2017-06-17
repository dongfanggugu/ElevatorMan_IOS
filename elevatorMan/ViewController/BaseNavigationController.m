//
//  BaseNavigationController.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/11/22.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationBar.barTintColor = [Utils getColorByRGB:TITLE_COLOR];
    self.navigationBar.tintColor = [UIColor whiteColor];

}


@end
