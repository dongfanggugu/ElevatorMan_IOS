//
//  HUDClass.h
//  FeiYueXueTang
//
//  Created by Cove on 15/7/2.
//  Copyright (c) 2015年 cfy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"


@interface HUDClass : NSObject

+ (void)showHUDWithLabel:(NSString *)content;

+ (void)showHUDWithLabel:(NSString *)content view:(UIView *)view;


+ (MBProgressHUD *)showLoadingHUD;

+ (MBProgressHUD *)showLoadingHUD:(UIView *)view;

+ (void)hideLoadingHUD:(MBProgressHUD *)hud;
@end
