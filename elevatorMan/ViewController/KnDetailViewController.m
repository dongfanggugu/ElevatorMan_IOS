//
//  KnDetailViewController.m
//  elevatorMan
//
//  Created by 长浩 张 on 16/3/29.
//
//

#import <Foundation/Foundation.h>
#import "KnDetailViewController.h"
#import <sqlite3.h>
#import "HUDClass.h"

@interface KnDetailViewController()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) MBProgressHUD *hud;

@property sqlite3 *db;

@end

@implementation KnDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavTitle:@"电梯百科"];
    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.bouncesZoom = NO;
    
    if ([self openDB])
    {
        
        [self asyncQuery];
    }
}


/**
 *  query the db async
 */
- (void)asyncQuery
{
    self.hud = [HUDClass showLoadingHUD:self.view];
    dispatch_queue_t queue = dispatch_queue_create("query_queue", NULL);
    
    dispatch_async(queue, ^{
        [self query];
    });
}

- (void)loadData:(NSString *)content
{
    if (self.hud != nil)
    {
        [HUDClass hideLoadingHUD:self.hud];
    }
    if (content != nil)
    {
        [self.webView loadHTMLString:content baseURL:nil];
    }
}

/**
 *  query the db
 */
- (void)query
{
    NSString *sql = [NSString stringWithFormat:@"select content from knowledge where \
                     id='%@'", self.mId];
    
    const char *cSql = sql.UTF8String;
    
    sqlite3_stmt *stmp = NULL;
    NSString *content;
    
    if (sqlite3_prepare_v2(self.db, cSql, -1, &stmp, NULL) == SQLITE_OK)
    {
        if (sqlite3_step(stmp) == SQLITE_ROW)
        {
            const unsigned char *cContent = sqlite3_column_text(stmp, 0);
            content = [NSString stringWithCString:(const char *)cContent encoding:NSUTF8StringEncoding];
        }
    }
    [self closeDB];
    [self performSelectorOnMainThread:@selector(loadData:) withObject:content waitUntilDone:YES];
}

- (NSString *)stringFromCharPtr:(const unsigned char *)array
{
    return [NSString stringWithCString:(char *)array encoding:NSUTF8StringEncoding];
}

/**
 *  open the knowledge db sqlite
 *
 *  @return <#return value description#>
 */
- (BOOL)openDB
{
    NSString *dbDir = [NSHomeDirectory() stringByAppendingString:SQLITE_PATH];
    NSString *dbPath = [dbDir stringByAppendingString:SQLITE_KN_NAME];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if (![fm fileExistsAtPath:dbPath])
    {
        return NO;
    }
    const char *cdbPath = dbPath.UTF8String;
    NSInteger result = sqlite3_open(cdbPath, &_db);
    
    if (result == SQLITE_OK)
    {
        return YES;
    }
    
    return NO;
}

- (void)closeDB
{
    if (self.db)
    {
        sqlite3_close(self.db);
    }
}

@end
