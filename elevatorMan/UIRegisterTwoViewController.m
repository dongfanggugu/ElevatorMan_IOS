//
//  UIRegisterTwoViewController.m
//  elevatorMan
//
//  Created by 长浩 张 on 15/11/25.
//
//

#import <Foundation/Foundation.h>
#import "UIRegisterTwoViewController.h"
#import "UIRegisterThreeViewController.h"
#import "DownPicker.h"
#import "HttpClient.h"
#import "AppDelegate.h"
#import "Utils.h"

#define GB18030_ENCODING CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)


@interface UIRegisterTwoViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageViewBack;

@property (weak, nonatomic) IBOutlet UIView *viewTitle;

@property (strong, nonatomic) DownPicker *downPicker;

@property (weak, nonatomic) IBOutlet UITextField *tfName;

@property (weak, nonatomic) IBOutlet UITextField *tfAge;

@property (weak, nonatomic) IBOutlet UITextField *tfSex;

@property (weak, nonatomic) IBOutlet UILabel *labelCompany;

@property (weak, nonatomic) IBOutlet UITextField *tfCardId;

@property (weak, nonatomic) IBOutlet UITextField *tfOperationCard;

@property (weak, nonatomic) IBOutlet UITextField *tfPhoneNumber;

@property (weak, nonatomic) IBOutlet UIButton *btnNext;

@property (strong, nonatomic) NSMutableArray *companyList;

@property (strong, nonatomic) NSMutableArray *seachResultList;

@property (strong, nonatomic) NSString *strCurrentCompanyId;



- (IBAction)pressedConfirm:(id)sender;

- (IBAction)didEndOnExit:(id)sender;

@end

@implementation UIRegisterTwoViewController


- (void)viewDidLoad
{

    [super viewDidLoad];
    [self setNavTitle:@"维修工注册"];

    //设置按钮风格
    _btnNext.layer.masksToBounds = YES;
    _btnNext.layer.cornerRadius = 5;

    //性别选择下拉框
    NSMutableArray *sexArray = [[NSMutableArray alloc] init];
    [sexArray addObject:@"男"];
    [sexArray addObject:@"女"];
    self.downPicker = [[DownPicker alloc] initWithTextField:self.tfSex withData:sexArray];
    [self.downPicker setToolbarDoneButtonText:@"确认"];
    [self.downPicker setToolbarCancelButtonText:@"取消"];

    //维保公司设置提示内容，颜色和UITextField的placeholder相同
    UIColor *placeHolderColor = [self.tfName valueForKeyPath:@"_placeholderLabel.textColor"];
    self.labelCompany.textColor = placeHolderColor;

    //维保公司选择
    self.labelCompany.userInteractionEnabled = YES;
    UIGestureRecognizer *companySelector = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(getCompanyList)];
    [self.labelCompany addGestureRecognizer:companySelector];
    self.seachResultList = [[NSMutableArray alloc] init];


}


/**点击后退按钮**/
- (void)pressedBack
{

    [self dismissViewControllerAnimated:YES completion:nil];
}

/** 下一步 **/
- (IBAction)pressedConfirm:(id)sender
{

    if (0 == self.tfName.text.length)
    {
        [self showToastWith:@"姓名不能为空!"];
        return;
    }

    if (0 == self.tfAge.text.length)
    {
        [self showToastWith:@"年龄不能为空!"];
        return;
    }

    if (![self isLegalAge:self.tfAge.text])
    {
        [self showToastWith:@"请输入正确的年龄!"];
        return;
    }

    if (0 == self.labelCompany.text.length)
    {
        [self showToastWith:@"公司名称不能为空!"];
        return;
    }

    if ([self.labelCompany.text isEqualToString:@"点击选择维保公司"])
    {
        [self showToastWith:@"公司名称不能为空!"];
        return;
    }

    if (0 == self.tfCardId.text.length)
    {
        [self showToastWith:@"身份证号码不能为空!"];
        return;
    }

    if ([self legalOfCard:self.tfCardId.text].length != 0)
    {
        [self showToastWith:@"请输入合法的身份证号码!"];
        return;
    }

    if (0 == self.tfOperationCard.text.length)
    {
        [self showToastWith:@"操作证号不能为空!"];
        return;
    }

    if (0 == self.tfPhoneNumber.text.length)
    {
        [self showToastWith:@"手机号码不能为空!"];
        return;
    }

    if (![self isCorrectPhoneNumberOf:self.tfPhoneNumber.text])
    {
        [self showToastWith:@"请输入正确的手机号码!"];
        return;
    }

    UIRegisterThreeViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"register_three"];
    controller.city = _city;
    controller.userName = _userName;
    controller.password = _password;
    controller.name = _tfName.text;
    controller.age = _tfAge.text;
    controller.sex = _tfSex.text;
    controller.branch = _labelCompany.text;
    controller.branchId = _strCurrentCompanyId;
    controller.cardId = _tfCardId.text;
    controller.operation = _tfOperationCard.text;
    controller.cellphone = _tfPhoneNumber.text;


    [self.navigationController pushViewController:controller animated:YES];
}




