//
//  UIRegisterOneViewControllor.m
//  elevatorMan
//
//  Created by 长浩 张 on 15/11/24.
//
//

#import <Foundation/Foundation.h>
#import "UIRegisterOneViewController.h"
#import "UIRegisterTwoViewController.h"
#import "HttpClient.h"
#import "AppDelegate.h"
#import "Utils.h"

#define PROVINCE 1002
#define CITY 1003

@interface UIRegisterOneViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *title_view;

@property (weak, nonatomic) IBOutlet UIImageView *imageview_back;

@property (weak, nonatomic) IBOutlet UILabel *labelCity;

@property (weak, nonatomic) IBOutlet UITextField *tfUserName;

@property (weak, nonatomic) IBOutlet UITextField *tfPassword;

@property (weak, nonatomic) IBOutlet UITextField *tfConfirm;

@property (weak, nonatomic) IBOutlet UIButton *btnNext;

@property (strong, nonatomic) NSArray *arrayProvince;

@property (strong, nonatomic) NSMutableArray *arraySearchResult;

@property (strong, nonatomic) NSArray *arrayCity;

@property (weak, nonatomic) IBOutlet UILabel *labelInner;

@property NSInteger intCurrentTableViewTag;

- (IBAction)pressNextBtn:(id)sender;

- (IBAction)didEndOnExitByUserName:(id)sender;

- (IBAction)didEndOnExitByPassword:(id)sender;

- (IBAction)didEndOnExitByConfirm:(id)sender;

- (IBAction)didEndOnExit:(id)sender;

@end

@implementation UIRegisterOneViewController

@synthesize labelInner;

@synthesize labelCity;

@synthesize arrayProvince;

@synthesize arraySearchResult;

@synthesize intCurrentTableViewTag;

@synthesize arrayCity;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"维修工注册"];


    //设置UILabel字体颜色，和UITextField的placeholder颜色相同
    UIColor *placeHolderColor = [self.tfUserName valueForKeyPath:@"_placeholderLabel.textColor"];
    [labelCity setTextColor:placeHolderColor];


    arraySearchResult = [[NSMutableArray alloc] init];

    NSString *urlTextString = [[NSUserDefaults standardUserDefaults] objectForKey:@"urlString"];
    if ([urlTextString isEqualToString:@"北京"]) {
        labelCity.text = @"北京";
        [labelCity setTextColor:[UIColor blackColor]];
    } else {
        labelCity.userInteractionEnabled = YES;
        UIGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(getCityInfoFromFile)];
        [labelCity addGestureRecognizer:recognizer];

        labelInner.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(popInnerServer:)];
        longPressRecognizer.minimumPressDuration = 5;
        [labelInner addGestureRecognizer:longPressRecognizer];

    }

}

- (void)popInnerServer:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"服务器选择" message:nil delegate:self
                                                  cancelButtonTitle:@"取消" otherButtonTitles:@"演示", @"马晓明", @"Azure", nil];
        [alertView show];
    }
}

/** 通过segue传递值 **/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *city = self.labelCity.text;
    NSString *userName = self.tfUserName.text;
    NSString *password = self.tfPassword.text;
    UIViewController *send = segue.destinationViewController;

    [send setValue:userName forKey:@"userName"];

    [send setValue:password forKey:@"password"];

    [send setValue:city forKey:@"city"];
}


/**
 点击下一步，先检测用户名是否存在
 **/
- (IBAction)pressNextBtn:(id)sender {

    NSString *city = labelCity.text;
    if (0 == city.length) {
        [HUDClass showHUDWithLabel:@"城市不能为空!" view:self.view];
        return;
    }

    if ([city isEqualToString:@"点击选择城市"]) {
        [HUDClass showHUDWithLabel:@"请选择城市!" view:self.view];
        return;
    }

    NSString *userName = self.tfUserName.text;
    //检测用户名不为空
    if (0 == userName.length) {
        [HUDClass showHUDWithLabel:@"用户名不能为空!" view:self.view];
        return;
    }

    NSString *password = self.tfPassword.text;
    if (0 == password.length) {
        [HUDClass showHUDWithLabel:@"密码输入不能为空!" view:self.view];
        return;
    }
    if (password.length < 6) {
        [HUDClass showHUDWithLabel:@"密码至少为6位，请重新输入!" view:self.view];
        return;
    }

    NSString *confirm = self.tfConfirm.text;
    if (0 == confirm.length) {
        [HUDClass showHUDWithLabel:@"确认密码不能为空" view:self.view];
        return;
    }

    //判断密码和确认密码是否一致
    if (![password isEqualToString:confirm]) {
        [HUDClass showHUDWithLabel:@"密码和确认密码不一致，请重新输入!" view:self.view];
        return;
    }

    //提交到服务器，检测用户名是否已经存在
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    [params setObject:userName forKey:@"loginname"];
    [params setObject:password forKey:@"password"];
    [params setObject:@"0" forKey:@"operateState"];


    [[HttpClient sharedClient] resetUrl];
    [[HttpClient sharedClient] view:self.view post:@"registerRepair" parameter:params success:^(AFHTTPRequestOperation *operation, id responseObject) {

        UIRegisterTwoViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"register_two"];
        controller.city = city;
        controller.password = password;
        controller.userName = userName;

        [self.navigationController pushViewController:controller animated:YES];
    }];
}

