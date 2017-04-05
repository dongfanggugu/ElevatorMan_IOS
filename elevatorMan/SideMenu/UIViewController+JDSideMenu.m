//
//  UIViewController+JDSideMenu.m
//  JDSideMenu
//
//  Created by Markus Emrich on 11.11.13.
//  Copyright (c) 2013 Markus Emrich. All rights reserved.
//

#import "UIViewController+JDSideMenu.h"

@implementation UIViewController (SideMenu)

- (SideMenu*)sideMenuController;
{
    UIViewController *controller = self.parentViewController;
    while (controller) {
        if ([controller isKindOfClass:[SideMenu class]]) {
            return (SideMenu*)controller;
        }
        controller = controller.parentViewController;
    }
    return nil;
}

@end
