//
//  SignInViewController.m
//  elevatorMan
//
//  Created by Cove on 15/3/27.
//
//

#import "SignInViewController.h"
#import "HttpClient.h"
#import "AppDelegate.h"
#import "APService.h"
#import "DownPicker.h"
#import "Utils.h"


#import <CommonCrypto/CommonDigest.h>
#import <KeyboardManager.h>
#import "FileUtils.h"
#import "GuideViewController.h"
#import "PaintViewController.h"

#define PROVINCE 1002
#define CITY 1003

#define GB18030_ENCODING CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)

//重写button的背景颜色方法
@implementation UIButton (FillColor)

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state
{
    [self setBackgroundImage:[UIButton imageWithColor:backgroundColor] forState:state];
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

@end


@interface SignInViewController () <UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    IQKeyboardReturnKeyHandler *returnKeyHandler;
}

//- (IBAction)selectButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *textField_userName;

@property (weak, nonatomic) IBOutlet UITextField *textField_userPWD;

@property (weak, nonatomic) IBOutlet UIButton *button_login;

@property (weak, nonatomic) IBOutlet UIView *view_username;

@property (weak, nonatomic) IBOutlet UIView *view_password;

@property (weak, nonatomic) IBOutlet UILabel *labelCity;

@property (weak, nonatomic) IBOutlet UIButton *btnReset;

@property (weak, nonatomic) IBOutlet UIImageView *ivLogo;

@property (weak, nonatomic) IBOutlet UILabel *labelVersion;

@property (strong, nonatomic) NSArray *arrayProvince;

@property (strong, nonatomic) NSMutableArray *arraySearchResult;

@property (strong, nonatomic) NSArray *arrayCity;

@property (weak, nonatomic) NSArray *test;

@property NSInteger intCurrentTableViewTag;

@property (strong, nonatomic) MBProgressHUD *jpushHUD;

@property NSInteger jpushCount;

@property (weak, nonatomic) IBOutlet UIButton *btnRegister;

@end


@implementation SignInViewController

@synthesize arrayProvince;

@synthesize arraySearchResult;

@synthesize intCurrentTableViewTag;

@synthesize arrayCity;

@synthesize labelCity;

- (void)dealloc
{
    returnKeyHandler = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.navigationController.navigationBar.hidden = YES;

    NSString *userName = [User sharedUser].userName;
    if (userName.length > 0)
    {
        _textField_userName.text = userName;
    }

    [self portrait];

}

- (void)portrait
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
    {

        SEL selector = NSSelectorFromString(@"setOrientation:");

        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];

        [invocation setSelector:selector];

        [invocation setTarget:[UIDevice currentDevice]];

        int val = UIInterfaceOrientationPortrait;

        [invocation setArgument:&val atIndex:2];

        [invocation invoke];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _jpushCount = 0;

    //设置当前版本号
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.labelVersion.text = version;


    //设置地区
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"urlString"])
    {
        self.labelCity.text = @"北京";
        [[NSUserDefaults standardUserDefaults] setObject:@"北京" forKey:@"urlString"];

    }
    else
    {
        self.labelCity.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"urlString"];
    }

    //使用微软云，不再选择服务器
//    self.labelCity.userInteractionEnabled = YES;
//    UIGestureRecognizer *cityRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                                  action:@selector(getCityInfoFromFile)];
//    [self.labelCity addGestureRecognizer:cityRecognizer];
//    


    //设置输入框边框
    self.view_username.layer.borderWidth = 1;
    self.view_username.layer.borderColor = [[UIColor whiteColor] CGColor];

    self.view_password.layer.borderWidth = 1;
    self.view_password.layer.borderColor = [[UIColor whiteColor] CGColor];


    //设置登录按钮的背景颜色效果
    [self.button_login setBackgroundColor:UIColorFromRGB(0xfff3c434) forState:UIControlStateNormal];
    [self.button_login setBackgroundColor:UIColorFromRGB(0xffe9b516) forState:UIControlStateHighlighted];

    //textfield tint color
    self.textField_userName.tintColor = [UIColor whiteColor];
    self.textField_userPWD.tintColor = [UIColor whiteColor];

    self.textField_userPWD.delegate = self;

    self.textField_userName.delegate = self;

    //内部服务器
    self.ivLogo.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(popInnerServer:)];
    recognizer.minimumPressDuration = 5;
    [self.ivLogo addGestureRecognizer:recognizer];

    arraySearchResult = [[NSMutableArray alloc] init];

    //忘记密码
    [self.btnReset addTarget:self action:@selector(resetPassword) forControlEvents:UIControlEventTouchUpInside];

    [_btnRegister addTarget:self action:@selector(userRegister) forControlEvents:UIControlEventTouchUpInside];
}

