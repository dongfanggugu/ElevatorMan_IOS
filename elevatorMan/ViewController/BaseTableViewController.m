//
//  BaseTableViewController.m
//  elevatorMan
//
//  Created by 长浩 张 on 16/7/7.
//
//

#import <Foundation/Foundation.h>
#import "BaseTableViewController.h"
#import "BaseViewController.h"
#import "AlarmViewController.h"
#import "BannerNotice.h"

@interface BaseTableViewController()


@end


@implementation BaseTableViewController

- (void)setNavIcon
{
    if (!self.navigationController)
    {
        return;
    }
    
    NSArray<UIViewController *> *controllers = self.navigationController.viewControllers;
    
    if (self == controllers[0])
    {
        return;
    }
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    imageView.image = [UIImage imageNamed:@"back_normal"];
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popup)]];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:imageView];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //设置回退icon
    [self setNavIcon];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    //监听报警相关通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedAlarmNotify:)
                                                 name:@"alarmNotification" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"alarmNotification" object:nil];
}

- (void)popup
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)setNavTitle:(NSString *)title
{
    if (!self.navigationController)
    {
        return;
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    label.text = title;
    label.font = [UIFont fontWithName:@"System" size:17];
    label.textColor = [UIColor whiteColor];
    [label setTextAlignment:NSTextAlignmentCenter];
    [self.navigationItem setTitleView:label];
}

- (void)hideBackIcon
{
    UIView *nullView = [[UIView alloc] initWithFrame:CGRectZero];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nullView];
}

- (void)receivedAlarmNotify:(NSNotification *)notification
{
    NSDictionary *info = [NSDictionary dictionaryWithDictionary:notification.userInfo];
    
    _notifyAlarmId = [info objectForKey:@"alarmId"];
    
    if ([[info objectForKey:@"notifyType"] isEqualToString:@"WORKER_CHOSEN_FALSE"])
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您未被指派参与此次救援,感谢您的参与!"
                                                       delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    else if ([[info objectForKey:@"notifyType"] isEqualToString:@"WORKER_CHOSEN_TRUE"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您已经被指派参与此次救援,点击确定进行处理!"
                                                       delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = ALARM_ASSIGNED;
        [alert show];
    }
    else if ([[info objectForKey:@"notifyType"] isEqualToString:@"WORKER_ALARM"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"有新的报警,点击确定查看报警详细信息!"
                                                       delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = ALARM_RECEIVED;
        [alert show];
    }
    else if ([[info objectForKey:@"notifyType"] isEqualToString:@"CHAT"])
    {
        UIView *notice = [BannerNotice bannerWith:nil bannerName:@"新消息" bannerContent:@"救援交流群有新的消息"];
        
        CGRect frame = notice.frame;
        frame.origin.y = 0;
        notice.frame = frame;
        [self.view addSubview:notice];
    }
}

#pragma mark --  UIAlertViewDelegate


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"button index:%ld", buttonIndex);
    
    if (ALARM_RECEIVED == alertView.tag)
    {
        if (1 == buttonIndex)
        {
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Worker" bundle:nil];
            UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"alarm_received"];
            
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
    else if (ALARM_ASSIGNED == alertView.tag)
    {
        if (1 == buttonIndex)
        {
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Worker" bundle:nil];
            AlarmViewController *controller = [board instantiateViewControllerWithIdentifier:@"alarm_process"];
            controller.alarmId = _notifyAlarmId;
            
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
    
}


- (void)dealloc
{
    NSLog(@"%@ dealloc", [self class]);
}


#pragma mark -- 设置状态栏字体为白色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
