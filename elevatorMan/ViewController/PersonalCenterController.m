//
//  PersonalCenter.m
//  elevatorMan
//
//  Created by 长浩 张 on 15/12/22.
//
//

#import <Foundation/Foundation.h>
#import "PersonalCenterController.h"
#import "APService.h"
#import "MaintenanceReminder.h"
#import "AddressViewController.h"
#import "PersonHeaderView.h"


#define ICON_PATH @"/tmp/person/"

#pragma mark -InfoCell

@interface InfoCell : UITableViewCell

+ (id)cellFromNib;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewInfoIcon;

@property (weak, nonatomic) IBOutlet UILabel *labelInfo;

@property (weak, nonatomic) IBOutlet UILabel *keyLabel;

@property (weak, nonatomic) IBOutlet UIView *bagView;

@end


@implementation InfoCell

+ (id)cellFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PersonInfoCell" owner:nil options:nil];

    if (0 == array.count)
    {
        return nil;
    }

    return array[0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _bagView.layer.masksToBounds = YES;
    _bagView.layer.cornerRadius = 5;
    _labelInfo.text = @"";
}

@end


#pragma mark - PersonalCenterController

@interface PersonalCenterController () <UITableViewDelegate, UITableViewDataSource, PersonHeaderDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageViewPersonIcon;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIButton *btnLogOff;

@property (strong, nonatomic) PersonHeaderView *personHeader;

@property NSInteger jpushCount;

@end

@implementation PersonalCenterController

@synthesize btnLogOff;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setNavTitle:@"个人中心"];

    [self initView];
    _jpushCount = 0;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    //在这里加载信息，解决更新信息及时显示的问题
    [self setPersonIcon:[User sharedUser].picUrl];
    _personHeader.name.text = [User sharedUser].name;
    _personHeader.age.text = [NSString stringWithFormat:@"%ld", [User sharedUser].age.integerValue];

    [self.tableView reloadData];
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64 - 49)];

    _tableView.delegate = self;

    _tableView.dataSource = self;

    _tableView.backgroundColor = RGB(BG_GRAY);

    [self.view addSubview:_tableView];

    [self addHeaderView];

    [self addFootView];
}

/**
 *  跳转到基本信息页面
 */
- (void)showBasicInfo
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Person" bundle:nil];
    UIViewController *destinationVC = [board instantiateViewControllerWithIdentifier:@"basicInfo"];
    [self.navigationController pushViewController:destinationVC animated:YES];
}


- (void)addHeaderView
{
    _personHeader = [PersonHeaderView viewFromNib];

    _personHeader.frame = CGRectMake(0, 0, self.screenWidth, 200);

    _personHeader.delegate = self;
    _tableView.tableHeaderView = _personHeader;
}

/**
 *  在下面添加退出登录按钮
 */
- (void)addFootView
{
    btnLogOff = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnLogOff.layer.masksToBounds = YES;
    btnLogOff.layer.cornerRadius = 5;

    //设置文字和文字颜色
    [btnLogOff setTitle:@"退出登录" forState:UIControlStateNormal];
    [btnLogOff setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnLogOff.titleLabel.font = [UIFont systemFontOfSize:13];

    //设置frame
    btnLogOff.frame = CGRectMake(0, 0, 120, 26);

    [btnLogOff addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];

    //设置背景色
    self.btnLogOff.backgroundColor = RGB(TITLE_COLOR);

    UIView *parentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, 100)];

    btnLogOff.center = CGPointMake(self.screenWidth / 2, 50);

    [parentView addSubview:btnLogOff];

    parentView.backgroundColor = [UIColor clearColor];

    self.tableView.tableFooterView = parentView;
}

/**
 *  退出登录
 */
- (void)logout
{

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
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet *)tags alias:(NSString *)alias
{

    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags, alias);
    if (0 == iResCode)
    {

    }
    else
    {
        NSString *err = [NSString stringWithFormat:@"%d:注销消息服务器失败，请重新再试", iResCode];
        NSLog(@"zhenhao:%@", err);

        if (_jpushCount < 5)
        {
            _jpushCount++;
            [APService setAlias:@"" callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
        }
    }
}


