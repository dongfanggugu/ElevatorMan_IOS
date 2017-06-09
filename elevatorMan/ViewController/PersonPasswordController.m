//
//  PersonPasswordController.m
//  elevatorMan
//
//  Created by 长浩 张 on 15/12/24.
//
//

#import <Foundation/Foundation.h>
#import "PersonPasswordController.h"
#import "Utils.h"
#import "HttpClient.h"

@interface PersonPasswordController ()

@property (weak, nonatomic) IBOutlet UITextField *tfOriginal;

@property (weak, nonatomic) IBOutlet UITextField *tfPassword;

@property (weak, nonatomic) IBOutlet UITextField *tfConfirm;

@end

@implementation PersonPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitleRight];
    [self setTitleString:@"密码"];
}

/**
 *  设置标题
 *
 *  @param title <#title description#>
 */
- (void)setTitleString:(NSString *)title {
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    labelTitle.text = title;
    labelTitle.font = [UIFont fontWithName:@"System" size:17];
    labelTitle.textColor = [UIColor whiteColor];
    [self.navigationItem setTitleView:labelTitle];
}

/**
 *  设置标题栏右侧
 */
- (void)setTitleRight {
    UIButton *btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [btnSubmit setTitle:@"提交" forState:UIControlStateNormal];
    [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnSubmit.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnSubmit addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btnSubmit];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)submit {
    NSString *original = self.tfOriginal.text;
    NSString *password = self.tfPassword.text;
    NSString *confirm = self.tfConfirm.text;

    if (0 == original.length || 0 == password.length || 0 == confirm) {
        [HUDClass showHUDWithLabel:@"密码输入不能为空,请重新输入!" view:self.view];
        return;
    }

    if (![password isEqualToString:confirm]) {
        [HUDClass showHUDWithLabel:@"确认密码和密码输入不一致,请重新输入!" view:self.view];
        return;
    }

    if (password.length < 6) {
        [HUDClass showHUDWithLabel:@"密码至少为6位,请重新输入!" view:self.view];
        return;
    }

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[Utils md5:original] forKey:@"oldPwd"];
    [params setObject:[Utils md5:password] forKey:@"newPwd"];
    [[HttpClient sharedClient] view:self.view post:@"editUserPwd" parameter:params
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                [HUDClass showHUDWithLabel:@"密码修改成功!" view:self.view];
                                [self.navigationController popViewControllerAnimated:YES];
                            }];
}
@end