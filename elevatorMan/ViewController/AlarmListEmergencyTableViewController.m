//
//  AlarmListEmergencyTableViewController.m
//  elevatorMan
//
//  Created by Cove on 15/6/16.
//
//

#import "AlarmListEmergencyTableViewController.h"
#import "HttpClient.h"
#import "AlarmResultViewController.h"


#pragma mark - AlarmListEmergencyCell

@interface AlarmListEmergencyCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIView *indexView;

@property (nonatomic, weak) IBOutlet UILabel *label_project;

@property (nonatomic, weak) IBOutlet UILabel *label_time;

@property (weak, nonatomic) IBOutlet UILabel *label_state;

@property (weak, nonatomic) IBOutlet UILabel *label_index;


@end


@implementation AlarmListEmergencyCell


- (void)awakeFromNib
{
    [super awakeFromNib];

    self.indexView.layer.masksToBounds = YES;

    self.indexView.layer.cornerRadius = 20;

}


@end


#pragma mark - AlarmListEmergencyTableViewController

@interface AlarmListEmergencyTableViewController ()

@property (nonatomic, strong) NSMutableArray *arrayData;

@end

@implementation AlarmListEmergencyTableViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getPropertyAlarmList];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];

    [self initView];

}

- (void)initData
{
    _arrayData = [NSMutableArray array];
}

- (void)initView
{
    self.tableView.bounces = YES;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}


- (void)getPropertyAlarmList
{
    //设置
    __weak AlarmListEmergencyTableViewController *weakSelf = self;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"finished" forKey:@"scope"];
    //请求
    [[HttpClient sharedClient] view:self.view post:@"getAlarmListByUserId" parameter:params success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [weakSelf.arrayData removeAllObjects];
        [weakSelf.arrayData addObjectsFromArray:[responseObject objectForKey:@"body"]];
        [weakSelf.tableView reloadData];
    }];

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.

    return _arrayData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlarmListEmergencyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"alarmListEmergencyCell" forIndexPath:indexPath];

    NSDictionary *info = _arrayData[indexPath.row];

    NSString *alarmTime = [info objectForKey:@"alarmTime"];
    NSDictionary *communityInfo = [info objectForKey:@"communityInfo"];
    NSString *alarmState = [info objectForKey:@"state"];
    NSString *userState = [info objectForKey:@"userState"];

    cell.label_index.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    cell.label_project.text = [communityInfo objectForKey:@"name"];
    cell.label_time.text = alarmTime;

    switch (indexPath.row % 8)
    {

        case 0:
        {
            cell.indexView.backgroundColor = UIColorFromRGB(0xffbeee78);
            break;
        }
        case 1:
        {
            cell.indexView.backgroundColor = UIColorFromRGB(0xffebe084);
            break;
        }
        case 2:
        {
            cell.indexView.backgroundColor = UIColorFromRGB(0xffbecccb);
            break;
        }
        case 3:
        {
            cell.indexView.backgroundColor = UIColorFromRGB(0xffb2f4b1);
            break;
        }
        case 4:
        {
            cell.indexView.backgroundColor = UIColorFromRGB(0xffb6b6fc);
            break;
        }
        case 5:
        {
            cell.indexView.backgroundColor = UIColorFromRGB(0xfffecb236);
            break;
        }
        case 6:
        {
            cell.indexView.backgroundColor = UIColorFromRGB(0xff99cdff);
            break;
        }
        case 7:
        {
            cell.indexView.backgroundColor = UIColorFromRGB(0xff4aeab7);
            break;
        }


        default:
            break;
    }

    //设置报警状态描述
    NSString *misInfo = [info objectForKey:@"isMisinformation"];

    if ([misInfo isEqualToString:@"1"])
    {
        cell.label_state.text = @"已撤消";
        cell.label_state.textColor = UIColorFromRGB(0xff11e767);

    }
    else
    {
        if ([userState isEqualToString:@"5"])
        {
            cell.label_state.text = @"已确认";
            cell.label_state.textColor = UIColorFromRGB(0xff11e767);

        }
        else if ([alarmState isEqualToString:@"0"])
        {
            cell.label_state.text = @"指派中";
            cell.label_state.textColor = UIColorFromRGB(0xfff4be19);

        }
        else if ([alarmState isEqualToString:@"1"])
        {
            cell.label_state.text = @"已出发";
            cell.label_state.textColor = UIColorFromRGB(0xfff4be19);

        }
        else if ([alarmState isEqualToString:@"2"])
        {
            cell.label_state.text = @"已到达";
            cell.label_state.textColor = UIColorFromRGB(0xfff4be19);

        }
        else if ([alarmState isEqualToString:@"3"])
        {
            cell.label_state.text = @"已完成";
            cell.label_state.textColor = UIColorFromRGB(0xff11e767);
        }
    }

    return cell;
}

#pragma mark - Table view Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *info = _arrayData[indexPath.row];
    NSInteger userState = [[info objectForKey:@"userState"] integerValue];

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

        NSDictionary *community = [info objectForKey:@"communityInfo"];
        vc.project = [community objectForKey:@"name"];
        vc.address = [community objectForKey:@"address"];

        NSDictionary *liftInfo = [info objectForKey:@"elevatorInfo"];
        vc.liftCode = [liftInfo objectForKey:@"liftNum"];

        vc.alarmTime = [info objectForKey:@"alarmTime"];

        NSString *savedCount = [NSString stringWithFormat:@"%ld", [[info objectForKey:@"savedCount"] integerValue]];
        NSString *injuredCount = [NSString stringWithFormat:@"%ld", [[info objectForKey:@"injureCount"] integerValue]];


        vc.savedCount = savedCount;
        vc.injuredCount = injuredCount;

        vc.picUrl = [info objectForKey:@"pic"];


        //vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }

}

@end
