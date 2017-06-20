//
//  ForgetPassWordViewController.m
//  SdkExampleDemo
//
//  Created by jasonchen on 16/4/15.
//  Copyright © 2016年 jason chen. All rights reserved.
//

#import "ForgetPassWordViewController.h"
#import "AccountManager.h"
#import "YdtNetSdk.h"
@interface ForgetPassWordViewController ()

@property (strong, nonatomic) UIActivityIndicatorView *forgetPassWordViewIndicatorView;
@end

@implementation ForgetPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatFunction];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    forgetBgView.center =  CGPointMake(HB_WIDTH/2., HB_HEIGHT/2.);
}


- (void)creatFunction {
    
    _forgetPassWordViewIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _forgetPassWordViewIndicatorView.center = CGPointMake(HB_WIDTH/2., HB_HEIGHT/2.);
    [_forgetPassWordViewIndicatorView hidesWhenStopped];
    _forgetPassWordViewIndicatorView.color = [UIColor blueColor];
    [self.view addSubview:_forgetPassWordViewIndicatorView];
    
    UITapGestureRecognizer *Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBoard:)];
    [forgetBgView addGestureRecognizer:Tap];
}

- (void)hiddenKeyBoard:(UITapGestureRecognizer *)getsture {
    
    [self.view endEditing:YES];
}


- (IBAction)getCodeButtonClick:(id)sender {
    
    NSString *deviceLanguage = [[NSString alloc] init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if ([currentLanguage isEqualToString:@"zh-Hans-CN"] || [currentLanguage isEqualToString:@"zh-Hans"]) {
        
        //简体中文
        deviceLanguage = @"zh_CN";
        
    } else {
        
        //英文以及其他语言
        deviceLanguage = @"en_US";
        
    }
    if (phoneNoTextField.text.length > 0 && phoneNoTextField!= nil) {
        
        [[AccountManager sharedManager].ydtNetSdk getAccountInfoWithName:phoneNoTextField.text completionHandler:^(YdtUserInfo *userInfo) {
            
            if (userInfo.errorCode == 0) {
                
                if (_viewtype == FORGETPASSWORD_TYPE) {
                    
                    //执行获取验证码操作
                    [[AccountManager sharedManager].ydtNetSdk getVerificationCodeWithAddress:phoneNoTextField.text language:deviceLanguage completionHandler:^(YdtVervificationCodeInfo *codeInfo) {
                        
                        if (codeInfo.errorCode != 0) {
                            //获取失败
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                [self alertViewWithReason:[NSString stringWithFormat:@"%@",[YdtNetSdk getErrorMessageWithErrorCode: codeInfo.errorCode]]];
                            });
                            
                        } else {
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self alertViewWithReason:[NSString stringWithFormat:@"验证码已发送到用户%@",phoneNoTextField.text]];
                            });
                        }
                    }];
                    
                } else {
                 
                    //注册用户
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self alertViewWithReason:@"账户已注册"];
                    });
                }
                
            } else {
                
                if (_viewtype == FORGETPASSWORD_TYPE) {
                    
                    //找回密码
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self alertViewWithReason:[NSString stringWithFormat:@"%@",[YdtNetSdk getErrorMessageWithErrorCode: userInfo.errorCode]]];
                    });
                    
                } else {
                    
                    //注册
                    //执行获取验证码操作
                    [[AccountManager sharedManager].ydtNetSdk getVerificationCodeWithAddress:phoneNoTextField.text language:deviceLanguage completionHandler:^(YdtVervificationCodeInfo *codeInfo)  {

                        if (codeInfo.errorCode != 0) {
                            //获取失败
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                [self alertViewWithReason:[NSString stringWithFormat:@"%d",codeInfo.errorCode]];
                            });
                            
                        } else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self alertViewWithReason:[NSString stringWithFormat:@"验证码已发送到用户%@",phoneNoTextField.text]];
                            });
                        }
                    }];
                }
            }
        }];
     
    } else {
        
        [self alertViewWithReason:@"手机号或邮箱号不能为空"];
    }
}

- (IBAction)sureButtonClick:(id)sender {
    
    if (phoneNoTextField.text.length > 0 && phoneNoTextField.text != nil && codeTextField.text.length > 0 && codeTextField.text != nil && passWordTextField.text.length > 0 && passWordTextField.text != nil) {
        [self startAnimation];
        if (_viewtype == FORGETPASSWORD_TYPE) {
            
            //忘记密码
            [[AccountManager sharedManager].ydtNetSdk findPasswordAndLoginWithName:phoneNoTextField.text  verificationCode:codeTextField.text pushId:nil completionHandler:^(YdtUserInfo *userInfo) {
               
                if (userInfo.errorCode  == 0) {
                    
                    [[AccountManager sharedManager].ydtNetSdk setAccountPassword:passWordTextField.text completionHandler:^(int result) {
                        
                        if (result == YdtErrorSuccess) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                           
                            [self stopAnimation];
                            [self alertViewWithReason:@"修改成功"];
                        });
                            
                        } else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                [self stopAnimation];
                                [self alertViewWithReason:[NSString stringWithFormat:@"%@",[YdtNetSdk getErrorMessageWithErrorCode:result]]];
                                
                            });
                        }
                        
                    }];
                    
                } else {
                    
                       
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self stopAnimation];
                            [self alertViewWithReason:[NSString stringWithFormat:@"%@",[YdtNetSdk getErrorMessageWithErrorCode: userInfo.errorCode]]];
                            
                        });
                    
                }
            }];
            
            
        } else {
            
            //注册
            [[AccountManager sharedManager].ydtNetSdk registerAndLoginWithAddress:phoneNoTextField.text verificationCode:codeTextField.text pushId:nil completionHandler:^(YdtUserInfo *userInfo) {
                
                if (userInfo.errorCode  == 0) {
                    
                    [[AccountManager sharedManager].ydtNetSdk setAccountPassword:passWordTextField.text completionHandler:^(int result) {
                        
                        if (result == YdtErrorSuccess) {
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                [self stopAnimation];
                                [self alertViewWithReason:@"注册成功"];
                            });
                            
                        } else {
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                [self stopAnimation];
                                [self alertViewWithReason:[NSString stringWithFormat:@"%d",result]];
                                
                            });
                        }
                        
                    }];
                    
                } else {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self stopAnimation];
                        [self alertViewWithReason:[NSString stringWithFormat:@"%d",userInfo.errorCode]];
                        
                    });
                }
            }];
        }
        
    } else {
        
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请完善信息" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alerView show];
    }
}

- (void)startAnimation {
    
    [_forgetPassWordViewIndicatorView startAnimating];
    forgetBgView.userInteractionEnabled = NO;
}
- (void)stopAnimation {
    
    [_forgetPassWordViewIndicatorView stopAnimating];
    forgetBgView.userInteractionEnabled = YES;
}

- (void)alertViewWithReason:(NSString *)reason {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:reason delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertView show];
    [self performSelector:@selector(forgetPassWordViewDismissAlertView:) withObject:alertView afterDelay:1.0];
}
- (void)forgetPassWordViewDismissAlertView:(UIAlertView *)alertView {
    
    if (alertView) {
        
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
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

@end
