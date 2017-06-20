//
//  LoginViewController.m
//  SdkExampleDemo
//
//  Created by jasonchen on 16/4/14.
//  Copyright © 2016年 jason chen. All rights reserved.
//

#import "LoginViewController.h"
#import "ForgetPassWordViewController.h"
#import "MainViewController.h"

@interface LoginViewController ()

@property (nonatomic, strong) UIActivityIndicatorView *loginViewIndicatorView;
@end
@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNewData];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    bgView.center =  CGPointMake(HB_WIDTH/2., HB_HEIGHT/2.);
    
}

- (void)creatNewData {
    
    _loginViewIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _loginViewIndicatorView.center = CGPointMake(HB_WIDTH/2., HB_HEIGHT/2.);
    [_loginViewIndicatorView hidesWhenStopped];
    _loginViewIndicatorView.color = [UIColor blueColor];
    [self.view addSubview:_loginViewIndicatorView];
    
    
    [userTextField setTintColor:[UIColor blueColor]];
    [passWordTextField setTintColor:[UIColor blueColor]];
    userTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passWordTextField.clearButtonMode  = UITextFieldViewModeWhileEditing;
    userTextField.clearsOnBeginEditing = YES;
    passWordTextField.clearsOnBeginEditing = YES;
    UITapGestureRecognizer *tapGestureRecgnizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBoard:)];
    [bgView addGestureRecognizer:tapGestureRecgnizer];
    
}

- (void)hiddenKeyBoard:(UITapGestureRecognizer*)tap {
    
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

/**
 * 登录账户
 */
- (IBAction)loginButton:(id)sender {
    
    if (userTextField.text.length > 0 && passWordTextField.text.length > 0) {
        [self.view endEditing:YES];
        [self startAnimation];
        NSLog(@"%@=====%@",userTextField.text,passWordTextField.text);
        
        [[AccountManager sharedManager].ydtNetSdk loginYdtWithName:userTextField.text password:passWordTextField.text pushId:nil completionHandler:^(YdtUserInfo *userInfo) {
            
            if (userInfo.errorCode == 0) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self stopAnimation];
                    loginStatus.text  = @"登录状态:登录成功";
                });

                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self stopAnimation];
                    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"%d",userInfo.errorCode] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alerView show];
                });
               
            }
        }];
        
    } else {
       
        //要求完整信息
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请完善信息" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alerView show];
    }
}

/**
 * 注册用户
 */
- (IBAction)registerButton:(id)sender {
    
    ForgetPassWordViewController *registerView = [[ForgetPassWordViewController alloc] initWithNibName:@"ForgetPassWordViewController" bundle:nil];
    registerView.title  = @"注册";
    registerView.viewtype = REGISTER_TYPE;
    [self.navigationController pushViewController:registerView animated:YES];
    
}

- (IBAction)findPassWorClick:(id)sender {
    
    ForgetPassWordViewController *forgetViewCN = [[ForgetPassWordViewController alloc] initWithNibName:@"ForgetPassWordViewController" bundle:nil];
    forgetViewCN.title  = @"忘记密码";
    forgetViewCN.viewtype = FORGETPASSWORD_TYPE;
    [self.navigationController pushViewController:forgetViewCN animated:YES];
}

- (IBAction)logoutButtonClick:(id)sender {
    
    if ([loginStatus.text isEqualToString:@"登录状态:登录成功"]) {
        
        [self startAnimation];
        
        [[AccountManager sharedManager].ydtNetSdk  logoutYdtWithCompletionHandler:^(int result) {
        
          if (result == YdtErrorSuccess) {
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  [self stopAnimation];
                   loginStatus.text = @"登录状态:未登录";
              });
              
          } else {
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  
                  [self stopAnimation];
                  UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"%d",result] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                  [alerView show];
              });
          }
      }];
    }
}

/**
 *  查看视屏列表和设备列表
 */
- (IBAction)lookDeviceAndVideo:(id)sender {
    
    if ([loginStatus.text isEqualToString:@"登录状态:登录成功"]) {
        
        MainViewController *main = [[MainViewController alloc] init];
        [self.navigationController pushViewController:main animated:YES];
        
    } else {
        
        //要求完整信息
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请先登录" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alerView show];
    }
    
}

- (void)startAnimation {
    
    [_loginViewIndicatorView startAnimating];
    bgView.userInteractionEnabled = NO;
}
- (void)stopAnimation {
 
    [_loginViewIndicatorView stopAnimating];
    bgView.userInteractionEnabled = YES;
}
@end
