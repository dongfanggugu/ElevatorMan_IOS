//
//  AlarmTabBarController.m
//  elevatorMan
//
//  Created by 长浩 张 on 16/6/27.
//
//

#import <Foundation/Foundation.h>
#import "AlarmTabBarController.h"
#import "BaseNavigationController.h"

@interface AlarmTabBarController ()

@end

@implementation AlarmTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initItem];
    [self initTabBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavTitle:@"应急救援"];
}

- (void)initItem
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Worker" bundle:nil];

    UIViewController *received = [board instantiateViewControllerWithIdentifier:@"alarm_received"];

    UIViewController *process = [board instantiateViewControllerWithIdentifier:@"alarm_assigned_controller"];

    UIViewController *history = [board instantiateViewControllerWithIdentifier:@"alarm_history_controller"];

    self.viewControllers = [NSArray arrayWithObjects:received, process, history, nil];
}

- (void)initTabBar
{
    self.tabBar.tintColor = RGB(TITLE_COLOR);

    [[self.tabBar.items objectAtIndex:0] setImage:[UIImage imageNamed:@"alarm_received_normal.png"]];
    [[self.tabBar.items objectAtIndex:1] setImage:[UIImage imageNamed:@"alarm_assigned_normal.png"]];
    [[self.tabBar.items objectAtIndex:2] setImage:[UIImage imageNamed:@"alarm_history_normal.png"]];
}


@end
