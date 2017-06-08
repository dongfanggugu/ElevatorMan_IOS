//
//  BaseViewController.m
//  WNES
//
//  Created by 长浩 张 on 16/5/16.
//  Copyright © 2016年 长浩 张. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"
#import "AlarmViewController.h"
#import "BannerNotice.h"
#import "ChatController.h"



@interface BaseViewController() <UIAlertViewDelegate>

@end

@implementation BaseViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (CGFloat)screenWidth
{
    return [UIScreen mainScreen].bounds.size.width;
}

- (CGFloat)screenHeight
{
    return [UIScreen mainScreen].bounds.size.height;
}


- (void)setNavIcon
{
    if (!self.navigationController)
    {
        NSLog(@"navi is nil");
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
    
    [self portrait];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"alarmNotification" object:nil];
}

- (void)popup
{
    NSArray *array = self.navigationController.viewControllers;
    if (1 ==  [array count])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }    
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

/**
 使用文字初始化导航栏右侧按钮
 **/
-  (void)initNavRightWithText:(NSString *)text
{
    if (!self.navigationController) {
        return;
    }
    
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 25)];
    [btnRight setTitle:text forState:UIControlStateNormal];
    [btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnRight.titleLabel.font = [UIFont systemFontOfSize:15];
    btnRight.titleLabel.textAlignment = NSTextAlignmentRight;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    
    [btnRight addTarget:self action:@selector(onClickNavRight) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onClickNavRight
{
    
}

/**
 使用图片初始化导航栏右侧按钮
 **/
- (void)initNavRightWithImage:(UIImage *)image
{
    if (!self.navigationController)
    {
        return;
    }
    
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [btnRight setImage:image forState:UIControlStateNormal];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    
    [btnRight addTarget:self action:@selector(onClickNavRight) forControlEvents:UIControlEventTouchUpInside];
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
        
        if ([self isKindOfClass:[ChatController class]])
        {
            return;
        }
        UIView *notice = [BannerNotice bannerWith:nil bannerName:@"新消息" bannerContent:@"救援交流群有新的消息"];
        [self.view addSubview:notice];
    }
}

#pragma mark --  UIAlertViewDelegate


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
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

- (void)portrait
{
    if([[UIDevice currentDevice]respondsToSelector:@selector(setOrientation:)]) {
        
        SEL selector = NSSelectorFromString(@"setOrientation:");
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        
        [invocation setSelector:selector];
        
        [invocation setTarget:[UIDevice currentDevice]];
        
        int val = UIInterfaceOrientationPortrait;
        
        [invocation setArgument:&val atIndex:2];
        
        [invocation invoke];
    }
}

- (void)landscapeRight
{
    if([[UIDevice currentDevice]respondsToSelector:@selector(setOrientation:)]) {
        
        SEL selector = NSSelectorFromString(@"setOrientation:");
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        
        [invocation setSelector:selector];
        
        [invocation setTarget:[UIDevice currentDevice]];
        
        int val = UIInterfaceOrientationLandscapeRight;
        
        [invocation setArgument:&val atIndex:2];
        
        [invocation invoke];
    }
}

@end
