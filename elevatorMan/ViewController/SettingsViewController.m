//
//  SettingsViewController.m
//  elevatorMan
//
//  Created by 长浩 张 on 16/7/6.
//
//

#import <Foundation/Foundation.h>
#import "SettingsViewController.h"
#import "Utils.h"
#import "AlarmViewController.h"
#import "PersonSignController.h"

#pragma mark -- SettingsCell

@interface SettingsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation SettingsCell


@end

#pragma mark -- SettingsViewController

@interface SettingsViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"设置"];
    _tableView.delegate = self;
    _tableView.dataSource = self;

    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}


/**
 *  检测是否需要升级
 */
- (void)checkUpdate
{

    NSString *urlString = [[Utils getServer] stringByAppendingString:@"checkVersion"];
    NSURL *url = [NSURL URLWithString:urlString];


    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"POST"];

    NSString *reqBody = @"{\"head\":{\"osType\":\"1\"}}";
    [urlRequest setHTTPBody:[reqBody dataUsingEncoding:NSUTF8StringEncoding]];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *_Nullable response, NSData *_Nullable data, NSError *_Nullable connectionError) {


        if (data.length > 0 && nil == connectionError)
        {
            NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"JSON:%@", json);
            NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
            NSDictionary *head = [jsonDic objectForKey:@"head"];
            NSString *rspCode = [head objectForKey:@"rspCode"];
            if (![rspCode isEqualToString:@"0"])
            {
                return;
            }

            NSDictionary *body = [jsonDic objectForKey:@"body"];

            NSNumber *remote = [body objectForKey:@"appVersion"];
            NSLog(@"remote version:%@", remote);

            NSNumber *local = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
            NSLog(@"local version:%@", local);

            if (remote.integerValue > local.integerValue)
            {
                [self performSelectorOnMainThread:@selector(alertUpdate) withObject:nil waitUntilDone:NO];
            }
            else
            {
                [self performSelectorOnMainThread:@selector(alertNoUpdate) withObject:nil waitUntilDone:NO];
            }

        }
    }];
}

/**
 *  提示进行升级
 */
- (void)alertUpdate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"新的版本可用，请进行升级" delegate:self cancelButtonTitle:@"暂不升级" otherButtonTitles:@"升级", nil];
    [alert show];
}

- (void)alertNoUpdate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您当前已经是最新版本" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

#pragma mark -- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settings_cell"];

    NSInteger row = indexPath.row;

    if (0 == row)
    {
        cell.label.text = @"修改密码";

    }
    else if (1 == row)
    {
        cell.label.text = @"检查更新";

    }
    else if (2 == row)
    {
        cell.label.text = @"我的签名";

    }
    else if (3 == row)
    {
        cell.label.text = @"关于";
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    if (0 == row)
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Person" bundle:nil];
        UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"PasswordPage"];

        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];

    }
    else if (1 == row)
    {
        [self checkUpdate];

    }
    else if (2 == row)
    {
        PersonSignController *controller = [[PersonSignController alloc] init];

        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (3 == row)
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Person" bundle:nil];
        UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"settings_about"];

        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark -- UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //升级，跳转到app下载页面
    if (ALARM_RECEIVED == alertView.tag || ALARM_ASSIGNED == alertView.tag)
    {

        if (1 == buttonIndex)
        {
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Worker" bundle:nil];
            AlarmViewController *controller = [board instantiateViewControllerWithIdentifier:@"alarm_process"];
            controller.alarmId = self.notifyAlarmId;

            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
    else
    {
        if (1 == buttonIndex)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://fir.im/ElevatorMan"]];
        }
    }
}

@end
