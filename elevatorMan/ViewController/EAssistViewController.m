//
//  EAssistViewController.m
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/26.
//
//

#import "EAssistViewController.h"

@interface EAssistViewController ()

@property (strong, nonatomic) UIWebView *webView;

@property (copy, nonatomic) NSString *urlInfo;

@end

@implementation EAssistViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self initView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (NSString *)urlInfo
{
    if (0 == _urlInfo.length)
    {
        _urlInfo = [NSString stringWithFormat:@"%@h5/yiZhuIndexPage", [Utils getIp]];
    }
    
    return _urlInfo;
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, self.screenWidth, self.screenHeight - 49 - 20)];
    _webView.scrollView.bounces = NO;
    
    
    NSString *url = [NSString stringWithFormat:@"%@?userId=%@", self.urlInfo, [User sharedUser].userId];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                            timeoutInterval:3.0];
    [_webView loadRequest:request];
    
    [self.view addSubview:_webView];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([self.webView canGoBack])
    {
        [self.webView goBack];
        
    }
   
    return NO;
}

@end
