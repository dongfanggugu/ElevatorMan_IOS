//
//  WRepairDetailController.m
//  elevatorMan
//
//  Created by 长浩 张 on 2017/1/12.
//
//

#import <Foundation/Foundation.h>
#import "WRepairDetailController.h"
#import "WRepairView.h"
#import "Utils.h"
#import "HttpClient.h"
#import "EvaluateView.h"


#pragma mark - RepairDetailCell

@interface RepairDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbKey;

@property (weak, nonatomic) IBOutlet UILabel *lbContent;


@end

@implementation RepairDetailCell



@end


#pragma mark - WRepairDetailContorller

@interface WRepairDetailController()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *arrayData;

@property (strong, nonatomic) WRepairView *repairView;

@end

@implementation WRepairDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"报修记录"];
    [self initView];
    [self initData];
    
}

- (void)initView
{
    _tableView.bounces = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.allowsSelection = NO;
}

- (void)initData
{
    _arrayData = [NSMutableArray array];
    
    if (!_repairInfo)
    {
        return;
    }
    
    NSInteger state = [[_repairInfo objectForKey:@"state"] integerValue];
    
    if (4 == state || 6 == state)
    {
        
        //报修时间
        NSString *time = [_repairInfo objectForKey:@"createTime"];
        NSMutableDictionary *dicTime = [NSMutableDictionary dictionary];
        dicTime[@"key"] = @"报修时间";
        dicTime[@"content"] = time;
        [_arrayData addObject:dicTime];
        
        //业主姓名
        NSString *name = [_repairInfo objectForKey:@"name"];
        NSMutableDictionary *dicName = [NSMutableDictionary dictionary];
        dicName[@"key"] = @"业主姓名";
        dicName[@"content"] = name;
        [_arrayData addObject:dicName];
        
        
        //业主电话
        NSString *tel = [_repairInfo objectForKey:@"tel"];
        NSMutableDictionary *dicTel = [NSMutableDictionary dictionary];
        dicTel[@"key"] = @"业主电话";
        dicTel[@"content"] = tel;
        [_arrayData addObject:dicTel];
        
        //小区名字
        NSString *cellName = [_repairInfo objectForKey:@"cellName"];
        NSMutableDictionary *dicCell = [NSMutableDictionary dictionary];
        dicCell[@"key"] = @"小区";
        dicCell[@"content"] = cellName;
        [_arrayData addObject:dicCell];
        
        //小区地址
        NSString *address = [_repairInfo objectForKey:@"address"];
        NSMutableDictionary *dicAdd = [NSMutableDictionary dictionary];
        dicAdd[@"key"] = @"小区地址";
        dicAdd[@"content"] = address;
        [_arrayData addObject:dicAdd];
        
        
        //电梯品牌
        NSString *brand = [_repairInfo objectForKey:@"brand"];
        NSMutableDictionary *dicBrand = [NSMutableDictionary dictionary];
        dicBrand[@"key"] = @"电梯品牌";
        dicBrand[@"content"] = brand;
        [_arrayData addObject:dicBrand];
        
        
        //报修状态
        NSMutableDictionary *dicState = [NSMutableDictionary dictionary];
        dicState[@"key"] = @"报修状态";
        dicState[@"content"] = @"已确认";
        [_arrayData addObject:dicState];
        
        //报修现象
        NSString *remark = [_repairInfo objectForKey:@"phenomenon"];
        NSMutableDictionary *dicRemark = [NSMutableDictionary dictionary];
        dicRemark[@"key"] = @"报修描述";
        dicRemark[@"content"] = remark;
        [_arrayData addObject:dicRemark];
        
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,
                                                                    170)];
        _repairView = [WRepairView viewFromNib];
        
        CGRect frame = _repairView.frame;
        frame.origin.x = 0;
        frame.origin.y = 10;
        _repairView.frame = frame;
        
        [footView addSubview:_repairView];
        
        UIButton *btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(0, 140, 200, 45)];
        btnSubmit.center = CGPointMake(self.view.frame.size.width / 2, 152);
        [btnSubmit setBackgroundColor:[Utils getColorByRGB:@"#007EC5"]];
        [btnSubmit setTitle:@"提交" forState:UIControlStateNormal];
        btnSubmit.titleLabel.font = [UIFont systemFontOfSize:15];
        
        btnSubmit.layer.masksToBounds = YES;
        btnSubmit.layer.cornerRadius = 5;
        
        [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [btnSubmit addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
        
        [footView addSubview:btnSubmit];
        
        
        _tableView.tableFooterView = footView;
        
    }
    else if (8 == state)
    {
        //报修时间
        NSString *time = [_repairInfo objectForKey:@"createTime"];
        NSMutableDictionary *dicTime = [NSMutableDictionary dictionary];
        dicTime[@"key"] = @"报修时间";
        dicTime[@"content"] = time;
        [_arrayData addObject:dicTime];
        
        //业主姓名
        NSString *name = [_repairInfo objectForKey:@"name"];
        NSMutableDictionary *dicName = [NSMutableDictionary dictionary];
        dicName[@"key"] = @"业主电话";
        dicName[@"content"] = name;
        [_arrayData addObject:dicName];
        
        
        //业主电话
        NSString *tel = [_repairInfo objectForKey:@"tel"];
        NSMutableDictionary *dicTel = [NSMutableDictionary dictionary];
        dicTel[@"key"] = @"业主电话";
        dicTel[@"content"] = tel;
        [_arrayData addObject:dicTel];
        
        //小区名字
        NSString *cellName = [_repairInfo objectForKey:@"cellName"];
        NSMutableDictionary *dicCell = [NSMutableDictionary dictionary];
        dicCell[@"key"] = @"小区";
        dicCell[@"content"] = cellName;
        [_arrayData addObject:dicCell];
        
        //小区地址
        NSString *address = [_repairInfo objectForKey:@"address"];
        NSMutableDictionary *dicAdd = [NSMutableDictionary dictionary];
        dicAdd[@"key"] = @"小区地址";
        dicAdd[@"content"] = address;
        [_arrayData addObject:dicAdd];
        
        
        //电梯品牌
        NSString *brand = [_repairInfo objectForKey:@"brand"];
        NSMutableDictionary *dicBrand = [NSMutableDictionary dictionary];
        dicBrand[@"key"] = @"电梯品牌";
        dicBrand[@"content"] = brand;
        [_arrayData addObject:dicBrand];
        
        
        //报修状态
        NSMutableDictionary *dicState = [NSMutableDictionary dictionary];
        dicState[@"key"] = @"报修状态";
        dicState[@"content"] = @"已确认";
        [_arrayData addObject:dicState];
        
        //报修现象
        NSString *remark = [_repairInfo objectForKey:@"phenomenon"];
        NSMutableDictionary *dicRemark = [NSMutableDictionary dictionary];
        dicRemark[@"key"] = @"报修描述";
        dicRemark[@"content"] = remark;
        [_arrayData addObject:dicRemark];
        
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,
                                                                    170)];
        _repairView = [WRepairView viewFromNib];
        _repairView.tvContent.text = [_repairInfo objectForKey:@"finishResult"];
        _repairView.tvContent.editable = NO;
        
        CGRect frame = _repairView.frame;
        frame.origin.x = 0;
        frame.origin.y = 10;
        _repairView.frame = frame;
        
        [footView addSubview:_repairView];
        
        _tableView.tableFooterView = footView;
        
    }
    else if (9 == state)
    {
        //报修时间
        NSString *time = [_repairInfo objectForKey:@"createTime"];
        NSMutableDictionary *dicTime = [NSMutableDictionary dictionary];
        dicTime[@"key"] = @"报修时间";
        dicTime[@"content"] = time;
        [_arrayData addObject:dicTime];
        
        //业主姓名
        NSString *name = [_repairInfo objectForKey:@"name"];
        NSMutableDictionary *dicName = [NSMutableDictionary dictionary];
        dicName[@"key"] = @"业主电话";
        dicName[@"content"] = name;
        [_arrayData addObject:dicName];
        
        
        //业主电话
        NSString *tel = [_repairInfo objectForKey:@"tel"];
        NSMutableDictionary *dicTel = [NSMutableDictionary dictionary];
        dicTel[@"key"] = @"业主电话";
        dicTel[@"content"] = tel;
        [_arrayData addObject:dicTel];
        
        //小区名字
        NSString *cellName = [_repairInfo objectForKey:@"cellName"];
        NSMutableDictionary *dicCell = [NSMutableDictionary dictionary];
        dicCell[@"key"] = @"小区";
        dicCell[@"content"] = cellName;
        [_arrayData addObject:dicCell];
        
        //小区地址
        NSString *address = [_repairInfo objectForKey:@"address"];
        NSMutableDictionary *dicAdd = [NSMutableDictionary dictionary];
        dicAdd[@"key"] = @"小区地址";
        dicAdd[@"content"] = address;
        [_arrayData addObject:dicAdd];
        
        
        //电梯品牌
        NSString *brand = [_repairInfo objectForKey:@"brand"];
        NSMutableDictionary *dicBrand = [NSMutableDictionary dictionary];
        dicBrand[@"key"] = @"电梯品牌";
        dicBrand[@"content"] = brand;
        [_arrayData addObject:dicBrand];
        
        
        //报修状态
        NSMutableDictionary *dicState = [NSMutableDictionary dictionary];
        dicState[@"key"] = @"报修状态";
        dicState[@"content"] = @"已确认";
        [_arrayData addObject:dicState];
        
        //报修现象
        NSString *remark = [_repairInfo objectForKey:@"phenomenon"];
        NSMutableDictionary *dicRemark = [NSMutableDictionary dictionary];
        dicRemark[@"key"] = @"报修描述";
        dicRemark[@"content"] = remark;
        [_arrayData addObject:dicRemark];
        
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,
                                                                    350)];
        _repairView = [WRepairView viewFromNib];
        _repairView.tvContent.text = [_repairInfo objectForKey:@"finishResult"];
        _repairView.tvContent.editable = NO;
        
        CGRect frame = _repairView.frame;
        frame.origin.x = 0;
        frame.origin.y = 10;
        _repairView.frame = frame;
        
        [footView addSubview:_repairView];
        
        
        EvaluteView *evaluteView = [EvaluteView viewFromNib];
        [evaluteView setModeShow];
        [evaluteView setStar:[[_repairInfo objectForKey:@"evaluate"] integerValue]];
        [evaluteView setContent:[_repairInfo objectForKey:@"evaluateInfo"]];
        
        CGRect eFrame = evaluteView.frame;
        eFrame.origin.x = 0;
        eFrame.origin.y = 125;
        evaluteView.frame = eFrame;
        [footView addSubview:evaluteView];
        
        _tableView.tableFooterView = footView;
    }
}

#pragma mark - Network Request

- (void)submit
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"repairId"] = [_repairInfo objectForKey:@"id"];
    
    NSString *remark = _repairView.tvContent.text;
    
    if (0 == remark.length)
    {
        [HUDClass showHUDWithLabel:@"请先填写维修情况说明" view:self.view];
        return;
    }
    param[@"finishResult"] = remark;
    
    [[HttpClient sharedClient] view:self.view post:@"editRepairByWorker" parameter:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUDClass showHUDWithLabel:@"维修结果提交成功,稍后您将在维修历史中查看业主的评价" view:self.view];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_arrayData)
    {
        return _arrayData.count;
    }
    
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RepairDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"repair_detail_cell"];
    
    if (!cell)
    {
        cell = [[RepairDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"repair_detail_cell"];
    }
    
    NSDictionary *info = _arrayData[indexPath.row];
    
    cell.lbKey.text = [info objectForKey:@"key"];
    cell.lbContent.text = [info objectForKey:@"content"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

@end
