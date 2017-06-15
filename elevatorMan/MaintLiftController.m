//
// Created by changhaozhang on 2017/6/9.
//

#import "MaintLiftController.h"
#import "ComMaintInfoCell.h"
#import "MaintLiftHistoryController.h"

@interface MaintLiftController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@end


@implementation MaintLiftController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"电梯维保"];
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

//- (NSMutableArray *)arrayLift
//{
//    if (!_arrayLift)
//    {
//        _arrayLift = [NSMutableArray array];
//    }
//    return _arrayLift;
//}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayMaint.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ComMaintInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[ComMaintInfoCell identifier]];

    if (!cell)
    {
        cell = [ComMaintInfoCell cellFromNib];
    }

    cell.lbIndex.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];

    NSDictionary *info = self.arrayMaint[indexPath.row];

    cell.lbAddress.text = info[@"address"];

    cell.lbWorker.text = info[@"userName"];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ComMaintInfoCell cellHeight];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    MaintLiftHistoryController *controller = [[MaintLiftHistoryController alloc] init];

    controller.liftId = self.arrayMaint[indexPath.row][@"elevatorId"];
    controller.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:controller animated:YES];
}
@end