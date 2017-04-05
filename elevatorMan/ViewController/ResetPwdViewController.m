//
//  ResetPwdViewController.m
//  elevatorMan
//
//  Created by 长浩 张 on 16/1/13.
//
//

#import <Foundation/Foundation.h>
#import "ResetPwdViewController.h"
#import "HttpClient.h"
#import "Utils.h"


@interface ResetPwdViewController()<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewTitle;

@property (weak, nonatomic) IBOutlet UIImageView *ivBack;

@property (weak, nonatomic) IBOutlet UILabel *labelSubmit;

@property (weak, nonatomic) IBOutlet UITextField *tfUserName;

@property (weak, nonatomic) IBOutlet UITextField *tfPhone;

@end


@implementation ResetPwdViewController

@synthesize ivBack;

@synthesize labelSubmit;

@synthesize tfUserName;

@synthesize tfPhone;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置标题颜色
    UIColor *colorTitle = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    [self.viewTitle setBackgroundColor:colorTitle];
    
    //后退按钮
    ivBack.userInteractionEnabled = YES;
    [ivBack addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)]];
    
    //提交按钮
    labelSubmit.userInteractionEnabled = YES;
    [labelSubmit addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(submit)]];
    
    
}

/**
 *  返回
 */
- (void)goBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  提交
 */
- (void)submit {
    NSString *userName = [tfUserName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (0 == userName.length) {
        [HUDClass showHUDWithLabel:@"用户名不能为空" view:self.view];
        return;
    }
    
    NSString *phone = [tfPhone.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (0 == phone.length) {
        [HUDClass showHUDWithLabel:@"手机号码不能为空" view:self.view];
        return;
    }
    
    if (![Utils isCorrectPhoneNumberOf:phone]) {
        [HUDClass showHUDWithLabel:@"请输入合法的手机号码" view:self.view];
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userName forKey:@"userName"];
    [params setObject:phone forKey:@"tel"];
    
    __weak ResetPwdViewController *weakSelf = self;
    
    [[HttpClient sharedClient] view:self.view post:@"resetPWD" parameter:params
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"重置后的密码已经发送到您的手机上，请注意短信查收" delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                [alertView show];
                            }];
}

#pragma mark -- UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end