//
//  ProBaseTabBarController.m
//  elevatorMan
//
//  Created by 长浩 张 on 2017/1/5.
//
//

#import <Foundation/Foundation.h>
#import "ProBaseTabBarController.h"
#import "ChatController.h"
#import "BannerNotice.h"
#import "TrackingViewController.h"
#import "ProAlarmManagerController.h"


@implementation ProBaseTabBarController


- (void)receivedAlarmNotify:(NSNotification *)notification {
    NSDictionary *info = [NSDictionary dictionaryWithDictionary:notification.userInfo];

    self.notifyAlarmId = [info objectForKey:@"alarmId"];

    if ([[info objectForKey:@"notifyType"] isEqualToString:@"PROPERTY_ALARM"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你负责的项目有新的报警!"
                                                       delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];
        [alert show];
    } else if ([[info objectForKey:@"notifyType"] isEqualToString:@"PROPERTY_ASSIGNED"]) {

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已经指派维修工前往!"
                                                       delegate:nil cancelButtonTitle:@"查看" otherButtonTitles:nil];
        [alert show];
    } else if ([[info objectForKey:@"notifyType"] isEqualToString:@"PROPERTY_ARRIVED"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已经有维修工到达救援现场!"
                                                       delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];
        alert.tag = ALARM_ASSIGNED;
        [alert show];
    } else if ([[info objectForKey:@"notifyType"] isEqualToString:@"PROPERTY_COMPLETED"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"维修工已完成，请确认完成!"
                                                       delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];
        alert.tag = ALARM_RECEIVED;
        [alert show];
    } else if ([[info objectForKey:@"notifyType"] isEqualToString:@"CHAT"]) {

        if ([self isKindOfClass:[ChatController class]]) {
            return;
        }
        UIView *notice = [BannerNotice bannerWith:nil bannerName:@"新消息" bannerContent:@"救援交流群有新的消息"];
        [self.view addSubview:notice];
    }
}

#pragma mark --  UIAlertViewDelegate


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (1 == buttonIndex) {
        if ([self isKindOfClass:[ProAlarmManagerController class]]) {
            return;
        }
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"MyProperty" bundle:nil];
        UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"pro_alarm_manager"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    //    if (ALARM_RECEIVED == alertView.tag)
    //    {
    //        if (1 == buttonIndex)
    //        {
    //            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Property" bundle:nil];
    //
    //            TrackingViewController *controller = [board instantiateViewControllerWithIdentifier:@"trackingViewController"];
    //            controller.alarmId = self.notifyAlarmId;
    //
    //            [self.navigationController pushViewController:controller animated:YES];
    //        }
    //    }
    //    else if (ALARM_ASSIGNED == alertView.tag)
    //    {
    //        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Property" bundle:nil];
    //
    //        TrackingViewController *controller = [board instantiateViewControllerWithIdentifier:@"trackingViewController"];
    //        controller.alarmId = self.notifyAlarmId;
    //
    //        [self.navigationController pushViewController:controller animated:YES];
    //        
    //    }

}


@end
