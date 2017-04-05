//
//  KnTitleListViewController.m
//  elevatorMan
//
//  Created by 长浩 张 on 16/3/29.
//
//

#import <Foundation/Foundation.h>
#import "KnTitleListViewController.h"
#import "KnDetailViewController.h"
#import <sqlite3.h>
#import "../../chorstar/chorstar/Chorstar.h"


#pragma mark -- KnowledgeCell

@interface KnowledgeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

@property (weak, nonatomic) IBOutlet UILabel *labelKeywords;


@end


@implementation KnowledgeCell

@end

#pragma mark -- KnowledgeInfo

@interface KnowledgeInfo : NSObject

@property (strong, nonatomic) NSString *knId;

@property (strong, nonatomic) NSString *title;

@property (strong, nonatomic) NSString *keywords;


@end

@implementation KnowledgeInfo

+ (KnowledgeInfo *)getKnowledge:(NSString *)knId title:(NSString *)title keywords:(NSString *)keywords
{
    KnowledgeInfo *knowledge = [[KnowledgeInfo alloc] init] ;
    knowledge.knId = knId;
    knowledge.title = title;
    knowledge.keywords = keywords;
    
    return knowledge;
}

@end



#pragma mark -- KntitleListViewController

@interface KnTitleListViewController()
{
    std::vector<CKnowledgeInfo *> *knowledgeList;
}

@property (strong, nonatomic) NSMutableArray *knList;

@property sqlite3 *db;

@end


@implementation KnTitleListViewController


- (void)dealloc
{
    if (knowledgeList)
    {
        for (std::vector<CKnowledgeInfo *>::iterator iter = knowledgeList->begin();
             iter != knowledgeList->end(); iter++)
        {
            delete *iter;
            *iter = NULL;
        }
        
        delete knowledgeList;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle];
    self.knList = [[NSMutableArray alloc] init];
    
    if (10 == self.mType)
    {
        [self queryWithSelection];
    }
    else
    {
        if ([self openDB])
        {
            [self asyncQuery];
        }
    }
    
}

/**
 *  setting the title with the type
 */
- (void)setTitle
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    label.text = [self getType];
    label.font = [UIFont fontWithName:@"System" size:17];
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
}

- (void)queryWithSelection
{
    NSString *dbDir = [NSHomeDirectory() stringByAppendingString:SQLITE_PATH];
    NSString *dbPath = [dbDir stringByAppendingString:SQLITE_KN_NAME];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if (![fm fileExistsAtPath:dbPath])
    {
        return;
    }
    const char *cdbPath = dbPath.UTF8String;
    dispatch_queue_t queue = dispatch_queue_create("query_queue", NULL);
    dispatch_async(queue, ^{
        
        knowledgeList = cqueryBySelection(cdbPath, self.brand.UTF8String, self.keywords.UTF8String);
        [self performSelectorOnMainThread:@selector(loadTableView) withObject:nil waitUntilDone:YES];
    });
}

/**
 *  get the type string from type code
 *
 *  @return <#return value description#>
 */
- (NSString *)getType
{
    NSString *type;
    
    if (1 == self.mType)
    {
        type = @"常见问题";
    }
    else if (2 == self.mType)
    {
        type = @"操作手册";
    }
    else if (3 == self.mType)
    {
        type = @"故障码";
    }
    else if (4 == self.mType)
    {
        type = @"安全法规";
    }
    else if (10 == self.mType)
    {
        type = @"搜索结果";
    }
    
    return type;
    
}

/**
 *  query the db async
 */
- (void)asyncQuery
{
    dispatch_queue_t queue = dispatch_queue_create("query_queue", NULL);
    
    dispatch_async(queue, ^{
        [self query];
        [self performSelectorOnMainThread:@selector(loadTableView) withObject:nil waitUntilDone:YES];
    });
}

- (void)loadTableView
{
    [self.tableView reloadData];
}

/**
 *  query the db
 */
- (void)query
{
    NSString *type = [self getType];
    NSString *sql = [NSString stringWithFormat:@"select id, title, keywords from knowledge where \
                     kntype='%@'", type];
    const char *cSql = sql.UTF8String;
    
    sqlite3_stmt *stmp = NULL;
    
    if (sqlite3_prepare_v2(self.db, cSql, -1, &stmp, NULL) == SQLITE_OK)
    {
        while (sqlite3_step(stmp) == SQLITE_ROW)
        {
            const unsigned char *kId = sqlite3_column_text(stmp, 0);
            const unsigned char *title = sqlite3_column_text(stmp, 1);
            const unsigned char *keywords = sqlite3_column_text(stmp, 2);
            KnowledgeInfo *knowledge = [KnowledgeInfo getKnowledge:[self stringFromCharPtr:kId]
                                                             title:[self stringFromCharPtr:title]
                                                          keywords:[self stringFromCharPtr:keywords]];
            [self.knList addObject:knowledge];
        }
        sqlite3_finalize(stmp);
    }
    
    [self closeDB];
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


#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (10 == self.mType)
    {
        if (knowledgeList)
        {
            return knowledgeList->size();
        }
    }
    else
    {
        return self.knList.count;
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KnowledgeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KnowledgeCell"];
    if (10 == self.mType)
    {
        CKnowledgeInfo *info = knowledgeList->at(indexPath.row);
        cell.labelTitle.text = [NSString stringWithUTF8String:info->getTitle().c_str()];
        cell.labelKeywords.text = [NSString stringWithUTF8String:info->getKeywords().c_str()];
    }
    else
    {
        KnowledgeInfo *knowledge = self.knList[indexPath.row];
        cell.labelTitle.text = knowledge.title;
        cell.labelKeywords.text = knowledge.keywords;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark -- UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    KnDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"KnDetailViewController"];
    
    if (10 == self.mType)
    {
        CKnowledgeInfo *info = knowledgeList->at(indexPath.row);
        vc.mId = [NSString stringWithUTF8String:info->getKnId().c_str()];
    }
    else
    {
        KnowledgeInfo *knowledge = self.knList[indexPath.row];
        vc.mId = knowledge.knId;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
