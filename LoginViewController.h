//
//  LoginViewController.h
//  SdkExampleDemo
//
//  Created by jasonchen on 16/4/14.
//  Copyright © 2016年 jason chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
{
    
    IBOutlet UIView *bgView;
    
    IBOutlet UIButton *loginButton;

    IBOutlet UIButton *registerButton;
    
    IBOutlet UIButton *findPassWord;
    
    IBOutlet UIButton *logoutButton;
    
    IBOutlet UIButton *lookDeviceAndVideo;
    
    IBOutlet UITextField *userTextField;
    
    IBOutlet UITextField *passWordTextField;
    
    IBOutlet UILabel *loginStatus;
}


- (IBAction)loginButton:(id)sender;

- (IBAction)registerButton:(id)sender;

- (IBAction)findPassWorClick:(id)sender;

- (IBAction)logoutButtonClick:(id)sender;

- (IBAction)lookDeviceAndVideo:(id)sender;







@end

