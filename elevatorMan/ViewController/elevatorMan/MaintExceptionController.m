//
//  MaintExceptionController.m
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/5.
//
//

#import "MaintExceptionController.h"
#import "MaintExceptionView.h"

@interface MaintExceptionController () <UITableViewDelegate, UITableViewDataSource, MaintExceptionViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) MaintExceptionView *exceptionView;

@end

@implementation MaintExceptionController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"无法出发"];
    [self initView];
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];

    _tableView.delegate = self;

    _tableView.dataSource = self;

    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    _exceptionView = [MaintExceptionView viewFromNib];

    _exceptionView.delegate = self;

    _tableView.tableHeaderView = _exceptionView;

    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - MaintExceptionViewDelegate

- (void)onClickSubmit
{
    NSString *remark = _exceptionView.tvException.text;
    if (0 == remark.length)
    {
        [HUDClass showHUDWithLabel:@"请填写无法出发的理由"];
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"maintOrderProcessId"] = _taskInfo[@"id"];
    params[@"maintUserFeedback"] = remark;
    params[@"planTime"] = _exceptionView.lbPlan.text;

    [[HttpClient sharedClient] post:@"editMaintOrderProcessWorkerUnableFinish" parameter:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUDClass showHUDWithLabel:@"无法出发异常提交成功"];

        NSArray *array = self.navigationController.viewControllers;

        [self.navigationController popToViewController:array[array.count - 3] animated:YES];
    }];
}


@end
