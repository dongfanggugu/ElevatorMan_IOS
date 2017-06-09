//
//  MainBaseViewController.m
//  elevatorMan
//
//  Created by 长浩 张 on 2016/12/26.
//
//

#import <Foundation/Foundation.h>
#import "MainBaseViewController.h"

@implementation MainBaseViewController


- (void)setNavTitle:(NSString *)title {
    if (!self.navigationController) {
        return;
    }

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    label.text = title;
    label.font = [UIFont fontWithName:@"System" size:17];
    label.textColor = [UIColor whiteColor];
    [label setTextAlignment:NSTextAlignmentCenter];
    [self.navigationItem setTitleView:label];
}


@end
