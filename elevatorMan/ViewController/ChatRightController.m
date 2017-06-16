//
//  ChatRightController.m
//  elevatorMan
//
//  Created by 长浩 张 on 2017/4/5.
//
//

#import "ChatRightController.h"
#import "Utils.h"


#define IMAGE_TAG 1001

@interface ChatRightController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation ChatRightController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth / 2,
            self.screenHeight - 64 - 49)];

    _tableView.delegate = self;

    _tableView.dataSource = self;

    _tableView.bounces = NO;

    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self.view addSubview:_tableView];

    [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES
                      scrollPosition:UITableViewScrollPositionTop];

}

- (void)setItemUnRead:(NSString *)alarmId
{
    for (int i = 0;
            i < _arrayAlarm.count;
            i++)
    {
        if ([alarmId isEqualToString:[_arrayAlarm[i] objectForKey:@"id"]])
        {
            UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];

            UIView *view = [cell.contentView viewWithTag:IMAGE_TAG];

            view.hidden = NO;
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayAlarm.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    UIView *view = [[UIImageView alloc] initWithFrame:CGRectMake(6, 17, 10, 10)];

    view.tag = IMAGE_TAG;

    view.hidden = YES;

    view.backgroundColor = [UIColor redColor];

    view.layer.masksToBounds = YES;

    view.layer.cornerRadius = 11;

    [cell.contentView addSubview:view];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(22, 0, self.screenWidth, 44)];

    [cell.contentView addSubview:label];

    label.text = [_arrayAlarm[indexPath.row] objectForKey:@"text"];

    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    //隐藏未读消息的标记
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    UIView *view = [cell.contentView viewWithTag:IMAGE_TAG];

    view.hidden = YES;

    if (_delegate && [_delegate respondsToSelector:@selector(onSelectItem:withKey:)])
    {
        [_delegate onSelectItem:[_arrayAlarm[indexPath.row] objectForKey:@"text"]
                        withKey:[_arrayAlarm[indexPath.row] objectForKey:@"id"]];
    }
}

@end