//处理键盘的点击事件
- (IBAction)didEndOnExitByPhone:(id)sender
{
    [self resignFirstResponder];
}

/**
 手机号码是否合法
 **/
- (BOOL)isCorrectPhoneNumberOf:(NSString *)phoneNumber
{

    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phoneNumber];
}

/** 检测年龄是否合法 **/
- (BOOL)isLegalAge:(NSString *)age
{
    NSString *ageRegex = @"^([1-9]\\d{0,1})$";
    NSPredicate *ageTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ageRegex];
    return [ageTest evaluateWithObject:age];
}

/**
 显示提示语
 **/
- (void)showToastWith:(NSString *)content
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = content;
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}


/** 验证身份证的合法性 **/
- (NSString *)legalOfCard:(NSString *)card
{
    NSString *errMsg = nil;

    //长度验证
    if (card.length != 15 && card.length != 18)
    {
        errMsg = @"身份证号码长度应该位15位或者18位";
        NSLog(@"errMsg:%@", errMsg);
        return errMsg;
    }
    NSString *sub = nil;
    //除最后一位都是数字
    if (18 == card.length)
    {
        sub = [card substringToIndex:17];
    }
    else if (15 == card.length)
    {
        sub = card;
    }
    if (![self isNumberic:sub])
    {
        errMsg = @"15位都应该为数字，18位时除最后一位，其他都应该为数字";
        NSLog(@"errMsg:%@", errMsg);
        return errMsg;
    }

    return errMsg;
}

/** 检测是否为数字 **/
- (BOOL)isNumberic:(NSString *)str
{
    NSString *numberRegex = @"[0-9]*";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    return [numberTest evaluateWithObject:str];
}

- (IBAction)didEndOnExit:(id)sender
{
    [self resignFirstResponder];
}

- (void)getCompanyList
{


    [[HttpClient sharedClient] view:self.view post:@"getBranchs" parameter:nil
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                self.companyList = [responseObject objectForKey:@"body"];

                                [self.seachResultList removeAllObjects];

                                for (NSObject *o in self.companyList)
                                {
                                    [self.seachResultList addObject:o];
                                }

                                self.seachResultList = [[self.seachResultList sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
                                    NSString *str1 = [[obj1 objectForKey:@"name"] stringByAddingPercentEscapesUsingEncoding:GB18030_ENCODING];
                                    NSString *str2 = [[obj2 objectForKey:@"name"] stringByAddingPercentEscapesUsingEncoding:GB18030_ENCODING];
                                    return [str1 compare:str2];
                                }] mutableCopy];

                                NSMutableDictionary *other = [[NSMutableDictionary alloc] init];
                                [other setObject:@"其他" forKey:@"name"];
                                [other setObject:@"" forKey:@"id"];

                                [self.seachResultList addObject:other];

                                [self showCompanies];
                            }];

}

#pragma mark - Company List Dialog

/**
 *  显示维保公司选择框
 */
