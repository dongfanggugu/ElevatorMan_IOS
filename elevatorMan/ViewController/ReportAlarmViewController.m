//
//  ReportAlarmViewController.m
//  elevatorMan
//
//  Created by Cove on 15/6/16.
//
//

#import "ReportAlarmViewController.h"
#import "HttpClient.h"


@interface ReportAlarmViewController () <UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic) BOOL isInjured;

@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@property (weak, nonatomic) IBOutlet UILabel *alarmDetail;

@property (weak, nonatomic) IBOutlet UITextView *tvRemark;

@end

@implementation ReportAlarmViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"一键报警"];

    self.isInjured = NO;

    //显示报警位置
    [self showAlarmDetail];
    [self initView];
}

- (void)initView
{
    _tvRemark.layer.masksToBounds = YES;

    _tvRemark.layer.cornerRadius = 5;

    _btnSubmit.layer.masksToBounds = YES;

    _btnSubmit.layer.cornerRadius = 5;

    [_btnSubmit addTarget:self action:@selector(reportAlarm) forControlEvents:UIControlEventTouchUpInside];
}

- (void)showAlarmDetail
{
    _alarmDetail.text = [NSString stringWithFormat:@"%@%@号楼%@号电梯", self.projectName, self.buildingNum, [self.liftDic objectForKey:@"number"]];
}

#pragma mark - IBAction

- (IBAction)reportAlarm
{
    NSString *remark = _tvRemark.text;

    if (0 == remark)
    {
        [self showMsgAlert:@"您需要填写一下情况说明!"];
    }
    //设置参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[self.liftDic objectForKey:@"id"] forKey:@"liftId"];
    [dic setObject:[NSString stringWithFormat:@"%@", [NSNumber numberWithBool:self.isInjured]] forKey:@"isInjure"];
    [dic setObject:remark forKey:@"remark"];


    __weak typeof(self) weakSelf = self;
    //请求
    [[HttpClient sharedClient] post:@"alarm" parameter:dic
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {

                                //报警完成后给予提示
                                UIAlertView *alert;
                                alert = [[UIAlertView alloc] initWithTitle:@"新消息" message:@"报警成功，系统正在指派最近的维修工前往维修，请耐心等待！如需跟踪报警进度，请进入‘当前报警’查看" delegate:weakSelf cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                                [alert show];
                            }];


}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToRootViewControllerAnimated:YES];

}

- (IBAction)choiceInJured:(id)sender
{

    self.isInjured = !self.isInjured;

    UIButton *button = (UIButton *) sender;

    if (self.isInjured)
    {
        [button setBackgroundImage:[UIImage imageNamed:@"icon_choice.png"] forState:UIControlStateNormal];
    }
    else
    {
        [button setBackgroundImage:[UIImage imageNamed:@"icon_noChoice.png"] forState:UIControlStateNormal];
    }
}


#pragma mark - UITextFiledDelegate

//当用户按下return键或者按回车键，keyboard消失
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
