//
//  EAssistViewController.m
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/26.
//
//

#import "EAssistViewController.h"
#import <WebKit/WebKit.h>

@interface EAssistViewController () <UIGestureRecognizerDelegate, WKNavigationDelegate, WKUIDelegate>

@property (strong, nonatomic) WKWebView *webView;

@property (copy, nonatomic) NSString *urlInfo;

@end

@implementation EAssistViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
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
    UIView *statusBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, 20)];
    statusBar.backgroundColor = RGB(TITLE_COLOR);
    [self.view addSubview:statusBar];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 20, self.screenWidth, self.screenHeight - 49 - 20)];
    
    _webView.navigationDelegate = self;
    
    _webView.UIDelegate = self;
    
    
    NSString *url = [NSString stringWithFormat:@"%@?userId=%@", self.urlInfo, [User sharedUser].userId];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                            timeoutInterval:3.0];
    [_webView loadRequest:request];
    
    [self.view addSubview:_webView];
    
    NSSet *websiteDataTypes = [NSSet setWithArray:@[WKWebsiteDataTypeDiskCache,
                                                    WKWebsiteDataTypeOfflineWebApplicationCache,
                                                    WKWebsiteDataTypeMemoryCache,
                                                    WKWebsiteDataTypeLocalStorage,
                                                    WKWebsiteDataTypeCookies,
                                                    WKWebsiteDataTypeSessionStorage,
                                                    WKWebsiteDataTypeIndexedDBDatabases,
                                                    WKWebsiteDataTypeWebSQLDatabases]];
    
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes
                                               modifiedSince:dateFrom completionHandler:^{
                                               }];
}

- (void)goBack
{
   [_webView evaluateJavaScript:@"goBack()" completionHandler:nil];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([self.webView canGoBack])
    {
        [self goBack];
    }
    
   
    return NO;
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"url:%@", webView.URL.absoluteString);
    NSString *url = webView.URL.absoluteString;
    
    if ([url containsString:@"yiZhuIndexPage"])
    {
        self.tabBarController.tabBar.hidden = NO;
        webView.frame = CGRectMake(0, 20, self.screenWidth, self.screenHeight - 20 - 49);
    }
    else
    {
        self.tabBarController.tabBar.hidden = YES;
        webView.frame = CGRectMake(0, 20, self.screenWidth, self.screenHeight - 20);
    }
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
}


- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    //    DLOG(@"msg = %@ frmae = %@",message,frame);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
