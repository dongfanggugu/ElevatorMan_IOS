//
//  AddDeviceMainViewController.m
//  SdkExampleDemo
//
//  Created by jasonchen on 16/4/18.
//  Copyright © 2016年 jason chen. All rights reserved.
//

#import "AddDeviceMainViewController.h"
#import "IPAddDeviceViewController.h"
#import "AddDeviceBySerialViewController.h"
@interface AddDeviceMainViewController ()

@end

@implementation AddDeviceMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createnViewController];
    [self createTabBarItems];
    // Do any additional setup after loading the view.
}
- (void)createnViewController
{
    
    AddDeviceBySerialViewController *serialVC = [[AddDeviceBySerialViewController alloc] initWithNibName:@"AddDeviceBySerialViewController" bundle:nil];
    UINavigationController *serialNav = [[UINavigationController alloc] initWithRootViewController:serialVC];
    
    IPAddDeviceViewController *ipVC = [[IPAddDeviceViewController alloc] initWithNibName:@"IPAddDeviceViewController" bundle:nil];
    UINavigationController *ipNav = [[UINavigationController alloc] initWithRootViewController:ipVC];
 
    self.viewControllers = @[serialNav,ipNav];
    
}

#pragma  mark -createTabBar -
- (void)createTabBarItems
{
    
    NSArray *titleArray = @[@"序列号添加",@"IP地址添加"];
    NSDictionary *tabBarItemArr = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial-BoldItalicMT" size:15.0],NSFontAttributeName, nil];
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
