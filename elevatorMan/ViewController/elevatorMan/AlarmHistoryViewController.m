//
//  AlarmHistoryViewController.m
//  elevatorMan
//
//  Created by 长浩 张 on 16/3/25.
//
//

#import <Foundation/Foundation.h>
#import "AlarmHistoryViewController.h"
#import "HttpClient.h"
#import "AlarmReceivedViewController.h"
#import "AlarmResultViewController.h"
#import <objc/runtime.h>

#pragma mark -- AlarmCell

@interface AlarmCell (history)
@end

@implementation AlarmCell (history)

@end

#pragma mark -- AlarmInfo

@interface AlarmInfo (history)

@property (strong, nonatomic) NSString *address;

@property (strong, nonatomic) NSString *liftCode;

@property (strong, nonatomic) NSString *savedCount;

@property (strong, nonatomic) NSString *injuredCount;

@property (strong, nonatomic) NSString *picUrl;

@end

@implementation AlarmInfo (history)

//@dynamic address;
//
//@dynamic liftCode;
//
//@dynamic savedCount;
//
//@dynamic injuredCount;


- (NSString *)address
{
    return objc_getAssociatedObject(self, @selector(address));
}

- (void)setAddress:(NSString *)address
{
    objc_setAssociatedObject(self, @selector(address), address, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)liftCode
{
    return objc_getAssociatedObject(self, @selector(liftCode));
}

- (void)setLiftCode:(NSString *)liftCode
{
    objc_setAssociatedObject(self, @selector(liftCode), liftCode, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)savedCount
{
    return objc_getAssociatedObject(self, @selector(savedCount));
}

- (void)setSavedCount:(NSString *)savedCount
{
    objc_setAssociatedObject(self, @selector(savedCount), savedCount, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)injuredCount
{
    return objc_getAssociatedObject(self, @selector(injuredCount));
}

- (void)setInjuredCount:(NSString *)injuredCount
{
    objc_setAssociatedObject(self, @selector(injuredCount), injuredCount, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)picUrl
{
    return objc_getAssociatedObject(self, @selector(picUrl));
}

- (void)setPicUrl:(NSString *)picUrl
{
    objc_setAssociatedObject(self, @selector(picUrl), picUrl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


/**
 *  return AlarmInfo
 *
 *  @param dicInfo
 *
 *  @return
 */
+ (AlarmInfo *)alarmHistoryFromDic:(NSDictionary *)dicInfo
{
    NSString *isAbandon = [dicInfo objectForKey:@"isMisinformation"];
    if ([isAbandon isEqualToString:@"1"])
    {
        AlarmInfo *alarmInfo = [[AlarmInfo alloc] init];
        NSDictionary *community = [dicInfo objectForKey:@"communityInfo"];

        if (community)
        {
            alarmInfo.project = [community objectForKey:@"name"];
        }
        alarmInfo.alarmId = [dicInfo objectForKey:@"id"];
        alarmInfo.picUrl = [dicInfo objectForKey:@"pic"];
        alarmInfo.date = [dicInfo objectForKey:@"alarmTime"];

        //set the user state -10 if the alarm has been cancel
        alarmInfo.userState = -10;

        return alarmInfo;
    }
    else
    {
        NSString *userState = [dicInfo objectForKey:@"userState"];

        if (nil == userState)
        {
            AlarmInfo *alarmInfo = [[AlarmInfo alloc] init];
            NSDictionary *community = [dicInfo objectForKey:@"communityInfo"];

            if (community)
            {
                alarmInfo.project = [community objectForKey:@"name"];
            }
            alarmInfo.alarmId = [dicInfo objectForKey:@"id"];
            alarmInfo.date = [dicInfo objectForKey:@"alarmTime"];
            alarmInfo.userState = -9;

            return alarmInfo;
        }
        else
        {
            AlarmInfo *alarmInfo = [[AlarmInfo alloc] init];
            NSDictionary *community = [dicInfo objectForKey:@"communityInfo"];
            NSDictionary *liftInfo = [dicInfo objectForKey:@"elevatorInfo"];

            if (community)
            {
                alarmInfo.address = [community objectForKey:@"address"];
                alarmInfo.project = [community objectForKey:@"name"];
            }

            if (liftInfo)
            {
                alarmInfo.liftCode = [liftInfo objectForKey:@"liftNum"];
            }
            alarmInfo.alarmId = [dicInfo objectForKey:@"id"];
            alarmInfo.date = [dicInfo objectForKey:@"alarmTime"];
            alarmInfo.userState = [userState integerValue];

            alarmInfo.savedCount = [NSString stringWithFormat:@"%ld", [[dicInfo objectForKey:@"savedCount"] integerValue]];
            alarmInfo.injuredCount = [NSString stringWithFormat:@"%ld", [[dicInfo objectForKey:@"injureCount"] integerValue]];

            alarmInfo.picUrl = [dicInfo objectForKey:@"pic"];
            return alarmInfo;
        }
    }
    return nil;
}

@end

#pragma mark -- AlarmHistoryViewController

@interface AlarmHistoryViewController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@property (strong, nonatomic) NSMutableArray *mAlarmArray;

@end

@implementation AlarmHistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mAlarmArray = [[NSMutableArray alloc] init];
    [self setNavTitle:@"应急救援"];
    [self initView];
}

- (void)initView
{
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    //[self.mAlarmArray removeAllObjects];

    __weak AlarmHistoryViewController *weakSelf = self;

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"finished" forKey:@"scope"];

    [[HttpClient sharedClient] view:self.view post:@"getAlarmListByRepairUserId" parameter:params
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                NSArray *body = [responseObject objectForKey:@"body"];

                                //clear the mAlarmArry here to avoid the crash when back to the page and
                                //slide the page
                                [self.mAlarmArray removeAllObjects];

                                //the data received from server is too much, abandon others
                                if (body && body.count > 0)
                                {
                                    for (NSDictionary *dic in body)
                                    {
                                        AlarmInfo *alarmInfo = [AlarmInfo alarmHistoryFromDic:dic];

                                        if (alarmInfo)
                                        {
                                            [weakSelf.mAlarmArray addObject:alarmInfo];
                                        }
                                    }
                                }

                                [weakSelf.mTableView reloadData];

                            }];

}

#pragma mark -- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mAlarmArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    AlarmCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlarmCell"];

    AlarmInfo *alarmInfo = self.mAlarmArray[indexPath.row];

    cell.labelProject.text = alarmInfo.project;
    cell.labelDate.text = alarmInfo.date;

    if (-10 == alarmInfo.userState)
    {
        cell.labelState.text = @"已撤销";
    }
    else if (-9 == alarmInfo.userState)
    {
        cell.labelState.text = @"未指派";
    }
    else if (3 == alarmInfo.userState)
    {
        cell.labelState.text = @"已完成";
    }
    else if (4 == alarmInfo.userState)
    {
        cell.labelState.text = @"意外情况";
    }

    cell.labelIndex.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    [cell setColorWithIndex:indexPath.row];

    return cell;
}

/**
 *  setting the height of the tableview cell
 *
 *  @param tableView
 *  @param indexPath
 *
 *  @return
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark -- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AlarmInfo *info = self.mAlarmArray[indexPath.row];
    NSInteger userState = info.userState;

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
        AlarmResultViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AlarmResultViewController"];
        vc.project = info.project;
        vc.address = info.address;
        vc.liftCode = info.liftCode;
        vc.alarmTime = info.date;
        vc.savedCount = info.savedCount;
        vc.injuredCount = info.injuredCount;
        vc.picUrl = info.picUrl;

        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
