//
//  AlarmResultViewController.m
//  elevatorMan
//
//  Created by 长浩 张 on 16/3/30.
//
//

#import <Foundation/Foundation.h>
#import "AlarmResultViewController.h"
#import "FileUtils.h"

#pragma mark -- ItemCell

@interface ItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelKey;

@property (weak, nonatomic) IBOutlet UILabel *labelValue;

@end

@implementation ItemCell

@end

#pragma mark -- ItemInfo

@interface ItemInfo : NSObject

@property (strong, nonatomic) NSString *key;

@property (strong, nonatomic) NSString *value;

@end

@implementation ItemInfo

- (instancetype)initWithKey:(NSString *)key value:(NSString *)value
{
    self.key = key;
    self.value = value;

    return self;
}

@end


#pragma mark -- AlarmResultViewController

@interface AlarmResultViewController ()

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation AlarmResultViewController

@synthesize project;

@synthesize address;

@synthesize liftCode;

@synthesize alarmTime;

@synthesize savedCount;

@synthesize injuredCount;

@synthesize dataArray;


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setNavTitle:@"报警详情"];

    [self initDataArray];
    [self initView];

}

- (void)initView
{
    self.tableView.allowsSelection = NO;

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    if (_picUrl)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 540)];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 20)];
        label.text = @"电梯合格证";
        label.font = [UIFont systemFontOfSize:14];
        [view addSubview:label];

        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        _imageView.center = CGPointMake(self.view.frame.size.width / 2, 270);
        _imageView.image = [UIImage imageNamed:@"icon_photo_submit"];

        [view addSubview:_imageView];

        self.tableView.tableFooterView = view;
    }

    [self downloadPictrue];

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


/**
 *  init the data array with the property
 */
- (void)initDataArray
{
    dataArray = [[NSMutableArray alloc] init];
    [dataArray addObject:[[ItemInfo alloc] initWithKey:@"项目" value:project]];
    [dataArray addObject:[[ItemInfo alloc] initWithKey:@"地址" value:address]];
    [dataArray addObject:[[ItemInfo alloc] initWithKey:@"电梯编号" value:liftCode]];
    [dataArray addObject:[[ItemInfo alloc] initWithKey:@"报警时间" value:alarmTime]];
    [dataArray addObject:[[ItemInfo alloc] initWithKey:@"被救人数" value:savedCount]];
    [dataArray addObject:[[ItemInfo alloc] initWithKey:@"伤亡人数" value:injuredCount]];
}


#pragma mark -- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell"];

    ItemInfo *item = dataArray[indexPath.row];

    cell.labelKey.text = item.key;
    cell.labelValue.text = item.value;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 120;
//}

#pragma mark - download picture

- (void)downloadPictrue
{
    NSLog(@"url:%@", _picUrl);
    NSURL *url = [NSURL URLWithString:_picUrl];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *_Nullable response, NSData *_Nullable data, NSError *_Nullable connectionError) {

        if (data.length > 0 && nil == connectionError)
        {
            [self performSelectorOnMainThread:@selector(setImage:) withObject:data waitUntilDone:NO];

        }
        else if (connectionError != nil)
        {
            NSLog(@"download picture error = %@", connectionError);
        }
    }];
}

- (void)setImage:(NSData *)data
{
    _imageView.image = [UIImage imageWithData:data];
}

@end
