//
// Created by changhaozhang on 2017/6/10.
// Copyright (c) 2017 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "OrderMaintDetailController.h"
#import "MaintProcessController.h"
#import "MaintDetailController.h"


@interface OrderMaintDetailController ()



@end

@implementation OrderMaintDetailController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"维保订单"];
    [self initView];
    [self loadProcessAndDetail];
}

- (void)initView
{
    NSArray *array = [NSArray arrayWithObjects:@"订单进度", @"订单详情",nil];
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:array];
    CGRect frame = CGRectMake(0, 70, 200, 30);
    segment.frame = frame;

    segment.center = CGPointMake(self.screenWidth / 2, 90);

    segment.tintColor = RGB(TITLE_COLOR);

    [self.view addSubview:segment];

    [segment setSelectedSegmentIndex:0];
    [segment addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)segmentChanged:(UISegmentedControl *)segment
{
    NSInteger index = segment.selectedSegmentIndex;

    if (0 == index)
    {
        [self loadProcess];

    }
    else
    {
        [self loadDetail];
    }
}

- (void)loadProcessAndDetail
{
    MaintProcessController *controller = [[MaintProcessController alloc] init];

    controller.orderInfo = _orderInfo;
    [self addChildViewController:controller];

    CGRect frame = CGRectMake(0, 118, self.screenWidth, self.screenHeight - 118);
    controller.view.frame = frame;

    [self.view addSubview:controller.view];

    MaintDetailController *detail = [[MaintDetailController alloc] init];

    detail.orderInfo = _orderInfo;
    [self addChildViewController:detail];

    detail.view.frame = frame;
}

- (void)loadProcess
{
    if (self.childViewControllers.count < 2) {
        return;
    }

    [self transitionFromViewController:self.childViewControllers[1] toViewController:self.childViewControllers[0]
                              duration:0 options:UIViewAnimationOptionTransitionNone animations:^{

            } completion:^(BOOL finished) {

            }];
}

- (void)loadDetail
{
    if (self.childViewControllers.count < 2) {
        return;
    }
     [self transitionFromViewController:self.childViewControllers[0] toViewController:self.childViewControllers[1]
                              duration:0 options:UIViewAnimationOptionTransitionNone animations:^{

            } completion:^(BOOL finished) {

            }];
}

@end