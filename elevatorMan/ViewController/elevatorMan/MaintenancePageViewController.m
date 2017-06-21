//
//  MaintenancePageViewController.m
//  elevatorMan
//
//  Created by 长浩 张 on 16/6/29.
//
//

#import <Foundation/Foundation.h>
#import "MaintenancePageViewController.h"
#import "MyLiftViewController.h"
#import "RecordViewController.h"
#import "DateUtil.h"

@interface MaintenancePageViewController ()

@property (weak, nonatomic) IBOutlet UIView *viewLift;

@property (weak, nonatomic) IBOutlet UIView *viewPlan;

@property (weak, nonatomic) IBOutlet UIView *viewRecord;

@end

@implementation MaintenancePageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"电梯维保"];
    [self initView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)initView
{
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    _viewLift.layer.masksToBounds = YES;
    _viewLift.layer.cornerRadius = 5;

    _viewPlan.layer.masksToBounds = YES;
    _viewPlan.layer.cornerRadius = 5;

    _viewRecord.layer.masksToBounds = YES;
    _viewRecord.layer.cornerRadius = 5;
}

- (void)myLift
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Worker" bundle:nil];
    MyLiftViewController *controller = [board instantiateViewControllerWithIdentifier:@"my_lift"];
    controller.liftType = TYPE_ALL;

    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)mainPlan
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Worker" bundle:nil];
    MyLiftViewController *controller = [board instantiateViewControllerWithIdentifier:@"my_lift"];
    controller.liftType = TYPE_PLAN;

    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)uploadRecord
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Worker" bundle:nil];
    RecordViewController *controller = [board instantiateViewControllerWithIdentifier:@"record_controller"];

    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;

    if (0 == row)
    {
        [self myLift];
    }
    else if (1 == row)
    {
        [self mainPlan];
    }
    else if (2 == row)
    {
        [self uploadRecord];

    }
}

@end
