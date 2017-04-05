//
//  AlarmTabBarController.m
//  elevatorMan
//
//  Created by 长浩 张 on 16/6/27.
//
//

#import <Foundation/Foundation.h>
#import "AlarmTabBarController.h"

@interface AlarmTabBarController()

@end

@implementation AlarmTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initTabBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initNavi];
}

- (void)initNavi
{
    if (!self.navigationController)
    {
        return;
    }
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    titleLable.text = @"应急救援";
    titleLable.font = [UIFont systemFontOfSize:15];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLable;
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [backBtn setImage:[UIImage imageNamed:@"back_normal"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popup) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
}

- (void)initTabBar
{
//    [[self.tabBar.items objectAtIndex:0] setSelectedImage:[UIImage imageNamed:@"alarm_received_pressed"]];
//    [[self.tabBar.items objectAtIndex:1] setSelectedImage:[UIImage imageNamed:@"alarm_assigned_pressed"]];
//    [[self.tabBar.items objectAtIndex:2] setSelectedImage:[UIImage imageNamed:@"alarm_history_pressed"]];
}

- (void)popup
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
