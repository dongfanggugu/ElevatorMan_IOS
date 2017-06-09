//
//  AlarmListElevatorManViewController.m
//  elevatorMan
//
//  Created by Cove on 15/6/16.
//
//

#import "AlarmListElevatorManViewController.h"
#import "HttpClient.h"
#import "AlarmProcessViewController.h"

#import "AlarmReceivedViewController.h"
#import "AlarmResultViewController.h"
#import <objc/runtime.h>

#pragma mark - AlarmListWorkerCell

@interface AlarmListWorkerCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIView *indexView;

@property (nonatomic, weak) IBOutlet UILabel *label_project;
@property (nonatomic, weak) IBOutlet UILabel *label_time;
@property (weak, nonatomic) IBOutlet UILabel *label_state;
@property (weak, nonatomic) IBOutlet UILabel *label_index;

@end


@implementation AlarmListWorkerCell


- (void)awakeFromNib {
    //
    [super awakeFromNib];
    self.indexView.layer.masksToBounds = YES;
    self.indexView.layer.cornerRadius = self.indexView.frame.size.height / 2;
}


@end

#pragma mark - AlarmListElevatorManViewController

@interface AlarmListElevatorManViewController ()

@property (nonatomic, strong) NSMutableArray *alarmListArray_unDone;
@property (nonatomic, strong) NSMutableArray *alarmListArray_Done;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;

@end

@implementation AlarmListElevatorManViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置菜单按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"icon_menu.png"] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 30, 30)];
    [button addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

    [self.segment addTarget:self action:@selector(selected:) forControlEvents:UIControlEventValueChanged];

    self.segment.selectedSegmentIndex = 0;

    //设置title
    //self.title = @"报警列表";

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self getAlarmListByRepairUserId];
}


- (void)selected:(id)sender {


    UISegmentedControl *control = (UISegmentedControl *) sender;
    switch (control.selectedSegmentIndex) {
        case 0:
            self.tableView.allowsSelection = YES;
            if (!self.alarmListArray_unDone || 0 == self.alarmListArray_unDone.count) {
                [HUDClass showHUDWithLabel:@"无正在进行的任务" view:self.view];

            }
            break;
        case 1:
            self.tableView.allowsSelection = NO;
            if (!self.alarmListArray_Done || 0 == self.alarmListArray_Done.count) {
                [HUDClass showHUDWithLabel:@"无已完成的任务" view:self.view];

            }
            break;


        default:
            break;
    }
    [self.tableView reloadData];
}


- (void)getAlarmListByRepairUserId {


    __weak AlarmListElevatorManViewController *weakself = self;
    [[HttpClient sharedClient] view:self.view post:@"getAlarmListByRepairUserId" parameter:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        //NSLog(@"%@",responseObject);

        [weakself dropFinishedAlarm:(NSArray *) [responseObject objectForKey:@"body"]];

    }];

}


