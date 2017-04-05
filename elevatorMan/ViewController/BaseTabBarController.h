//
//  BaseTabBarController.h
//  elevatorMan
//
//  Created by 长浩 张 on 2017/1/5.
//
//

#ifndef BaseTabBarController_h
#define BaseTabBarController_h

@interface BaseTabBarController : UITabBarController

@property (strong, nonatomic) NSString *notifyAlarmId;

- (void)initNavRightWithImage:(UIImage *)image;

- (void)setNavTitle:(NSString *)title;

- (void)hideBackIcon;

@end


#endif /* BaseTabBarController_h */
