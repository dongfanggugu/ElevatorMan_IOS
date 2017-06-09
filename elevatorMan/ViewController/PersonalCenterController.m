//
//  PersonalCenter.m
//  elevatorMan
//
//  Created by 长浩 张 on 15/12/22.
//
//

#import <Foundation/Foundation.h>
#import "PersonalCenterController.h"
#import "Utils.h"
#import "FileUtils.h"
#import "HttpClient.h"
#import "APService.h"
#import "MaintenanceReminder.h"
#import "AddressViewController.h"
#import "PersonHeaderView.h"


#define ICON_PATH @"/tmp/person/"

#pragma mark -InfoCell

@interface InfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageViewInfoIcon;

@property (weak, nonatomic) IBOutlet UILabel *labelInfo;

@property (weak, nonatomic) IBOutlet UILabel *keyLabel;

@property (weak, nonatomic) IBOutlet UIView *bagView;

@end


@implementation InfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _bagView.layer.masksToBounds = YES;
    _bagView.layer.cornerRadius = 5;
}

@end


#pragma mark - PersonalCenterController

@interface PersonalCenterController () <UITableViewDelegate, UITableViewDataSource, PersonHeaderDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageViewPersonIcon;

@property (weak, nonatomic) IBOutlet UILabel *labelName;

@property (weak, nonatomic) IBOutlet UILabel *labelSex;

@property (weak, nonatomic) IBOutlet UILabel *labelAge;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UIButton *btnLogOff;

@property (strong, nonatomic) PersonHeaderView *personHeader;

@property NSInteger jpushCount;

@end

@implementation PersonalCenterController

@synthesize btnLogOff;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavTitle:@"个人中心"];

    _jpushCount = 0;


//    //设置ImageView圆形
//    self.imageViewPersonIcon.layer.masksToBounds = YES;
//    self.imageViewPersonIcon.layer.cornerRadius = 40;
//    
//    self.imageViewPersonIcon.userInteractionEnabled = YES;
//    UIGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBasicInfo)];
//    [self.imageViewPersonIcon addGestureRecognizer:recognizer];
    _tableView.bounces = NO;
    [self addHeaderView];
    [self addFootView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    //在这里加载信息，解决更新信息及时显示的问题
    [self setPersonIcon:[User sharedUser].picUrl];
    _personHeader.name.text = [User sharedUser].name;
    _personHeader.sex.text = [User sharedUser].sex.integerValue == 0 ? @"女" : @"男";
    _personHeader.age.text = [NSString stringWithFormat:@"%ld", [User sharedUser].age.integerValue];

    [self.tableView reloadData];
}

/**
 *  跳转到基本信息页面
 */
- (void)showBasicInfo {
    UIViewController *destinationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"basicInfo"];
    [self.navigationController pushViewController:destinationVC animated:YES];
}

- (void)addHeaderView {
    _personHeader = [PersonHeaderView viewFromNib];
    _personHeader.delegate = self;
    _tableView.tableHeaderView = _personHeader;
}

/**
 *  在下面添加退出登录按钮
 */
