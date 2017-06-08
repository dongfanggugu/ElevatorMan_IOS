//
//  AlarmHistoryController.m
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/8.
//
//

#import "AlarmHistoryController.h"
#import "ComAlarmCell.h"
#import "AlarmResultViewController.h"

@interface AlarmHistoryController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *arrayAlarm;

@end

@implementation AlarmHistoryController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"救援历史"];
    [self initView];
}

- (NSMutableArray *)arrayAlarm
{
    if (!_arrayAlarm) {
        _arrayAlarm = [NSMutableArray array];
    }
    
    return _arrayAlarm;
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   // return self.arrayAlarm.count;
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ComAlarmCell *cell = [tableView dequeueReusableCellWithIdentifier:[ComAlarmCell identifier]];

    if (!cell) {
        cell = [ComAlarmCell cellFromNib];
    }
    cell.lbIndex.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];

    //NSDictionary *info = self.arrayAlarm[indexPath.row];

    cell.lbProject.text = @"望京soho";
    cell.lbTime.text = @"2017-12-12 12:12:12";

    cell.lbState.text = @"已完成";

    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ComAlarmCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //NSDictionary *info = self.arrayAlarm[indexPath.row];
    //NSInteger userState = [info[@"userState"] integerValue];
    
    NSInteger userState = 5;
    
    if (-10 == userState)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该报警已经取消，无法查看救援结果!"
                                                       delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (-9 == userState)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该报警已经取消，无法查看救援结果!"
                                                       delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Worker" bundle:nil];
        AlarmResultViewController *vc = [board instantiateViewControllerWithIdentifier:@"AlarmResultViewController"];
        vc.project = @"望京soho";
        vc.address = @"望京soho";
        vc.liftCode = @"12313131313";
        vc.alarmTime = @"2017-12-12 12:12:12";
        vc.savedCount = @"5";
        vc.injuredCount = @"2";
        vc.picUrl = @"http://img002.21cnimg.com/photos/album/20150702/m600/2D79154370E073A2BA3CD4D07868861D.jpg";
        
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }

}


@end
