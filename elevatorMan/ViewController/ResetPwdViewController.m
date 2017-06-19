//
//  ResetPwdViewController.m
//  elevatorMan
//
//  Created by 长浩 张 on 16/1/13.
//
//

#import <Foundation/Foundation.h>
#import "ResetPwdViewController.h"


@interface ResetPwdViewController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tfUserName;

@property (weak, nonatomic) IBOutlet UITextField *tfPhone;

@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@end

@implementation ResetPwdViewController

@synthesize tfUserName;

@synthesize tfPhone;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"重置密码"];
    [self initView];
}

- (void)initView
{
    _btnSubmit.layer.masksToBounds = YES;
    _btnSubmit.layer.cornerRadius = 5;

    [_btnSubmit addTarget:self action:@selector(submit) forControlEvents:UIControlStateNormal];
}

/**
 *  提交
 */
- (void)submit
{
    NSString *userName = [tfUserName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if (0 == userName.length)
    {
        [HUDClass showHUDWithLabel:@"用户名不能为空" view:self.view];
        return;
    }

    NSString *phone = [tfPhone.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if (0 == phone.length)
    {
        [HUDClass showHUDWithLabel:@"手机号码不能为空" view:self.view];
        return;
    }

    if (![Utils isCorrectPhoneNumberOf:phone])
    {
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end