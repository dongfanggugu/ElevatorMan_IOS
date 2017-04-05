//3241720068
//  HUDClass.m
//  FeiYueXueTang
//
//  Created by Cove on 15/7/2.
//  Copyright (c) 2015年 cfy. All rights reserved.
//

#import "HUDClass.h"
#import "AppDelegate.h"

@implementation HUDClass

+ (void)showHUDWithLabel:(NSString *)content
{
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[delegate window] animated:YES];
    
    [[delegate window] bringSubviewToFront:hud];
    
    hud.mode = MBProgressHUDModeText;
    hud.margin = 10.0f;
    hud.removeFromSuperViewOnHide = YES;
    
    hud.labelText = content;
    [hud hide:YES afterDelay:1.5f];
    
}

+ (void)showHUDWithLabel:(NSString *)content view:(UIView *)view
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[delegate window] animated:YES];
    
    [[delegate window] bringSubviewToFront:hud];
    
    hud.mode = MBProgressHUDModeText;
    hud.margin = 10.0f;
    hud.removeFromSuperViewOnHide = YES;
    
    hud.labelText = content;
    [hud hide:YES afterDelay:1.5f];
    
}


+ (MBProgressHUD *)showLoadingHUD
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:[delegate window]];
    
    hud.minSize = CGSizeMake(80.0f, 80.0f);
    hud.removeFromSuperViewOnHide = YES;
    
    [[delegate window] addSubview:hud];
    
    [hud show:YES];
    
    
    [[delegate window] bringSubviewToFront:hud];
    
    return hud;
}

+ (MBProgressHUD *)showLoadingHUD:(UIView *)view
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:[delegate window]];
    
    hud.minSize = CGSizeMake(80.0f, 80.0f);
    hud.removeFromSuperViewOnHide = YES;
    
    [[delegate window] addSubview:hud];
    
    [hud show:YES];
    
    
    [[delegate window] bringSubviewToFront:hud];
    
    return hud;
}

+ (void)hideLoadingHUD:(MBProgressHUD *)hud
{
    if ([hud superview])
    {
        [hud hide:YES];
    }
    
    
}

@end