/**
 点击软键盘的完成按钮 **/
- (IBAction)didEndOnExitByUserName:(id)sender {
    [self.tfPassword becomeFirstResponder];
}

- (IBAction)didEndOnExitByPassword:(id)sender {
    [self.tfConfirm becomeFirstResponder];
}

- (IBAction)didEndOnExitByConfirm:(id)sender {
    [self resignFirstResponder];
}

- (IBAction)didEndOnExit:(id)sender {
    [self resignFirstResponder];
}

- (void)dealloc {
    NSLog(@"deal loc 1");
}

/**
 *  从文件中获取城市信息
 */
- (void)getCityInfoFromFile {

    NSError *error;
    NSString *cityJsonString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city_json" ofType:@"json"] encoding:NSUTF8StringEncoding error:&error];

    //字符串转换为dictionary对象
    NSData *jsonData = [cityJsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *jsonError;

    NSDictionary *zoneDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError];

    arrayProvince = [zoneDic objectForKey:@"provinceList"];
    NSLog(@"length:%ld", arrayProvince.count);

    [arraySearchResult removeAllObjects];
    for (NSObject *o in arrayProvince) {
        [arraySearchResult addObject:o];
    }

    //按照拼音排序
    arraySearchResult = [[arraySearchResult sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj1 objectForKey:@"pronamepinyin"] compare:[obj2 objectForKey:@"pronamepinyin"]];
    }] mutableCopy];

    [self showAlertTableViewWithTitle:@"省份选择" type:PROVINCE];
}

/**
 *  显示城市的选择弹出框
 *
 *  @param title <#title description#>
 *  @param type  <#type description#>
 */
- (void)showAlertTableViewWithTitle:(NSString *)title type:(NSInteger)type {

    intCurrentTableViewTag = type;

    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;

    UIView *companyListAlertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    companyListAlertView.tag = 1001;
    [companyListAlertView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:companyListAlertView];

    CGFloat parentViewWidth = screenWidth - 60;
    CGFloat parentViewHeight = screenHeight - 160;


    UIView *parentView = [[UIView alloc] initWithFrame:CGRectMake(30, 70, parentViewWidth, parentViewHeight)];


    //parentView.layer.borderWidth = 3;
    //parentView.layer.borderColor = [[UIColor blueColor] CGColor];

    //设置阴影
    parentView.layer.shadowColor = [UIColor blackColor].CGColor;
    parentView.layer.shadowOffset = CGSizeMake(4, 4);
    parentView.layer.shadowOpacity = 0.6;
    parentView.layer.shadowRadius = 4;


    [parentView setBackgroundColor:[UIColor whiteColor]];
    [companyListAlertView addSubview:parentView];



    //alert title
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, parentViewWidth, 55)];
    labelTitle.text = title;
    [labelTitle setBackgroundColor:[Utils getColorByRGB:@"#25b6ed"]];
    [labelTitle setTextColor:[UIColor whiteColor]];
    labelTitle.textAlignment = NSTextAlignmentCenter;
    [parentView addSubview:labelTitle];


    //searchView
    UITextField *tfSearch = [[UITextField alloc] initWithFrame:CGRectMake(0, 60, parentViewWidth, 30)];
    [tfSearch setBackgroundColor:[Utils getColorByRGB:@"#f1f1f1"]];

    UIView *padView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
    [padView setBackgroundColor:[UIColor clearColor]];

    tfSearch.leftView = padView;
    tfSearch.rightView = padView;
    tfSearch.leftViewMode = UITextFieldViewModeAlways;
    tfSearch.rightViewMode = UITextFieldViewModeAlways;

    NSString *placeHolder = @"请输入省份名称";
    if (CITY == type) {
        placeHolder = @"请输入城市名称";
    }
    [tfSearch setPlaceholder:placeHolder];
    [parentView addSubview:tfSearch];

    [tfSearch addTarget:self action:@selector(textFieldAfterChanged:) forControlEvents:UIControlEventEditingChanged];



    //UITableView
    UITableView *tableView = [[UITableView alloc]    initWithFrame:CGRectMake(0, 93,
            parentViewWidth, parentViewHeight - 150) style:UITableViewStyleGrouped];
    //设置tableView的tag，用来标记当前是省份选择还是城市选择
    tableView.tag = type;

    [tableView setBackgroundColor:[UIColor whiteColor]];
    //tableView.layer.borderWidth = 1;
    //tableView.layer.borderColor = [[UIColor blueColor] CGColor];

    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, -1)];
    tableView.tableHeaderView = header;

    tableView.dataSource = self;
    tableView.delegate = self;

    [parentView addSubview:tableView];




    //取消按钮
    UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(0,
            parentViewHeight - 50, parentViewWidth, 50)];
    [btnCancel setBackgroundColor:[UIColor greenColor]];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];

    [btnCancel setBackgroundColor:[Utils getColorByRGB:@"#f1f1f1"]];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [btnCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];

    [btnCancel addTarget:self action:@selector(cityDialogCancel) forControlEvents:UIControlEventTouchUpInside];
    [parentView addSubview:btnCancel];
}


