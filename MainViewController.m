//
//  MainViewController.m
//  SdkExampleDemo
//
//  Created by jasonchen on 16/4/15.
//  Copyright © 2016年 jason chen. All rights reserved.
//

#import "MainViewController.h"
#import "VideoTestViewController.h"
#import "DeviceViewController.h"
#import "AlarmInformationViewController.h"
@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViewController];
    [self createTabBarItems];
    // Do any additional setup after loading the view.
}
- (void)createViewController
{
    
    DeviceViewController *deviceVC = [[DeviceViewController alloc] initWithNibName:@"DeviceViewController" bundle:nil];
    deviceVC.title  = @"设备";
    UINavigationController *deviceNav = [[UINavigationController alloc] initWithRootViewController:deviceVC];
    
    VideoTestViewController *videoVC = [[VideoTestViewController alloc] initWithNibName:@"VideoTestViewController" bundle:nil];
    videoVC.title  = @"视频";
    UINavigationController *videoNav = [[UINavigationController alloc] initWithRootViewController:videoVC];
    
    AlarmInformationViewController *alarmVC = [[AlarmInformationViewController alloc] initWithNibName:@"AlarmInformationViewController" bundle:nil];
    alarmVC.title  = @"报警";
    UINavigationController *alarmNav = [[UINavigationController alloc] initWithRootViewController:alarmVC];
    self.viewControllers = @[deviceNav,videoNav,alarmNav];
    
    
}

#pragma  mark -createTabBar -

- (void)createTabBarItems
{
    
    NSArray *titleArray = @[@"设备",@"视频",@"报警"];
    NSDictionary *tabBarItemArr = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial-BoldItalicMT" size:20.0],NSFontAttributeName, nil];
    for (int i = 0; i< self.tabBar.items.count; i++) {
        UITabBarItem *tabBarItem = self.tabBar.items[i];
        [tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -10)];
        [tabBarItem setTitleTextAttributes:tabBarItemArr forState:UIControlStateNormal];
        tabBarItem = [tabBarItem initWithTitle:titleArray[i] image:nil selectedImage:nil];
    }
    /*
     设置tabbar背景色
     */
    self.tabBar.backgroundColor = [UIColor blackColor];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