#pragma -mark -Table View data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    //如果是物业，不显示操作证号，显示驻点地址
    if (Role_Pro == self.roleType)
    {
        return 3;
    }
    else
    {
        return 3;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section)
    {
        //如果是物业，不显示操作证号
        if (Role_Pro == self.roleType)
        {
            return 1;
        }
        else
        {
            return 2;
        }
    }
    else if (1 == section)
    {

        if (Role_Pro == self.roleType)
        {
            return 1;
        }
        else
        {
            return 2;
        }

    }
    else
    {
        return 1;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    InfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"info_cell"];

    if (!cell)
    {
        cell = [InfoCell cellFromNib];
    }

    if (0 == section)
    {

        //如果是物业，不显示操作证号
        if ([[User sharedUser].userType isEqualToString:UserTypeAdmin])
        {
            if (0 == row)
            {
                cell.imageViewInfoIcon.image = [UIImage imageNamed:@"icon_branch"];
                cell.labelInfo.text = [User sharedUser].branch;
                cell.keyLabel.text = @"公司名称";
                cell.selectionStyle = UITableViewCellEditingStyleNone;
            }
        }
        else
        {


            if (0 == row)
            {
                cell.imageViewInfoIcon.image = [UIImage imageNamed:@"icon_branch"];
                cell.labelInfo.text = [User sharedUser].branch;
                cell.selectionStyle = UITableViewCellEditingStyleNone;
            }
            else if (1 == row)
            {
                cell.imageViewInfoIcon.image = [UIImage imageNamed:@"icon_operation"];
                cell.keyLabel.text = @"操作证号";
                cell.labelInfo.text = [User sharedUser].operation;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }

        }
    }
    else if (1 == section)
    {

        //如果是物业，直接显示设置
        if (Role_Pro == self.roleType)
        {
            cell.imageViewInfoIcon.image = [UIImage imageNamed:@"icon_settings"];
            cell.keyLabel.text = @"驻点";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else
        {
            if (0 == row)
            {
                cell.imageViewInfoIcon.image = [UIImage imageNamed:@"icon_home"];
                cell.keyLabel.text = @"家庭住址";
                cell.labelInfo.text = [User sharedUser].homeAddress;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            }
            else if (1 == row)
            {
                cell.imageViewInfoIcon.image = [UIImage imageNamed:@"icon_work_place"];
                cell.keyLabel.text = @"工作地址";
                cell.labelInfo.text = [User sharedUser].workAddress;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            }
        }
    }
    else if (2 == section)
    {
        //如果是物业，直接显示设置
        if ([[User sharedUser].userType isEqualToString:UserTypeAdmin])
        {
            cell.imageViewInfoIcon.image = [UIImage imageNamed:@"icon_settings"];
            cell.keyLabel.text = @"设置";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else
        {
            cell.imageViewInfoIcon.image = [UIImage imageNamed:@"icon_settings"];
            cell.keyLabel.text = @"设置";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }


    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (1 == section)
    {
        if ([[User sharedUser].userType isEqualToString:UserTypeAdmin])
        {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //松手后颜色回复
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    if (0 == section)
    {

        if (Role_Pro == self.roleType)
        {

        }
        else
        {
            if (1 == row)
            {
                UIViewController *destinationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ModifyDetail"];
                [destinationVC setValue:@"operation" forKey:@"enterType"];
                [self.navigationController pushViewController:destinationVC animated:YES];
            }
        }
    }
    else if (1 == section)
    {

        if ([[User sharedUser].userType isEqualToString:UserTypeAdmin])
        {
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Person" bundle:nil];
            UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"pro_location_controller"];
            [self.navigationController pushViewController:controller animated:YES];
        }
        else
        {

            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Person" bundle:nil];
            AddressViewController *controller = [board instantiateViewControllerWithIdentifier:@"address_controller"];
            if (0 == row)
            {
                controller.addType = TYPE_HOME;
            }
            else if (1 == row)
            {
                controller.addType = TYPE_WORK;
            }
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
    else if (2 == section)
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Person" bundle:nil];
        UIViewController *controller = [board instantiateViewControllerWithIdentifier:@"settings_controller"];
        [self.navigationController pushViewController:controller animated:YES];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([[User sharedUser].userType isEqualToString:UserTypeAdmin])
    {
        return 20;
    }
    else
    {
        return 40;
    }
}


#pragma mark - deal with the icon image


- (void)setPersonIcon:(NSString *)urlString
{
    [_personHeader.image setImageWithURL:[NSURL URLWithString:urlString]];
}


#pragma mark -- PersonHeaderDelegate

- (void)onClickIcon
{
    [self showBasicInfo];
}

@end