/**
 *  关闭城市选择弹出框
 */
- (void)cityDialogCancel {

    UIView *alertView = [self.view viewWithTag:1001];
    if (alertView != nil) {
        intCurrentTableViewTag = 0;
        [alertView removeFromSuperview];
    }
}

/**
 *  搜索框监听方法
 *
 *  @param textField <#textField description#>
 */
- (void)textFieldAfterChanged:(UITextField *)textField {
    if (0 == intCurrentTableViewTag) {
        return;
    }
    [arraySearchResult removeAllObjects];

    NSString *content = [textField.text stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceAndNewlineCharacterSet]];

    switch (intCurrentTableViewTag) {
        case PROVINCE:
            if (0 == content.length) {
                for (NSObject *o in arrayProvince) {
                    [arraySearchResult addObject:o];
                }
            } else {
                for (int i = 0; i < arrayProvince.count; i++) {
                    if ([(NSString *) [arrayProvince[i] objectForKey:@"proname"] containsString:content]) {
                        [arraySearchResult addObject:arrayProvince[i]];
                    }
                }
            }

            //按照拼音排序
            arraySearchResult = [[arraySearchResult sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [[obj1 objectForKey:@"pronamepinyin"] compare:[obj2 objectForKey:@"pronamepinyin"]];
            }] mutableCopy];

            break;

        case CITY:
            if (0 == content.length) {
                for (NSObject *o in arrayCity) {
                    [arraySearchResult addObject:o];
                }
            } else {
                for (int i = 0; i < arrayCity.count; i++) {
                    if ([(NSString *) [arrayCity[i] objectForKey:@"cityname"] containsString:content]) {
                        [arraySearchResult addObject:arrayCity[i]];
                    }
                }
            }

            //按照拼音排序
            arraySearchResult = [[arraySearchResult sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [[obj1 objectForKey:@"citypinyin"] compare:[obj2 objectForKey:@"citypinyin"]];
            }] mutableCopy];

            break;

        default:
            break;
    }

    [(UITableView *) [self.view viewWithTag:intCurrentTableViewTag] reloadData];
}


#pragma mark -- UITableView Datasource Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arraySearchResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"CompanyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        UILabel *labelComName = [[UILabel alloc] init];
        labelComName.tag = 1;
        [labelComName setFrame:CGRectMake(20, 5, [UIScreen mainScreen].bounds.size.width - 60, 40)];
        [[cell contentView] addSubview:labelComName];
    }

    UILabel *labelCom = (UILabel *) [cell viewWithTag:1];

    if (tableView.tag == PROVINCE) {
        [labelCom setText:[arraySearchResult[indexPath.row] objectForKey:@"proname"]];
    } else if (tableView.tag == CITY) {
        [labelCom setText:[arraySearchResult[indexPath.row] objectForKey:@"cityname"]];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *content = ((UILabel *) [cell viewWithTag:1]).text;

    if (tableView.tag == PROVINCE) {
        arrayCity = [arraySearchResult[indexPath.row] objectForKey:@"citys"];
        [arraySearchResult removeAllObjects];

        for (NSObject *o in arrayCity) {
            [arraySearchResult addObject:o];
        }

        //按照拼音排序
        arraySearchResult = [[arraySearchResult sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [[obj1 objectForKey:@"citypinyin"] compare:[obj2 objectForKey:@"citypinyin"]];
        }] mutableCopy];

        [self cityDialogCancel];
        [self showAlertTableViewWithTitle:content type:CITY];
    } else if (tableView.tag == CITY) {

        [self cityDialogCancel];
        labelCity.text = content;

        //设置UILabel字体颜色，和UITextField颜色相同
        [labelCity setTextColor:self.tfUserName.textColor];

        //设置服务器地址
        [[NSUserDefaults standardUserDefaults] setObject:content forKey:@"urlString"];

        [[HttpClient sharedClient] resetUrl];
    }
}

#pragma mark -- UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (0 == buttonIndex) {
        return;
    }

    NSString *content = [alertView buttonTitleAtIndex:buttonIndex];
    [[NSUserDefaults standardUserDefaults] setObject:content forKey:@"urlString"];
    [[HttpClient sharedClient] resetUrl];
    self.labelCity.text = content;
}

@end
