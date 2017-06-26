//
// Created by changhaozhang on 2017/6/23.
//

#import "EnterManagerRegisterController.h"
#import "KeyEditCell.h"

@interface EnterManagerRegisterController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (weak, nonatomic) KeyEditCell *telCell;

@property (weak, nonatomic) KeyEditCell *nameCell;

@property (weak, nonatomic) KeyEditCell *comCell;

@property (weak, nonatomic) KeyEditCell *pwdCell;

@property (weak, nonatomic) KeyEditCell *confirmCell;

@end

@implementation EnterManagerRegisterController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"维保公司注册"];
    [self initView];
}


/**
 *  初始化视图
 */
- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth,self.screenHeight - 64)];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, 100)];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 180, 36)];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    btn.backgroundColor = RGB(TITLE_COLOR);
    
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 5;
    [btn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    
    btn.center = CGPointMake(self.screenWidth / 2, 50);
    [footerView addSubview:btn];
    _tableView.tableFooterView = footerView;
    
}

- (void)submit
{
    NSString *tel = _telCell.tfValue.text;
    
    if (0 == tel.length)
    {
        [self showMsgAlert:@"请输入您的手机号码"];
        return;
    }
    
    if (![Utils isCorrectPhoneNumberOf:tel])
    {
        [self showMsgAlert:@"请输入正确的手机号码"];
        return;
    }
    
    NSString *name = _nameCell.tfValue.text;
    
    if (0 == name.length)
    {
        [self showMsgAlert:@"请输入您的姓名"];
        return;
    }
    
    NSString *company = _comCell.tfValue.text;
    
    if (0 == company.length)
    {
        [self showMsgAlert:@"请输入您的公司名称"];
        return;
    }
    
    NSString *pwd = _pwdCell.tfValue.text;
    
    if (pwd.length < 6)
    {
        [self showMsgAlert:@"请正确输入您的密码,至少需要6位"];
        return;
    }
    
    NSString *confirm = _confirmCell.tfValue.text;
    
    if (![confirm isEqualToString:pwd])
    {
        [self showMsgAlert:@"您的确认密码和密码输入不一致,请重新输入确认密码"];
        return;
    }
    
   
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"companyName"] = company;
    
    params[@"tel"] = tel;
    
    params[@"name"] = name;
    
    params[@"password"] = [Utils md5:pwd];
    
    [[HttpClient sharedClient] post:@"registerMaintUser" parameter:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *msg = [NSString stringWithFormat:@"注册成功,您可以通过您的手机号%@和您的密码进行登录", tel];
        [self showMsgAlert:msg userInfo:nil];
    }];
        
}

- (void)onMsgAlertDismiss:(BaseAlertController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KeyEditCell *cell = [tableView dequeueReusableCellWithIdentifier:[KeyEditCell identifier]];
    
    if (!cell)
    {
        cell = [KeyEditCell cellFromNib];
    }
    
    switch (indexPath.row)
    {
        case 0:
            _telCell = cell;
            cell.lbKey.text = @"手机";
            cell.tfValue.placeholder = @"输入您的手机号码";
            cell.tfValue.keyboardType = UIKeyboardTypePhonePad;
            break;
            
        case 1:
            _nameCell = cell;
            cell.lbKey.text = @"姓名";
            cell.tfValue.placeholder = @"请输入您的姓名";
            break;
            
        case 2:
            _comCell = cell;
            cell.lbKey.text = @"公司名称";
            cell.tfValue.placeholder = @"请输入您的公司名称";
            break;
            
        case 3:
            _pwdCell = cell;
            cell.lbKey.text = @"密码";
            cell.tfValue.placeholder = @"请输入你的密码(至少6位)";
            cell.tfValue.secureTextEntry = YES;
            break;
            
        case 4:
            _confirmCell = cell;
            cell.lbKey.text = @"确认密码";
            cell.tfValue.placeholder = @"重复您的密码";
            cell.tfValue.secureTextEntry = YES;
            break;
            
            
        default:
            break;
    }
    
    return cell;
}


@end
