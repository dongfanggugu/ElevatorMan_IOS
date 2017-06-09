//
//  ManagerTabBarController.m
//  elevatorMan
//
//  Created by 长浩 张 on 2016/12/26.
//
//

#import <Foundation/Foundation.h>
#import "ManagerTabBarController.h"
#import "MainBaseNavigationController.h"

@implementation ManagerTabBarController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initItem];
    [self initTabBar];
}

- (void)initItem {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MaintenanceManager" bundle:nil];
    UIViewController *today = [storyBoard instantiateViewControllerWithIdentifier:@"main_today"];

    MainBaseNavigationController *nav1 = [[MainBaseNavigationController alloc] init];

    [nav1 pushViewController:today animated:YES];

    self.viewControllers = [NSArray arrayWithObjects:nav1, nil];

}


- (void)initTabBar {
    [[self.tabBar.items objectAtIndex:0] setImage:[UIImage imageNamed:@"icon_more_normal"]];
    [[self.tabBar.items objectAtIndex:0] setTitle:@"今日维保"];
}

@end
