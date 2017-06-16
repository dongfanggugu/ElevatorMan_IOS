//
//  ProPersonCenterViewController.m
//  elevatorMan
//
//  Created by 长浩 张 on 2016/11/1.
//
//

#import <Foundation/Foundation.h>
#import "ProPersonCenterViewController.h"
#import "Utils.h"


@interface ProPersonCenterViewController ()


@end


@implementation ProPersonCenterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];


    [self initNavi];
}

- (void)initNavi
{
    NSLog(@"initNavi");
    UIButton *btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    [btnLeft setTitle:@"返回" forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *barLeft = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.leftBarButtonItem = barLeft;

    self.navigationController.navigationBar.barTintColor = [Utils getColorByRGB:@"#007ec5"];
}

- (void)goBack
{
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}


- (void)dealloc
{
    NSLog(@"person dealloc");
}

@end
