//
// Created by changhaozhang on 2017/6/21.
//

#import "DistributeController.h"

@interface DistributeController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *arrayZone;

@end

@implementation DistributeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"区域选择"];
    [self initView];
    [self readZones];
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];

    _tableView.delegate = self;
    _tableView.dataSource = self;

    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
}

- (NSMutableArray *)arrayZone
{
    if (!_arrayZone)
    {
        _arrayZone = [NSMutableArray array];
    }

    return _arrayZone;
}

- (void)readZones
{
    NSString *zoneJson = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"beijing_districts" ofType:@"json"]
                                                   encoding:NSUTF8StringEncoding error:nil];
    NSData *jsonData = [zoneJson dataUsingEncoding:NSUTF8StringEncoding];

    NSDictionary *zoneDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    [self.arrayZone removeAllObjects];
    [self.arrayZone addObjectsFromArray:zoneDic[@"districts"]];
    [_tableView reloadData];
}


#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayZone.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"zone_cell"];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"zone_cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 150, 24)];
        label.tag = 1001;
        label.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:label];
    }

    NSDictionary *info = self.arrayZone[indexPath.row];
    UILabel *label = (UILabel *) [cell.contentView viewWithTag:1001];
    label.text = [info objectForKey:@"name"];

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = self.arrayZone[indexPath.row];

    NSString *name = [info objectForKey:@"name"];

    if (_delegate && [_delegate respondsToSelector:@selector(onChooseZone:)])
    {
        [_delegate onChooseZone:name];
    }

    [self.navigationController popViewControllerAnimated:YES];
}

@end