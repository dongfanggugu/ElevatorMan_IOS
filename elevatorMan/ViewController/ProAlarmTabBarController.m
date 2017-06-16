//
//  ProAlarmTabBarController.m
//  elevatorMan
//
//  Created by 长浩 张 on 2017/1/12.
//
//

#import <Foundation/Foundation.h>
#import "ProAlarmTabBarController.h"
#import "ProAlarmManagerController.h"
#import "ChatController.h"

@implementation ProAlarmTabBarController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initItem];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavTitle:@"应急救援"];
    [self initNavRightWithImage:[UIImage imageNamed:@"icon_bbs"]];
    [self initTabBar];
}


- (void)initItem
{
    UIStoryboard *board1 = [UIStoryboard storyboardWithName:@"MyProperty" bundle:nil];
    ProAlarmManagerController *process = [board1 instantiateViewControllerWithIdentifier:@"pro_alarm_manager"];

    UIStoryboard *board2 = [UIStoryboard storyboardWithName:@"Property" bundle:nil];
    UIViewController *history = [board2 instantiateViewControllerWithIdentifier:@"alarmList_property"];
    UIViewController *project = [board2 instantiateViewControllerWithIdentifier:@"pro_projects_alarm"];


    self.viewControllers = [NSArray arrayWithObjects:process, history, project, nil];
}

- (void)initTabBar
{
    UITabBar *tabBar = self.tabBar;
    [[tabBar.items objectAtIndex:0] setImage:[UIImage imageNamed:@"pro_alarm_process"]];
    [[tabBar.items objectAtIndex:0] setTitle:@"处理报警"];

    [[tabBar.items objectAtIndex:1] setImage:[UIImage imageNamed:@"icon_repair_history"]];
    [[tabBar.items objectAtIndex:1] setTitle:@"报警历史"];

    [[tabBar.items objectAtIndex:2] setImage:[UIImage imageNamed:@"pro_alarm_project"]];
    [[tabBar.items objectAtIndex:2] setTitle:@"项目报警"];

}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSInteger index = [tabBar.items indexOfObject:item];

    NSLog(@"index:%ld", index);

    if (0 == index)
    {
        [self initNavRightWithImage:[UIImage imageNamed:@"icon_bbs"]];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
}


/**
 使用图片初始化导航栏右侧按钮
 **/
- (void)initNavRightWithImage:(UIImage *)image
{
    if (!self.navigationController)
    {
        return;
    }

    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [btnRight setImage:image forState:UIControlStateNormal];

    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:btnRight];

    self.navigationItem.rightBarButtonItem = rightButton;

    [btnRight addTarget:self action:@selector(onClickNavRight) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onClickNavRight
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Worker" bundle:nil];
    ChatController *controller = [board instantiateViewControllerWithIdentifier:@"chat_controller"];
    controller.enterType = Enter_Property;
    [self.navigationController pushViewController:controller animated:YES];
}
@end
