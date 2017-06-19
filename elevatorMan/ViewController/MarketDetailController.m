//
//  MarketDetailController.m
//  owner
//
//  Created by 长浩 张 on 2017/1/17.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MarketDetailController.h"
#import "MarketCell.h"
#import "ElevatorSellController.h"
#import "ElevatorPartsController.h"
#import "ElevatorDecorateController.h"
#import "WebViewController.h"

@interface MarketDetailContrller () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation MarketDetailContrller

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"电梯商城"];
    [self initView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];

    [self.view addSubview:_tableView];

    _tableView.delegate = self;

    _tableView.dataSource = self;

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenWidth / 2)];

    imageView.image = [UIImage imageNamed:@"icon_market_top"];

    _tableView.tableHeaderView = imageView;

    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [_tableView showCopyWrite];

}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MarketCell *cell = [tableView dequeueReusableCellWithIdentifier:[MarketCell identifier]];


    if (!cell)
    {
        cell = [MarketCell cellFromNib];
    }


    if (0 == indexPath.row)
    {
        cell.lbTitle.text = @"售";
        cell.lbTitle.backgroundColor = [Utils getColorByRGB:@"#36b0f3"];

        cell.lbContent.text = @"我要买电梯";
        cell.lbContent.textColor = [Utils getColorByRGB:@"#36b0f3"];

    }
    else if (1 == indexPath.row)
    {
        cell.lbTitle.text = @"饰";
        cell.lbTitle.backgroundColor = [Utils getColorByRGB:@"#f79e6e"];

        cell.lbContent.text = @"我要选装潢";
        cell.lbContent.textColor = [Utils getColorByRGB:@"#f79e6e"];

    }
    else if (2 == indexPath.row)
    {
        cell.lbTitle.text = @"配";
        cell.lbTitle.backgroundColor = [Utils getColorByRGB:@"#00d68f"];

        cell.lbContent.text = @"我要换配件";
        cell.lbContent.textColor = [Utils getColorByRGB:@"#00d68f"];
    }


    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MarketCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (0 == indexPath.row)
    {

        WebViewController *controller = [[WebViewController alloc] init];
        controller.marketType = Market_Lift;

        NSString *url = [NSString stringWithFormat:@"%@h5/indexPage", [Utils getIp]];

        controller.urlStr = url;

        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];

    }
    else if (1 == indexPath.row)
    {

        WebViewController *controller = [[WebViewController alloc] init];
        controller.marketType = Market_Decorate;

        NSString *url = [NSString stringWithFormat:@"%@h5/indexelevatorDecorationPage", [Utils getIp]];

        controller.urlStr = url;
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];

    }
    else if (2 == indexPath.row)
    {
        UIViewController *controller = [[ElevatorPartsController alloc] init];

        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }

}
@end
