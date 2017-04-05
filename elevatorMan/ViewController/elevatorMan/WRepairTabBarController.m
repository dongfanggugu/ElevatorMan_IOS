//
//  WRepairTabBarController.m
//  elevatorMan
//
//  Created by 长浩 张 on 2017/1/12.
//
//

#import <Foundation/Foundation.h>
#import "WRepairTabBarController.h"

@implementation WRepairTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initItem];
    [self initTabBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavTitle:@"业主报修"];
}


- (void)initItem
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"WorkerRepair" bundle:nil];
    UIViewController *process = [board instantiateViewControllerWithIdentifier:@"w_repair_processs"];
    
    UIViewController *history = [board instantiateViewControllerWithIdentifier:@"w_repair_history"];
    
    
    self.viewControllers = [NSArray arrayWithObjects:process, history, nil];
}

- (void)initTabBar
{
    UITabBar *tabBar = self.tabBar;
    [[tabBar.items objectAtIndex:0] setImage:[UIImage imageNamed:@"icon_repair_process"]];
    [[tabBar.items objectAtIndex:0] setTitle:@"处理维修"];
    
    [[tabBar.items objectAtIndex:1] setImage:[UIImage imageNamed:@"icon_repair_history"]];
    [[tabBar.items objectAtIndex:1] setTitle:@"历史维修"];
    
}

@end
