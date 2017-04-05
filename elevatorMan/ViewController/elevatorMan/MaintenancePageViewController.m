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

@interface MaintenancePageViewController()


@end

@implementation MaintenancePageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleString:@"电梯维保"];
    [self initView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self initNavi];
}

- (void)setTitleString:(NSString *)title
{
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    labelTitle.text = title;
    labelTitle.font = [UIFont fontWithName:@"System" size:17];
    labelTitle.textColor = [UIColor whiteColor];
    [self.navigationItem setTitleView:labelTitle];
}

- (void)initView
{
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.bounces = NO;
}

//- (void)initNavi
//{
//    if (!self.navigationController)
//    {
//        return;
//    }
//    
//    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
//    titleLable.text = @"维保管理";
//    titleLable.font = [UIFont systemFontOfSize:15];
//    titleLable.textAlignment = NSTextAlignmentCenter;
//    titleLable.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = titleLable;
//    
//    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
//    [backBtn setImage:[UIImage imageNamed:@"back_normal"] forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(popup) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = backItem;
//    
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
//    
//}
//
//- (void)popup
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)myLift
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Worker" bundle:nil];
    MyLiftViewController *controller = [board instantiateViewControllerWithIdentifier:@"my_lift"];
    controller.liftType = TYPE_ALL;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)mainPlan
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Worker" bundle:nil];
    MyLiftViewController *controller = [board instantiateViewControllerWithIdentifier:@"my_lift"];
    controller.liftType = TYPE_PLAN;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)uploadRecord
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Worker" bundle:nil];
    RecordViewController *controller = [board instantiateViewControllerWithIdentifier:@"record_controller"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)mainReminder
{
}

- (void)yearCheck
{
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger row = indexPath.row;
    
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    else if (3 == row)
    {
        [self mainReminder];
    }
    else if (4 == row)
    {
        [self yearCheck];
    }
    
}
@end
