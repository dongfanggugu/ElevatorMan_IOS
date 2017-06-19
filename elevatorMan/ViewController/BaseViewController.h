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

@interface BaseViewController : UIViewController

@property (strong, nonatomic) NSString *notifyAlarmId;

- (void)setNavTitle:(NSString *)title;

- (void)receivedAlarmNotify:(NSNotification *)notification;

-  (void)initNavRightWithText:(NSString *)text;

- (void)initNavRightWithImage:(UIImage *)image;

- (void)onClickNavRight;

- (void)landscapeRight;

@property (assign, nonatomic) RoleType roleType;

@property (assign, nonatomic) CGFloat screenWidth;

@property (assign, nonatomic) CGFloat screenHeight;

@end


#endif /* BaseViewController_h */