- (void)dropFinishedAlarm:(NSArray *)array {
    if ((!array) || ([array count] == 0)) {
        //[[User sharedUser] showHUDWithLabel:@"当前无正在进行的报警任务"];
        return;
    }


    self.alarmListArray_unDone = [NSMutableArray arrayWithCapacity:1];
    self.alarmListArray_Done = [NSMutableArray arrayWithCapacity:1];

    for (NSInteger i = 0; i < array.count; i++) {
        NSString *misInformation = [array[i] objectForKey:@"isMisinformation"];
        NSString *userState = [array[i] objectForKey:@"userState"];


        if (![misInformation isEqualToString:@"1"]
                && ([userState isEqualToString:@"1"] || [userState isEqualToString:@"2"])) {
            [self.alarmListArray_unDone addObject:[array objectAtIndex:i]];

        } else {
            [self.alarmListArray_Done addObject:[array objectAtIndex:i]];
        }

    }

    if (nil == self.alarmListArray_unDone || 0 == self.alarmListArray_unDone.count) {
        [HUDClass showHUDWithLabel:@"无正在进行的任务" view:self.view];
    }

    [self.tableView reloadData];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.segment.selectedSegmentIndex == 0) {
        return [self.alarmListArray_unDone count];
    } else {
        return [self.alarmListArray_Done count];

    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlarmListWorkerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"alarmListWorkerCell" forIndexPath:indexPath];

    // Configure the cell...

    NSString *alarmTime;
    NSDictionary *communityInfo;

    if (self.segment.selectedSegmentIndex == 0) {
        alarmTime = [[self.alarmListArray_unDone objectAtIndex:indexPath.row] objectForKey:@"alarmTime"];
        communityInfo = [[self.alarmListArray_unDone objectAtIndex:indexPath.row] objectForKey:@"communityInfo"];
        NSString *userState = [self.alarmListArray_unDone[indexPath.row] objectForKey:@"userState"];

        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        if ([userState isEqualToString:@"1"]) {
            cell.label_state.text = @"已出发";
            cell.label_state.textColor = UIColorFromRGB(0xfff4be19);

        } else if ([userState isEqualToString:@"2"]) {
            cell.label_state.text = @"已到达";
            cell.label_state.textColor = UIColorFromRGB(0xfff4be19);
        }
    } else {
        alarmTime = [[self.alarmListArray_Done objectAtIndex:indexPath.row] objectForKey:@"alarmTime"];
        communityInfo = [[self.alarmListArray_Done objectAtIndex:indexPath.row] objectForKey:@"communityInfo"];
        NSString *misInfo = [self.alarmListArray_Done[indexPath.row] objectForKey:@"isMisinformation"];

        cell.accessoryType = UITableViewCellAccessoryNone;
        if ([misInfo isEqualToString:@"1"]) {
            cell.label_state.text = @"已撤消";
            cell.label_state.textColor = UIColorFromRGB(0xff11e767);

        } else {
            cell.label_state.text = @"已完成";
            cell.label_state.textColor = UIColorFromRGB(0xff11e767);

        }
    }


    cell.label_index.text = [NSString stringWithFormat:@"%ld", (long) indexPath.row + 1];
    cell.label_project.text = [communityInfo objectForKey:@"name"];
    cell.label_time.text = alarmTime;


    //设置item的index的颜色
    switch (indexPath.row % 8) {
        case 0: {
            cell.indexView.backgroundColor = UIColorFromRGB(0xffbeee78);
            break;
        }
        case 1: {
            cell.indexView.backgroundColor = UIColorFromRGB(0xffebe084);
            break;
        }
        case 2: {
            cell.indexView.backgroundColor = UIColorFromRGB(0xffbecccb);
            break;
        }
        case 3: {
            cell.indexView.backgroundColor = UIColorFromRGB(0xffb2f4b1);
            break;
        }
        case 4: {
            cell.indexView.backgroundColor = UIColorFromRGB(0xffb6b6fc);
            break;
        }
        case 5: {
            cell.indexView.backgroundColor = UIColorFromRGB(0xfffecb236);
            break;
        }
        case 6: {
            cell.indexView.backgroundColor = UIColorFromRGB(0xff99cdff);
            break;
        }
        case 7: {
            cell.indexView.backgroundColor = UIColorFromRGB(0xff4aeab7);
            break;
        }


        default:
            break;
    }

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *alarmId = [[self.alarmListArray_unDone objectAtIndex:indexPath.row] objectForKey:@"id"];

    NSString *userState = [self.alarmListArray_unDone[indexPath.row] objectForKey:@"userState"];

    NSInteger intUserState = [userState integerValue];

    UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"workerAlarmProcessViewController"];
    AlarmProcessViewController *vc = [[nav viewControllers] objectAtIndex:0];
    vc.alarmId = alarmId;
    vc.userState = intUserState;

    [self.sideMenuViewController presentViewController:nav animated:YES completion:nil];


}
@end