- (void)addFootView {

    btnLogOff = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnLogOff.layer.masksToBounds = YES;
    btnLogOff.layer.cornerRadius = 5;

    //设置文字和文字颜色
    [btnLogOff setTitle:@"退出登录" forState:UIControlStateNormal];
    [btnLogOff setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    //设置frame
    btnLogOff.frame = CGRectMake(0, 0, 50, 70);
    btnLogOff.translatesAutoresizingMaskIntoConstraints = NO;

    //设置背景色
    self.btnLogOff.backgroundColor = [Utils getColorByRGB:@"#007EC5"];

    UIView *parentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 100)];


    [parentView addSubview:btnLogOff];
    parentView.backgroundColor = [UIColor clearColor];

    NSDictionary *views = NSDictionaryOfVariableBindings(btnLogOff);

    //设置button高度40
    [parentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[btnLogOff(40)]"
                                                                       options:0 metrics:nil views:views]];

    //设置button距离上边框60
    [parentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[btnLogOff]"
                                                                       options:0 metrics:nil views:views]];



    //设置button距离左右边框都是20
    [parentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[btnLogOff]-20-|"
                                                                       options:0 metrics:nil views:views]];

    self.tableView.tableFooterView = parentView;

    [btnLogOff addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  退出登录
 */
- (void)logout {

    //注销jpush//请求
    [[HttpClient sharedClient] view:self.view post:@"logout" parameter:nil
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                //退出登录
                                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogged"];

                                [[User sharedUser] clearUserInfo];

                                //取消制定的维保通知，不需要区分物业还是维修工
                                [MaintenanceReminder cancelMaintenanceNofity];

                                [[HttpClient sharedClient] logoutBackTosignIn];

                                [APService setAlias:@"" callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];

                            } failed:^(id responseObject) {
                NSLog(@"log out with no internet");
                [[HttpClient sharedClient] logoutBackTosignIn];
            }];
}

/**
 *  JPush回调方法
 *
 *  @param iResCode
 *  @param tags
 *  @param alias
 */
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet *)tags alias:(NSString *)alias {

    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags, alias);
    if (0 == iResCode) {

    } else {
        NSString *err = [NSString stringWithFormat:@"%d:注销消息服务器失败，请重新再试", iResCode];
        NSLog(@"zhenhao:%@", err);

        if (_jpushCount < 5) {
            _jpushCount++;
            [APService setAlias:@"" callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
        }
    }
}


#pragma -mark -Table View data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    //如果是物业，不显示操作证号，显示驻点地址
    if ([[User sharedUser].userType isEqualToString:UserTypeAdmin]) {
        return 3;
    } else {
        return 3;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (0 == section) {
        //如果是物业，不显示操作证号
        if ([[User sharedUser].userType isEqualToString:UserTypeAdmin]) {
            return 1;
        } else {
            return 2;
        }
    } else if (1 == section) {

        if ([[User sharedUser].userType isEqualToString:UserTypeAdmin]) {
            return 1;
        } else {
            return 2;
        }

    } else {
        return 1;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    InfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell"];

    if (0 == section) {

        //如果是物业，不显示操作证号
        if ([[User sharedUser].userType isEqualToString:UserTypeAdmin]) {
            if (0 == row) {
                cell.imageViewInfoIcon.image = [UIImage imageNamed:@"icon_branch"];
                cell.labelInfo.text = [User sharedUser].branch;
                cell.keyLabel.text = @"公司名称";
                cell.selectionStyle = UITableViewCellEditingStyleNone;
            }
        } else {


            if (0 == row) {
                cell.imageViewInfoIcon.image = [UIImage imageNamed:@"icon_branch"];
                cell.labelInfo.text = [User sharedUser].branch;
                cell.selectionStyle = UITableViewCellEditingStyleNone;
            } else if (1 == row) {
                cell.imageViewInfoIcon.image = [UIImage imageNamed:@"icon_operation"];
                cell.keyLabel.text = @"操作证号";
                cell.labelInfo.text = [User sharedUser].operation;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }

        }
    } else if (1 == section) {

        //如果是物业，直接显示设置
        if ([[User sharedUser].userType isEqualToString:UserTypeAdmin]) {
            cell.imageViewInfoIcon.image = [UIImage imageNamed:@"icon_settings"];
            cell.keyLabel.text = @"驻点";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            if (0 == row) {
                cell.imageViewInfoIcon.image = [UIImage imageNamed:@"icon_home"];
                cell.keyLabel.text = @"家庭住址";
                cell.labelInfo.text = [User sharedUser].homeAddress;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            } else if (1 == row) {
                cell.imageViewInfoIcon.image = [UIImage imageNamed:@"icon_work_place"];
                cell.keyLabel.text = @"工作地址";
                cell.labelInfo.text = [User sharedUser].workAddress;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            }
        }
    } else if (2 == section) {
        //如果是物业，直接显示设置
        if ([[User sharedUser].userType isEqualToString:UserTypeAdmin]) {
            cell.imageViewInfoIcon.image = [UIImage imageNamed:@"icon_settings"];
            cell.keyLabel.text = @"设置";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.imageViewInfoIcon.image = [UIImage imageNamed:@"icon_settings"];
            cell.keyLabel.text = @"设置";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }


    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (1 == section) {
        if ([[User sharedUser].userType isEqualToString:UserTypeAdmin]) {
            return nil;
        }
        UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 80, 25)];
        //label.backgroundColor = [UIColor redColor];
        label.text = @"常驻地址";
        label.font = [UIFont systemFontOfSize:14];
        [head addSubview:label];
        return head;
    }

    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //松手后颜色回复
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    if (0 == section) {

        if ([[User sharedUser].userType isEqualToString:UserTypeAdmin]) {
            //            if (1 == row)
            //            {
            //                UIViewController *destinationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PasswordPage"];
            //                [self.navigationController pushViewController:destinationVC animated:YES];
            //            }

        } else {
            if (1 == row) {
                UIViewController *destinationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ModifyDetail"];
                [destinationVC setValue:@"operation" forKey:@"enterType"];
                [self.navigationController pushViewController:destinationVC animated:YES];
            }
        }
    } else if (1 == section) {

        if ([[User sharedUser].userType isEqualToString:UserTypeAdmin]) {
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Person" bundle:nil];
            UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"pro_location_controller"];
            [self.navigationController pushViewController:controller animated:YES];
        } else {

            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Person" bundle:nil];
            AddressViewController *controller = [board instantiateViewControllerWithIdentifier:@"address_controller"];
            if (0 == row) {
                controller.addType = TYPE_HOME;
            } else if (1 == row) {
                controller.addType = TYPE_WORK;
            }
            [self.navigationController pushViewController:controller animated:YES];
        }
    } else if (2 == section) {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Person" bundle:nil];
        UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"settings_controller"];
        [self.navigationController pushViewController:controller animated:YES];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([[User sharedUser].userType isEqualToString:UserTypeAdmin]) {
        return 20;
    } else {
        return 40;
    }
}