- (void)userRegister
{
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"用户注册" message:nil delegate:self
//                                          cancelButtonTitle:@"取消" otherButtonTitles:@"维修工", @"物业人员", nil];
//    
//     alertView.tag = 10001;
//    [alertView show];

    PaintViewController *controller = [[PaintViewController alloc] init];

    [self.navigationController pushViewController:controller animated:YES];
}

- (void)workerRegister
{
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"register_one"];
    controller.navigationController.navigationBar.hidden = NO;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)proRegister
{
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"pro_register"];
    controller.navigationController.navigationBar.hidden = NO;
    [self.navigationController pushViewController:controller animated:YES];
}


/**
 *  长按logo显示内部服务器的选择
 *
 *  @param recognizer
 */
- (void)popInnerServer:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"服务器选择" message:nil delegate:self
                                                  cancelButtonTitle:@"取消" otherButtonTitles:@"北京", @"全国", @"上海", @"马晓明", @"张明锁", @"Azure", nil];

        [alertView show];

        //[self getCityInfoFromFile];
    }
}

//MD5加密
- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
    ];
}

//点击登录按钮
- (IBAction)onLogin:(id)sender
{

    //判断用户名和密码不能为空
    if ([[self.textField_userName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] ||
            [[self.textField_userPWD.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
    {
        [HUDClass showHUDWithLabel:@"用户名或密码不能为空" view:self.view];
        return;
    }


    __weak SignInViewController *weakSelf = self;


    //设置参数
    NSMutableDictionary *paras = [NSMutableDictionary dictionaryWithCapacity:1];
    [paras setObject:self.textField_userName.text forKey:@"userName"];
    [paras setObject:[self md5:self.textField_userPWD.text] forKey:@"password"];


    //请求服务器
    [[HttpClient sharedClient] view:self.view post:LOGIN_URL parameter:paras
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogged"];

                                NSDictionary *loginInfo = [responseObject objectForKey:@"body"];


                                [User sharedUser].userName = self.textField_userName.text;
                                [User sharedUser].userType = [loginInfo objectForKey:@"type"];
                                [User sharedUser].userId = [loginInfo objectForKey:@"userId"];
                                [User sharedUser].accessToken = [[responseObject objectForKey:@"head"] objectForKey:@"accessToken"];

                                [User sharedUser].name = [loginInfo objectForKey:@"name"];
                                [User sharedUser].age = [loginInfo objectForKey:@"age"];
                                [User sharedUser].operation = [loginInfo objectForKey:@"operationCard"];
                                [User sharedUser].sex = [loginInfo objectForKey:@"sex"];
                                [User sharedUser].tel = [loginInfo objectForKey:@"tel"];
                                [User sharedUser].branch = [loginInfo objectForKey:@"branchName"];
                                [User sharedUser].branchId = [loginInfo objectForKey:@"branchId"];
                                [User sharedUser].picUrl = [loginInfo objectForKey:@"pic"];
                                [User sharedUser].signUrl = [loginInfo objectForKey:@"autograph"];


                                NSDictionary *userAttach = [loginInfo objectForKey:@"userAttach"];
                                [User sharedUser].homeProvince = [userAttach objectForKey:@"familyProvince"];
                                [User sharedUser].homeCity = [userAttach objectForKey:@"familyCity"];
                                [User sharedUser].homeZone = [userAttach objectForKey:@"familyCounty"];
                                [User sharedUser].homeAddress = [userAttach objectForKey:@"familyAddress"];

                                [User sharedUser].workProvince = [userAttach objectForKey:@"residentProvince"];
                                [User sharedUser].workCity = [userAttach objectForKey:@"residentCity"];
                                [User sharedUser].workZone = [userAttach objectForKey:@"residentCounty"];
                                [User sharedUser].workAddress = [userAttach objectForKey:@"residentAddress"];

                                [[User sharedUser] setUserInfo];

                                //注册alias
                                NSString *alias = [[User sharedUser].accessToken stringByReplacingOccurrencesOfString:@"-" withString:@"_"];

                                [APService setAlias:alias callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:weakSelf];

                                [self showUserInterFace:[User sharedUser].userType];

                            }];
}

/**
 *  JPush回调方法
 *
 *  @param iResCode
 *  @param tags
 *  @param alias
 */
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet *)tags alias:(NSString *)alias
{
    NSLog(@"zhenhao---rescode: %d, tags: %@, alias: %@", iResCode, tags, alias);

    if (0 == iResCode)
    {
        NSLog(@"zhenhao:jpush register successfully!");
    }
    else
    {
        NSString *err = [NSString stringWithFormat:@"%d:注册消息服务器失败，请重新再试", iResCode];
        NSLog(@"zhenhao:%@", err);

        if (_jpushCount < 5)
        {
            _jpushCount++;
            [APService setAlias:alias callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];

        }
        else
        {
//            [HUDClass showHUDWithLabel:@"消息推送服务注册失败，请重新登录!" view:self.view];
//            [self logoutBackTosignIn];
        }
    }

}


- (void)logoutBackTosignIn
{

    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogged"];

    [[User sharedUser] clearUserInfo];

    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    [UIApplication sharedApplication].delegate.window.rootViewController = [storyBoard instantiateViewControllerWithIdentifier:@"signviewcontroller"];
}


/**
 *  根据角色跳转到对应的页面
 *
 *  @param type
 */
- (void)showUserInterFace:(NSString *)type
{
    if ([[User sharedUser].userType isEqualToString:UserTypeAdmin])//物业
    {
//        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Property" bundle:nil];
//        
//        [UIApplication sharedApplication].delegate.window.rootViewController = [story  instantiateViewControllerWithIdentifier:@"propertyRootViewController"];


        UIStoryboard *story = [UIStoryboard storyboardWithName:@"MyProperty" bundle:nil];

        [UIApplication sharedApplication].delegate.window.rootViewController =
                [story instantiateViewControllerWithIdentifier:@"property_main_page"];
    }
    else if ([[User sharedUser].userType isEqualToString:UserTypeWorker])//维修工
    {

        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

        [UIApplication sharedApplication].delegate.window.rootViewController = [story instantiateViewControllerWithIdentifier:@"main_page"];

    }

}


#pragma mark -- UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (0 == buttonIndex)
    {
        return;
    }

    if (10001 == alertView.tag)
    {
        if (1 == buttonIndex)
        {
            [self workerRegister];
        }
        else if (2 == buttonIndex)
        {
            [self proRegister];
        }
    }
    else
    {
        NSString *content = [alertView buttonTitleAtIndex:buttonIndex];
        [[NSUserDefaults standardUserDefaults] setObject:content forKey:@"urlString"];
        [[HttpClient sharedClient] resetUrl];
        self.labelCity.text = content;
    }
}


/**
 *  从文件中获取城市信息
 */
- (void)getCityInfoFromFile
{
//    GuideViewController *vc = [[GuideViewController alloc] init];
//    [self showViewController:vc sender:self];

    NSError *error;
    NSString *cityJsonString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]
            pathForResource:@"city_json" ofType:@"json"] encoding:NSUTF8StringEncoding error:&error];

    NSData *jsonData = [cityJsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *jsonError;

    NSDictionary *zoneDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError];

    arrayProvince = [zoneDic objectForKey:@"provinceList"];
    NSLog(@"length:%ld", arrayProvince.count);

    [arraySearchResult removeAllObjects];
    for (NSObject *o in arrayProvince)
    {
        [arraySearchResult addObject:o];
    }
    arraySearchResult = [[arraySearchResult sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj1 objectForKey:@"pronamepinyin"] compare:[obj2 objectForKey:@"pronamepinyin"]];
    }] mutableCopy];
    [self showAlertTableViewWithTitle:@"省份选择" type:PROVINCE];
}