- (void)showCompanies
{

    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;

    UIView *companyListAlertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    companyListAlertView.tag = 1001;
    [companyListAlertView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:companyListAlertView];

    CGFloat parentViewWidth = screenWidth - 60;
    CGFloat parentViewHeight = screenHeight - 160;


    UIView *parentView = [[UIView alloc] initWithFrame:CGRectMake(30, 70, parentViewWidth, parentViewHeight)];


    //设置阴影
    parentView.layer.shadowColor = [UIColor blackColor].CGColor;
    parentView.layer.shadowOffset = CGSizeMake(4, 4);
    parentView.layer.shadowOpacity = 0.6;
    parentView.layer.shadowRadius = 4;

    [parentView setBackgroundColor:[UIColor whiteColor]];
    [companyListAlertView addSubview:parentView];

    //alert title
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, parentViewWidth, 55)];
    labelTitle.text = @"维保公司选择";
    [labelTitle setBackgroundColor:[Utils getColorByRGB:@"#25b6ed"]];
    [labelTitle setTextColor:[UIColor whiteColor]];
    labelTitle.textAlignment = NSTextAlignmentCenter;
    [parentView addSubview:labelTitle];



    //searchView
    UITextField *tfSearch = [[UITextField alloc] initWithFrame:CGRectMake(20, 60, parentViewWidth - 20 * 2, 30)];
    [tfSearch setPlaceholder:@"请输入维保公司名称"];
    tfSearch.font = [UIFont systemFontOfSize:13];
    [parentView addSubview:tfSearch];

    [tfSearch addTarget:self action:@selector(textFieldAfterChanged:) forControlEvents:UIControlEventEditingChanged];


    //UITableView
    UITableView *companyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 90,
            parentViewWidth, parentViewHeight - 150)     style:UITableViewStyleGrouped];
    companyTableView.tag = 1004;

    [companyTableView setBackgroundColor:[UIColor whiteColor]];

    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, -1)];
    companyTableView.tableHeaderView = header;

    companyTableView.dataSource = self;
    companyTableView.delegate = self;

    [parentView addSubview:companyTableView];

    //取消按钮
    UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(0,
            parentViewHeight - 50, parentViewWidth, 50)];
    [btnCancel setBackgroundColor:[Utils getColorByRGB:@"#f1f1f1"]];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    btnCancel.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];

    [btnCancel addTarget:self action:@selector(companyDialogCancel) forControlEvents:UIControlEventTouchUpInside];
    [parentView addSubview:btnCancel];
}


/**
 *  取消按钮
 */
- (void)companyDialogCancel
{
    UIView *alertView = [self.view viewWithTag:1001];
    if (alertView != nil)
    {
        [alertView removeFromSuperview];
    }
}

#pragma mark - Custom Company Dialog

/**
 *  显示维保公司输入弹出框
 */
- (void)customCompany
{

    UIView *companyCustomAlertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
    companyCustomAlertView.tag = 1002;
    [companyCustomAlertView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:companyCustomAlertView];

    CGFloat parentViewWidth = self.screenWidth - 60;
    CGFloat parentViewHeight = 200;


    UIView *parentView = [[UIView alloc] initWithFrame:CGRectMake(30, (self.screenHeight - 200) / 2 - 50, parentViewWidth, parentViewHeight)];


    parentView.layer.shadowColor = [UIColor blackColor].CGColor;
    parentView.layer.shadowOffset = CGSizeMake(4, 4);
    parentView.layer.shadowOpacity = 0.6;
    parentView.layer.shadowRadius = 4;

    [parentView setBackgroundColor:[UIColor whiteColor]];
    [companyCustomAlertView addSubview:parentView];

    //alert title
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, parentViewWidth, 60)];
    labelTitle.text = @"维保公司";
    [labelTitle setBackgroundColor:[Utils getColorByRGB:@"#25b6ed"]];
    [labelTitle setTextColor:[UIColor whiteColor]];
    labelTitle.textAlignment = NSTextAlignmentCenter;
    [parentView addSubview:labelTitle];

    //searchView
    UITextField *tfCompany = [[UITextField alloc] initWithFrame:CGRectMake(20, 70, parentViewWidth - 20 * 2, 60)];
    tfCompany.font = [UIFont systemFontOfSize:13];
    tfCompany.tag = 1003;
    [tfCompany setPlaceholder:@"请输入维保公司名称"];
    [parentView addSubview:tfCompany];

    //取消按钮
    UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(0,
            140, parentViewWidth / 2 - 0.5, 60)];
    [btnCancel setBackgroundColor:[Utils getColorByRGB:@"#f1f1f1"]];
    btnCancel.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [btnCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [btnCancel addTarget:self action:@selector(customDialogCancel) forControlEvents:UIControlEventTouchUpInside];
    [parentView addSubview:btnCancel];

    //确认按钮
    UIButton *btnConfirm = [[UIButton alloc] initWithFrame:CGRectMake(parentViewWidth / 2,
            140, parentViewWidth / 2 + 0.5, 60)];
    [btnConfirm setBackgroundColor:[Utils getColorByRGB:@"#f1f1f1"]];
    [btnConfirm setTitle:@"确认" forState:UIControlStateNormal];
    btnConfirm.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnConfirm setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];

    [btnConfirm addTarget:self action:@selector(customDialogConfirm) forControlEvents:UIControlEventTouchUpInside];
    [parentView addSubview:btnConfirm];
}


