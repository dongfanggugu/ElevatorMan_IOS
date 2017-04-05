//
//  ConfirmProcessViewController.m
//  elevatorMan
//
//  Created by 长浩 张 on 16/7/5.
//
//

#import <Foundation/Foundation.h>
#import "ConfirmProcessViewController.h"
#import "FinishedReportViewController.h"
#import "ExceptionView.h"
#import "HttpClient.h"

@interface ConfirmProcessViewController()<ExceptionDelegate>

@property (weak, nonatomic) IBOutlet UIButton *button;

@property (weak, nonatomic) IBOutlet UIButton *btnUnComplete;

@end

@implementation ConfirmProcessViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"确认救援进度"];
    [self initNavRight];
    [self initView];
}

- (void)initView
{
    _button.layer.masksToBounds = YES;
    _button.layer.cornerRadius = 5;
    
    _btnUnComplete.layer.masksToBounds = YES;
    _btnUnComplete.layer.cornerRadius = 5;
    
    [_button addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnUnComplete addTarget:self action:@selector(unFinished) forControlEvents:UIControlEventTouchUpInside];
}

- (void)finish
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Worker" bundle:nil];
    FinishedReportViewController *controller = [board instantiateViewControllerWithIdentifier:@"finish_report"];
    controller.alarmId = _alarmId;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)unFinished
{
    ExceptionView *exceptionView = [ExceptionView viewFromNib];
    exceptionView.delegate = self;
    
    exceptionView.titleLabel.text = @"无法完成救援情况说明";
    
    //阴影
    exceptionView.layer.shadowColor = [UIColor blackColor].CGColor;
    exceptionView.layer.shadowOffset = CGSizeMake(4,4);
    exceptionView.layer.shadowOpacity = 0.6;
    exceptionView.layer.shadowRadius = 4;
    [self.view addSubview:exceptionView];
}

#pragma mark -- ExceptionDelegate
- (void)onClickConfirm:(NSString *)remark
{
    if (0 == remark.length)
    {
        [HUDClass showHUDWithLabel:@"请填写无法完成救援情况说明!"];
        return;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:_alarmId forKey:@"alarmId"];
    [dic setObject:remark forKey:@"remark"];
    
    
    [[HttpClient sharedClient] view:self.view post:@"unexpectedByUser"
                          parameter:dic
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                [HUDClass showHUDWithLabel:@"提交无法完成救援情况成功!"];
                                [self.navigationController popToRootViewControllerAnimated:YES];
                                
                            }  failed:^(id responseObject) {
                                NSString *rspMsg = [[responseObject objectForKey:@"head"] objectForKey:@"rspMsg"];
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:rspMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                [alert show];
                            }];
}


- (void)initNavRight
{
    //设置标题栏右侧
    UIButton *btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    
    [btnSubmit setImage:[UIImage imageNamed:@"icon_bbs"] forState:UIControlStateNormal];
    [btnSubmit addTarget:self action:@selector(chat) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btnSubmit];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)chat
{
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"chat_controller"];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
