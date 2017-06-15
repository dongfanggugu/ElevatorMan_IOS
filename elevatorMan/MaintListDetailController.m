//
// Created by changhaozhang on 2017/6/15.
//

#import "MaintListDetailController.h"
#import "KeyValueCell.h"


@interface MaintListDetailController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation MaintListDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"维保详情"];
    [self initView];
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];

    _tableView.delegate = self;

    _tableView.dataSource = self;

    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self.view addSubview:_tableView];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KeyValueCell *cell = [KeyValueCell cellFromNib];

    switch (indexPath.row)
    {
        case 0:
            cell.lbKey.text = @"电梯编号";
            cell.lbValue.text = _maintInfo[@"elevatorNum"];
            break;

        case 1:
            cell.lbKey.text = @"项目";
            cell.lbValue.text = _maintInfo[@"communityName"];
            break;

        case 2:
            cell.lbKey.text = @"地址";
            cell.lbValue.text = _maintInfo[@"address"];
            break;

        case 3:
            cell.lbKey.text = @"维修工";
            cell.lbValue.text = _maintInfo[@"userName"];
            break;

        case 4:
            cell.lbKey.text = @"计划时间";
            cell.lbValue.text = _maintInfo[@"planTime"];
            break;

        case 5:
            cell.lbKey.text = @"维保时间";
            cell.lbValue.text = _maintInfo[@"maintTime"];
            break;

        case 6:
            cell.lbKey.text = @"维保类型";
            cell.lbValue.text = [self getMaintDes:_maintInfo[@"maintType"]];
            break;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (2 == indexPath.row)
    {
        return [KeyValueCell cellHeightWithContent:_maintInfo[@"address"]];
    }

    return [KeyValueCell cellHeight];
}

- (NSString *)getMaintDes:(NSString *)type
{
    if ([type isEqualToString:@"hm"])
    {
        return @"半月保";
    }
    else if ([type isEqualToString:@"m"])
    {
        return @"月保";
    }
    else if ([type isEqualToString:@"s"])
    {
        return @"季度保";
    }
    else if ([type isEqualToString:@"hy"])
    {
        return @"半年保";
    }
    else
    {
        return @"年保";
    }
}

@end