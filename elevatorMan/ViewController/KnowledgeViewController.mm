//
//  KnowledgeViewController.m
//  elevatorMan
//
//  Created by 长浩 张 on 16/3/29.
//
//

#import <Foundation/Foundation.h>
#import "KnowledgeViewController.h"
#import "KnTitleListViewController.h"
#import "Utils.h"
#import "../../chorstar/chorstar/Chorstar.h"

#define SEARCH_FONT_SIZE 14

@interface KnowledgeViewController()<UITableViewDelegate, UITableViewDataSource>
{
    std::vector<std::string> *brandList;
}

@property (weak, nonatomic) IBOutlet UIView *viewQa;

@property (weak, nonatomic) IBOutlet UIView *viewOp;

@property (weak, nonatomic) IBOutlet UIView *viewFault;

@property (weak, nonatomic) IBOutlet UIView *viewLaw;

@end

@implementation KnowledgeViewController

//- (void)dealloc
//{
//    if (brandList)
//    {
//        delete brandList;
//        brandList = NULL;
//    }
//    
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    [self setNavTitle:@"电梯百科"];
//    
//    [self setOnClickView:self.viewQa withTag:1];
//    [self setOnClickView:self.viewOp withTag:2];
//    [self setOnClickView:self.viewFault withTag:3];
//    [self setOnClickView:self.viewLaw withTag:4];
//    
//    [self updateKnowledgeAsync];
//}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self setNavigationStyle];
//}
//
///**
// *  异步更新知识库的数据库
// */
//- (void)updateKnowledgeAsync
//{
//    //update knowledge db
//    NSString *dbDir = [NSHomeDirectory() stringByAppendingString:SQLITE_PATH];
//    NSString *dbPath = [dbDir stringByAppendingString:SQLITE_KN_NAME];
//    NSString *address = [Utils getServer];
//    MBProgressHUD *hud = [HUDClass showLoadingHUD:self.view];
//    dispatch_queue_t queue = dispatch_queue_create("queue", NULL);
//    dispatch_async(queue, ^{
//        requestKnowledgeUpdate(dbPath.UTF8String, address.UTF8String, "1", "",
//                               [User sharedUser].accessToken.UTF8String, [User sharedUser].userId.UTF8String);
//        [self performSelectorOnMainThread:@selector(dismissLoad:) withObject:hud waitUntilDone:YES];
//    });
//    
//}
//
///**
// *  取消进度条的显示
// *
// *  @param hud <#hud description#>
// */
//- (void)dismissLoad:(MBProgressHUD *)hud
//{
//    [HUDClass hideLoadingHUD:hud];
//}
//
///**
// *  set the navigation bar
// */
//- (void)setNavigationStyle
//{
//    UIButton *buttonRight = [UIButton buttonWithType:UIButtonTypeCustom];
//    [buttonRight setImage:[UIImage imageNamed:@"icon_query"] forState:UIControlStateNormal];
//    [buttonRight setFrame:CGRectMake(0, 0, 25, 25)];
//    [buttonRight addTarget:self action:@selector(showSelDialog)
//         forControlEvents:UIControlEventTouchUpInside];
//    
//    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
//}
//
//
///**
// *  set the view click listener
// *
// *  @param view <#view description#>
// *  @param tag  <#tag description#>
// */
//- (void)setOnClickView:(UIView *)view withTag:(NSInteger)tag
//{
//    view.userInteractionEnabled = YES;
//    view.tag = tag;
//    UIGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                              action:@selector(onClick:)];
//    [view addGestureRecognizer:recognizer];
//    
//}
//
///**
// *  when click the view, jump to the list controller and send the click tag
// *
// *  @param sender
// */
//- (void)onClick:(id)sender
//{
//    NSInteger tag = [(UIGestureRecognizer *)sender view].tag;
//    KnTitleListViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"KnTitleListViewController"];
//    vc.mType = tag;
//    [self.navigationController pushViewController:vc animated:YES];
//}
//
///**
// *  show search dialog
// */
//- (void)showSelDialog
//{
//    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
//    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
//    
//    //create full screen view to make model view
//    UIView *selView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
//    selView.tag = 1000;
//    [selView setBackgroundColor:[UIColor clearColor]];
//    [self.view addSubview:selView];
//    
//    CGFloat parentViewWidth = screenWidth - 60;
//    CGFloat parentViewHeight = 210;
//    
//    
//    UIView *parentView = [[UIView alloc] initWithFrame:CGRectMake(30, (screenHeight - parentViewHeight) / 2,
//                                                                  parentViewWidth, parentViewHeight)];
//    
//    //set shadow
//    parentView.layer.shadowColor = [UIColor blackColor].CGColor;
//    parentView.layer.shadowOffset = CGSizeMake(4, 4);
//    parentView.layer.shadowOpacity = 0.6;
//    parentView.layer.shadowRadius = 4;
//    
//    [parentView setBackgroundColor:[UIColor whiteColor]];
//    [selView addSubview:parentView];
//    
//    //set alert view title
//    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, parentViewWidth, 55)];
//    labelTitle.text = @"搜索";
//    [labelTitle setBackgroundColor:[Utils getColorByRGB:@"#25B6ED"]];
//    [labelTitle setTextColor:[UIColor whiteColor]];
//    labelTitle.textAlignment = NSTextAlignmentCenter;
//    [parentView addSubview:labelTitle];
//    
//    //set elevator brand selection
//    UILabel *labelBrandKey = [[UILabel alloc] initWithFrame:CGRectMake(10, 65, 80, 30)];
//    labelBrandKey.text = @"品牌";
//    labelBrandKey.font = [UIFont fontWithName:@"System" size:SEARCH_FONT_SIZE];
//    labelBrandKey.textAlignment = NSTextAlignmentLeft;
//    [parentView addSubview:labelBrandKey];
//   
//    UILabel *labelBrandValue = [[UILabel alloc] initWithFrame:CGRectMake(90, 65, parentViewWidth - 90 - 5, 30)];
//    labelBrandValue.text = @"全部";
//    labelBrandValue.font = [UIFont fontWithName:@"System" size:SEARCH_FONT_SIZE];
//    labelBrandValue.textAlignment = NSTextAlignmentLeft;
//    labelBrandValue.tag = 1003;
//    
//    labelBrandValue.userInteractionEnabled = YES;
//    UIGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                              action:@selector(queryBrand)];
//    [labelBrandValue addGestureRecognizer:recognizer];
//    [parentView addSubview:labelBrandValue];
//    
//    
//    //set keywords selection
//    UILabel *labelKeywordsKey = [[UILabel alloc] initWithFrame:CGRectMake(10, 105, 80, 30)];
//    labelKeywordsKey.text = @"关键字";
//    labelKeywordsKey.font = [UIFont fontWithName:@"System" size:SEARCH_FONT_SIZE];
//    labelKeywordsKey.textAlignment = NSTextAlignmentLeft;
//    
//    [parentView addSubview:labelKeywordsKey];
//    
//    UITextField *textFieldKeywordsValue = [[UITextField alloc] initWithFrame:CGRectMake(90, 105, parentViewWidth - 90 - 5,
//                                                                            30)];
//    textFieldKeywordsValue.placeholder = @"多个关键字请以空格分隔";
//    textFieldKeywordsValue.font = [UIFont fontWithName:@"System" size:SEARCH_FONT_SIZE];
//    textFieldKeywordsValue.textAlignment = NSTextAlignmentLeft;
//    textFieldKeywordsValue.tag = 1004;
//    [parentView addSubview:textFieldKeywordsValue];
//    
//    //set button
//    UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(20, 155, parentViewWidth / 2 - 40,
//     
//                                                                     40)];
//    [btnCancel setBackgroundColor:[Utils getColorByRGB:@"#25B6ED"]];
//    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
//    [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btnCancel setTitleColor:[Utils getColorByRGB:@"f1f1f1"] forState:UIControlStateSelected];
//    
//    btnCancel.tag = 1001;
//    [btnCancel addTarget:self action:@selector(clickSearch:) forControlEvents:UIControlEventTouchUpInside];
//    [parentView addSubview:btnCancel];
//    
//    UIButton *btnConfirm = [[UIButton alloc] initWithFrame:CGRectMake(parentViewWidth / 2 + 20, 155,
//                                                                      parentViewWidth / 2 - 40, 40)];
//    [btnConfirm setBackgroundColor:[Utils getColorByRGB:@"#25B6ED"]];
//    [btnConfirm setTitle:@"确定" forState:UIControlStateNormal];
//    [btnConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btnConfirm setTitleColor:[Utils getColorByRGB:@"f1f1f1"] forState:UIControlStateSelected];
//    
//    btnConfirm.tag = 1002;
//    [btnConfirm addTarget:self action:@selector(clickSearch:) forControlEvents:UIControlEventTouchUpInside];
//    [parentView addSubview:btnConfirm];
//    
//}
//
///**
// *  click dialog button
// *
// *  @param sender <#sender description#>
// */
//- (void)clickSearch:(id)sender
//{
//    NSInteger tag = ((UIButton *)sender).tag;
//    if (1001 == tag)
//    {
//        UIView *view = [self.view viewWithTag:1000];
//        if (view != nil)
//        {
//            [view removeFromSuperview];
//        }
//    }
//    else if (1002 == tag)
//    {
//        UIView *view = [self.view viewWithTag:1000];
//        if (view != nil)
//        {
//            UILabel *labelBrand = [view viewWithTag:1003];
//            UITextField *tfKeywords = [view viewWithTag:1004];
//            
//            KnTitleListViewController *vc = [self.storyboard
//                                             instantiateViewControllerWithIdentifier:@"KnTitleListViewController"];
//            vc.mType = 10;
//            vc.brand = labelBrand.text;
//            vc.keywords = tfKeywords.text;
//            [self.navigationController pushViewController:vc animated:YES];
//            
//            [view removeFromSuperview];
//        }
//    }
//    else if (2001 == tag)   //dismiss brand selection dialog
//    {
//        UIView *view = [self.view viewWithTag:2000];
//        if (view != nil)
//        {
//            [view removeFromSuperview];
//        }
//        brandList->clear();
//        delete brandList;
//        brandList = NULL;
//    }
//}
//
///**
// *  show brand list dialog
// */
//- (void)showBrandDialog
//{
////    if(!brandList)
////    {
////        return;
////    }
//    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
//    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
//    
//    UIView *brandView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
//    brandView.tag = 2000;
//    [brandView setBackgroundColor:[UIColor clearColor]];
//    [self.view addSubview:brandView];
//    
//    CGFloat parentViewWidth = screenWidth - 60;
//    CGFloat parentViewHeight = screenHeight - 160;
//    
//    
//    
//    UIView *parentView = [[UIView alloc] initWithFrame:CGRectMake(30, 70, parentViewWidth, parentViewHeight)];
//    
//    
//    //parentView.layer.borderWidth = 3;
//    //parentView.layer.borderColor = [[UIColor blueColor] CGColor];
//    
//    //设置阴影
//    parentView.layer.shadowColor = [UIColor blackColor].CGColor;
//    parentView.layer.shadowOffset = CGSizeMake(4,4);
//    parentView.layer.shadowOpacity = 0.6;
//    parentView.layer.shadowRadius = 4;
//    
//    
//    [parentView setBackgroundColor:[UIColor whiteColor]];
//    [brandView addSubview:parentView];
//    
//    
//    
//    //alert title
//    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, parentViewWidth, 55)];
//    labelTitle.text = @"品牌选择";
//    [labelTitle setBackgroundColor:[Utils getColorByRGB:@"#25b6ed"]];
//    [labelTitle setTextColor:[UIColor whiteColor]];
//    labelTitle.textAlignment = NSTextAlignmentCenter;
//    [parentView addSubview:labelTitle];
//    
//    
//    //UITableView
//    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70,
//                                                                           parentViewWidth, parentViewHeight - 150) style:UITableViewStyleGrouped];
//    
//    [tableView setBackgroundColor:[UIColor whiteColor]];
//    //tableView.layer.borderWidth = 1;
//    //tableView.layer.borderColor = [[UIColor blueColor] CGColor];
//    
//    //取消顶部的黑线
//    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, -1)];
//    tableView.tableHeaderView = header;
//    
//    tableView.bounces = NO;
//    
//    tableView.dataSource = self;
//    tableView.delegate = self;
//    
//    [parentView addSubview:tableView];
//    
//    
//    //取消按钮
//    UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(0,
//                                                                     parentViewHeight - 50, parentViewWidth, 50)];
//    [btnCancel setBackgroundColor:[Utils getColorByRGB:@"#25b6ed"]];
//    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
//    [btnCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//    
//    btnCancel.tag = 2001;
//    [btnCancel addTarget:self action:@selector(clickSearch:) forControlEvents:UIControlEventTouchUpInside];
//    [parentView addSubview:btnCancel];
//}
//
///**
// *  query the brand list with async task
// *
// *  @param brand <#brand description#>
// */
//- (void)queryBrand
//{
//    NSString *dbDir = [NSHomeDirectory() stringByAppendingString:SQLITE_PATH];
//    NSString *dbPath = [dbDir stringByAppendingString:SQLITE_KN_NAME];
//    NSFileManager *fm = [NSFileManager defaultManager];
//    
//    if (![fm fileExistsAtPath:dbPath])
//    {
//        return;
//    }
//    const char *cdbPath = dbPath.UTF8String;
//    dispatch_queue_t queue = dispatch_queue_create("query_queue", NULL);
//    dispatch_async(queue, ^{
//    
//        brandList = cqueryBrand(cdbPath);
//        [self performSelectorOnMainThread:@selector(showBrandDialog) withObject:nil waitUntilDone:YES];
//    });
//    
//}
//
//
//#pragma mark -- UITableViewDataSource
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    if (brandList)
//    {
//        return brandList->size();
//    }
//    return 0;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *cellIdentifier = @"BrandCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    
//    if (nil == cell)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//        UILabel *labelBrand = [[UILabel alloc] init];
//        labelBrand.tag = 1;
//        [labelBrand setFrame:CGRectMake(20, 5, 100, 40)];
//        [cell.contentView addSubview:labelBrand];
//    }
//    
//    UILabel *labelContent = (UILabel *)[cell.contentView viewWithTag:1];
//    std::string cbrand = brandList->at(indexPath.row);
//    labelContent.text = [NSString stringWithUTF8String:cbrand.c_str()];
//    
//    return cell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 50;
//}
//
//#pragma mark -- UITableViewDelegate
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    
//    UILabel *labelBrand = (UILabel *)[cell viewWithTag:1];
//    
//    UIView *preView = [self.view viewWithTag:1000];
//    if (preView)
//    {
//        UILabel *labelBrandValue = [preView viewWithTag:1003];
//        if (labelBrandValue)
//        {
//            labelBrandValue.text = labelBrand.text;
//        }
//        
//    }
//    
//    UIView *view = [self.view viewWithTag:2000];
//    if (view != nil)
//    {
//        [view removeFromSuperview];
//    }
//    
//    if (brandList)
//    {
//        brandList->clear();
//        delete brandList;
//        brandList = NULL;
//    }
//    
//}


@end