/**
 *  显示城市的选择弹出框
 *
 *  @param title
 *  @param type
 */
- (void)showAlertTableViewWithTitle:(NSString *)title type:(NSInteger)type
{

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
    [tfSearch setBackgroundColor:[Utils getColorByRGB:@"#f1f1f1"]];;
    UIView *padView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
    [padView setBackgroundColor:[UIColor clearColor]];

    tfSearch.leftView = padView;
    tfSearch.rightView = padView;
    tfSearch.leftViewMode = UITextFieldViewModeAlways;
    tfSearch.rightViewMode = UITextFieldViewModeAlways;

    NSString *placeHolder = @"请输入省份名称";
    if (CITY == type)
    {
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
- (void)cityDialogCancel
{

    UIView *alertView = [self.view viewWithTag:1001];
    if (alertView != nil)
    {
        intCurrentTableViewTag = 0;
        [alertView removeFromSuperview];
    }
}

/**
 *  搜索框监听方法
 *
 *  @param textField <#textField description#>
 */
- (void)textFieldAfterChanged:(UITextField *)textField
{
    if (0 == intCurrentTableViewTag)
    {
        return;
    }
    [arraySearchResult removeAllObjects];

    NSString *content = [textField.text stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceAndNewlineCharacterSet]];

    switch (intCurrentTableViewTag)
    {
        case PROVINCE:
            if (0 == content.length)
            {
                for (NSObject *o in arrayProvince)
                {
                    [arraySearchResult addObject:o];
                }
            }
            else
            {
                for (int i = 0;
                        i < arrayProvince.count;
                        i++)
                {
                    if ([(NSString *) [arrayProvince[i] objectForKey:@"proname"] containsString:content])
                    {
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
            if (0 == content.length)
            {
                for (NSObject *o in arrayCity)
                {
                    [arraySearchResult addObject:o];
                }
            }
            else
            {
                for (int i = 0;
                        i < arrayCity.count;
                        i++)
                {
                    if ([(NSString *) [arrayCity[i] objectForKey:@"cityname"] containsString:content])
                    {
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arraySearchResult.count;
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
        [[cell contentView] addSubview:labelComName];
    }

    UILabel *labelCom = (UILabel *) [cell viewWithTag:1];

    if (tableView.tag == PROVINCE)
    {
        [labelCom setText:[arraySearchResult[indexPath.row] objectForKey:@"proname"]];
    }
    else if (tableView.tag == CITY)
    {
        [labelCom setText:[arraySearchResult[indexPath.row] objectForKey:@"cityname"]];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *content = ((UILabel *) [cell viewWithTag:1]).text;

    if (tableView.tag == PROVINCE)
    {
        arrayCity = [arraySearchResult[indexPath.row] objectForKey:@"citys"];
        [arraySearchResult removeAllObjects];
        for (NSObject *o in arrayCity)
        {
            [arraySearchResult addObject:o];
        }

        //按拼音排序
        arraySearchResult = [[arraySearchResult sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [[obj1 objectForKey:@"citypinyin"] compare:[obj2 objectForKey:@"citypinyin"]];
        }] mutableCopy];

        [self cityDialogCancel];
        [self showAlertTableViewWithTitle:content type:CITY];
    }
    else if (tableView.tag == CITY)
    {

        [self cityDialogCancel];
        labelCity.text = content;

        //设置服务器地址
        [[NSUserDefaults standardUserDefaults] setObject:content forKey:@"urlString"];

        [[HttpClient sharedClient] resetUrl];
    }
}

- (void)resetPassword
{
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ResetPwdViewController"];
    [self presentViewController:viewController animated:YES completion:nil];
}


#pragma mark -- 设置状态栏字体为白色

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    return NO;
}

@end
