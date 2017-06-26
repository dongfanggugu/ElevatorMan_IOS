//
//  BaseViewController.h
//  WNES
//
//  Created by 长浩 张 on 16/5/16.
//  Copyright © 2016年 长浩 张. All rights reserved.
//

#ifndef BaseViewController_h
#define BaseViewController_h

#import <UIKit/UIKit.h>

#define ALARM_RECEIVED 1001
#define ALARM_ASSIGNED 1002
#define ALARM_CANCEL 1003

@class BaseAlertController;

@interface BaseViewController : UIViewController

@property (strong, nonatomic) NSString *notifyAlarmId;

- (void)setNavTitle:(NSString *)title;

- (void)receivedAlarmNotify:(NSNotification *)notification;

-  (void)initNavRightWithText:(NSString *)text;

- (void)initNavRightWithImage:(UIImage *)image;

- (void)onClickNavRight;

- (void)landscapeRight;

- (void)showMsgAlert:(NSString *)msg;

- (void)onMsgAlertDismiss;

/**
 * 弹出框提示
 */
- (void)showMsgAlert:(NSString *)msg userInfo:(NSDictionary *)userInfo;

- (void)onMsgAlertDismiss:(BaseAlertController *)controller;

/**
 * 显示未加入怡墅业务信息
 */
- (void)showUnJoinedInfo;

@property (assign, nonatomic, readonly) RoleType roleType;

@property (assign, nonatomic, readonly) CGFloat screenWidth;

@property (assign, nonatomic, readonly) CGFloat screenHeight;

@property (assign, nonatomic, readonly) BOOL joinVilla;

@end


#endif /* BaseViewController_h */
