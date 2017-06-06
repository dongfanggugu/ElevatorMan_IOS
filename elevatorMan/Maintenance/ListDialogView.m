//
//  ListDialogView.m
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/12/7.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListDialogView.h"

@interface ListDialogView()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ListDialogView

+ (id)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ListDialogView" owner:nil options:nil];
    if (0 == array.count)
    {
        return nil;
    }
    
    return array[0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.7];
    [self initTableView];
    
}

- (void)initTableView
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)setData:(NSArray<id<ListDialogDataDelegate>> *)arrayData
{
    _arrayData = arrayData;
    [_tableView reloadData];
}

- (void)show
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIWindow *window = appDelegate.window;
    
    self.frame = window.bounds;
    
    [window addSubview:self];
    
    [window bringSubviewToFront:self];
}

#pragma mark - UITableDataSource

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 8, 200, 25)];
        label.tag = 1001;
        label.font = [UIFont systemFontOfSize:12];
        [cell.contentView addSubview:label];
    }
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:1001];
    id<ListDialogDataDelegate> info = _arrayData[indexPath.row];
    label.text = [info getShowContent];
    
    return cell;
}


#pragma mark - UITableViewDeleagate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    id<ListDialogDataDelegate> info = _arrayData[indexPath.row];
    if (_delegate)
    {
        [_delegate onSelectItem:[info getKey] content:[info getShowContent]];
    }
    
    if (self.superview)
    {
        [self removeFromSuperview];
    }
}

@end