#pragma mark - deal with the icon image


- (void)downloadIconByUrlString:(NSString *)urlString dirPath:(NSString *)dirPath fileName:(NSString *)fileName {
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *_Nullable response, NSData *_Nullable data, NSError *_Nullable connectionError) {

        if (data.length > 0 && nil == connectionError) {
            [FileUtils writeFile:data Path:dirPath fileName:fileName];
            [self performSelectorOnMainThread:@selector(setPersonIcon:) withObject:urlString waitUntilDone:NO];

        } else if (connectionError != nil) {
            NSLog(@"download picture error = %@", connectionError);
        }
    }];
}


- (void)setPersonIcon:(NSString *)urlString {

    NSLog(@"picture url:%@", urlString);

    if (0 == urlString.length) {
        return;
    }
    NSString *dirPath = [NSHomeDirectory() stringByAppendingString:ICON_PATH];
    NSString *fileName = [FileUtils getFileNameFromUrlString:urlString];
    NSString *filePath = [dirPath stringByAppendingString:fileName];

    if ([FileUtils existInFilePath:filePath]) {

        UIImage *icon = [UIImage imageWithContentsOfFile:filePath];
        _personHeader.image.image = icon;
    } else {
        [self downloadIconByUrlString:urlString dirPath:dirPath fileName:fileName];
    }

}

- (void)setTitleString:(NSString *)title {
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    labelTitle.text = title;
    labelTitle.font = [UIFont fontWithName:@"System" size:17];
    labelTitle.textColor = [UIColor whiteColor];
    [self.navigationItem setTitleView:labelTitle];
}

- (void)backToMainPage {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -- PersonHeaderDelegate

- (void)onClickIcon {
    [self showBasicInfo];
}

@end