/**
 *  取消按钮
 */
- (void)customDialogCancel
{
    UIView *alertView = [self.view viewWithTag:1002];
    if (alertView != nil)
    {
        [alertView removeFromSuperview];
    }
}

/**
 *  确认按钮
 */
- (void)customDialogConfirm
{
    UITextField *textField = (UITextField *) [self.view viewWithTag:1003];
    NSString *content = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if (0 == content.length)
    {
        [HUDClass showHUDWithLabel:@"维保公司不能为空!" view:self.view];
        return;
    }
    self.strCurrentCompanyId = @"";
    self.labelCompany.text = content;
    self.labelCompany.textColor = self.tfName.textColor;
    [self customDialogCancel];
}


#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.seachResultList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellIdentifier = @"CompanyCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        UILabel *labelComName = [[UILabel alloc] init];
        labelComName.tag = 1;
        [labelComName setFrame:CGRectMake(20, 5, [UIScreen mainScreen].bounds.size.width - 60, 40)];
        labelComName.font = [UIFont systemFontOfSize:13];
        [[cell contentView] addSubview:labelComName];
    }

    UILabel *labelCom = (UILabel *) [cell viewWithTag:1];
    [labelCom setText:[self.seachResultList[indexPath.row] objectForKey:@"name"]];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *content = [self.seachResultList[indexPath.row] objectForKey:@"name"];

    if ([content isEqualToString:@"其他"])
    {
        [self companyDialogCancel];
        [self customCompany];

    }
    else
    {
        self.strCurrentCompanyId = [self.seachResultList[indexPath.row] objectForKey:@"id"];
        self.labelCompany.text = content;
        self.labelCompany.textColor = self.tfName.textColor;
        [self companyDialogCancel];
    }
}


- (void)textFieldAfterChanged:(UITextField *)textField
{
    [self.seachResultList removeAllObjects];

    NSString *content = [textField.text stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if (0 == content.length)
    {
        for (NSObject *o in self.companyList)
        {
            [self.seachResultList addObject:o];
        }

    }
    else
    {

        for (int i = 0;
                i < self.companyList.count;
                i++)
        {
            if ([(NSString *) [self.companyList[i] objectForKey:@"name"] containsString:content])
            {
                [self.seachResultList addObject:self.companyList[i]];
            }
        }
    }

    //按照字母表排序
    self.seachResultList = [[self.seachResultList sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
        NSString *str1 = [[obj1 objectForKey:@"name"] stringByAddingPercentEscapesUsingEncoding:GB18030_ENCODING];
        NSString *str2 = [[obj2 objectForKey:@"name"] stringByAddingPercentEscapesUsingEncoding:GB18030_ENCODING];
        return [str1 compare:str2];
    }] mutableCopy];

    NSMutableDictionary *other = [[NSMutableDictionary alloc] init];
    [other setObject:@"其他" forKey:@"name"];
    [other setObject:@"" forKey:@"id"];

    [self.seachResultList addObject:other];


    [(UITableView *) [self.view viewWithTag:1004] reloadData];

}

@end
