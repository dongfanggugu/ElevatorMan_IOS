//
//  PropertyRegister.m
//  elevatorMan
//
//  Created by 长浩 张 on 2017/1/5.
//
//

#import <Foundation/Foundation.h>
#import "PropertyRegister.h"
#import "HttpClient.h"
#import "LocationViewController.h"

#pragma makr - ProInfoCell

@interface ProInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbKey;

@property (weak, nonatomic) IBOutlet UITextField *tfValue;

@property (weak, nonatomic) IBOutlet UIButton *btnLocation;

@end

@implementation ProInfoCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    _btnLocation.hidden = YES;
}

@end

#pragma mark - PropertyRegister

@interface PropertyRegister()<UITableViewDelegate, UITableViewDataSource, LocationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property CGFloat lat;

@property CGFloat lng;

@end

@implementation PropertyRegister


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"物业注册"];
    [self initNavRightWithText:@"提交"];
    [self initView];
}


- (void)initView
{
    _tableView.bounces = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_tableView setAllowsSelection:NO];
}


- (void)onClickNavRight
{
    [self proRegister];
}

#pragma mark - NetworkRequest

- (void)proRegister
{
    ProInfoCell *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *name = cell1.tfValue.text;
    
    if (0 == name.length)
    {
        [HUDClass showHUDWithLabel:@"请填写物业公司名称" view:self.view];
        return;
    }
    
    ProInfoCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *manager = cell2.tfValue.text;
    
    if (0 == manager.length)
    {
        [HUDClass showHUDWithLabel:@"请填写物业公司联系人" view:self.view];
        return;
    }
    
    ProInfoCell *cell3 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    NSString *tel = cell3.tfValue.text;
    
    if (0 == tel.length)
    {
        [HUDClass showHUDWithLabel:@"请填写联系电话" view:self.view];
        return;
    }
    
    ProInfoCell *cell4 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    NSString *address = cell4.tfValue.text;
    
    if (0 == address.length)
    {
        [HUDClass showHUDWithLabel:@"请填写地址" view:self.view];
        return;
    }
    
    if (0 == _lat || 0 == _lng)
    {
        [HUDClass showHUDWithLabel:@"请在地图选择地址位置" view:self.view];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"name"] = name;
    params[@"manager"] = manager;
    params[@"tel"] = tel;
    params[@"address"] = address;
    params[@"lat"] = [NSNumber numberWithFloat:_lat];
    params[@"lng"] = [NSNumber numberWithFloat:_lng];
    
    [[HttpClient sharedClient] view:self.view post:@"propertyRegist" parameter:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUDClass showHUDWithLabel:@"注册成功,请使用您的注册电话登录" view:self.view];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pro_info_cell"];
    
    if (nil == cell)
    {
        cell = [[ProInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pro_info_cell"];
    }
    
    NSInteger index = indexPath.row;
    
    if (0 == index)
    {
        cell.lbKey.text = @"物业公司名称";
        cell.tfValue.placeholder = @"物业公司名称";
    }
    else if (1 == index)
    {
        cell.lbKey.text = @"物业联系人";
        cell.tfValue.placeholder = @"物业联系人";
    }
    else if (2 == index)
    {
        cell.lbKey.text = @"联系电话";
        cell.tfValue.placeholder = @"联系电话";
    }
    else if (3 == index)
    {
        cell.lbKey.text = @"物业公司地址";
        cell.tfValue.placeholder = @"物业公司地址";
        cell.btnLocation.hidden = NO;
        
        [cell.btnLocation addTarget:self action:@selector(addressLocation) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}


- (void)addressLocation
{
    ProInfoCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    NSString *address = cell.tfValue.text;
    
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Person" bundle:nil];
    LocationViewController *controller = [board instantiateViewControllerWithIdentifier:@"address_location"];
    controller.delegate = self;
    controller.enterType = 1;
    controller.address = address;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - LocationControllerDelegate

- (void)onChooseAddressLat:(CGFloat)lat lng:(CGFloat)lng
{
    _lat = lat;
    _lng = lng;
}
@end
