//
//  MaintSubmitController.m
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/5.
//
//

#import "MaintSubmitController.h"
#import "MaintResultView.h"

#define IMAGE_PATH @"/tmp/maint/"

@interface MaintSubmitController () <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate,
        UIImagePickerControllerDelegate, MaintResultViewDelegate>

@property (strong, nonatomic) MaintResultView *resultView;

@property (copy, nonatomic) NSString *beforeName;

@property (copy, nonatomic) NSString *afterName;

@property (copy, nonatomic) NSString *curName;

@end

@implementation MaintSubmitController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"维保结果"];
    [self initView];
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];

    tableView.delegate = self;

    tableView.dataSource = self;

    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self.view addSubview:tableView];

    _resultView = [MaintResultView viewFromNib];

    _resultView.delegate = self;

    tableView.tableHeaderView = _resultView;

    //加载缓存文件
    [self loadBeforeCacheImage];
    [self loadAfterCacheImage];
}


/**
 加载维保前照片
 */
- (void)loadBeforeCacheImage
{
    NSString *path = [NSString stringWithFormat:@"%@%@", IMAGE_PATH, self.beforeName];
    NSString *filePath = [NSHomeDirectory() stringByAppendingString:path];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL exist = [fileManager fileExistsAtPath:filePath];

    if (exist)
    {
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        _resultView.imageBefore = image;
    }
}


/**
 加载维保后图片
 */
- (void)loadAfterCacheImage
{
    NSString *path = [NSString stringWithFormat:@"%@%@", IMAGE_PATH, self.afterName];
    NSString *filePath = [NSHomeDirectory() stringByAppendingString:path];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL exist = [fileManager fileExistsAtPath:filePath];

    if (exist)
    {
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        _resultView.imageAfter = image;
    }
}

- (NSString *)beforeName
{
    return [NSString stringWithFormat:@"%@_before.jpg", _maintInfo[@"id"]];
}

- (NSString *)afterName
{
    return [NSString stringWithFormat:@"%@_after.jpg", _maintInfo[@"id"]];
}

- (void)showPicker
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    [controller addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        [self pickPhoto];
    }]];

    [controller addAction:[UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        [self takePhoto];
    }]];

    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {

    }]];

    [self presentViewController:controller animated:YES completion:nil];

}

/**
 *  从本地选取照片
 */
- (void)pickPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];

    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;

    //设置选择后的图片可以编辑
    picker.allowsEditing = YES;

    [self showViewController:picker sender:self];
}

/**
 *  拍摄照片
 */
- (void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;

        //设置拍照后的图片可以编辑
        picker.allowsEditing = NO;
        picker.sourceType = sourceType;
        [self showViewController:picker sender:self];
    }
}

/**
 *  当选择一张图片后调用此方法
 *
 *  @param picker picker
 *  @param info info
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info
{

    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];

    //选择的是图片
    if ([type isEqualToString:@"public.image"])
    {

        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];

        CGSize size = CGSizeMake(360, 480);

        image = [ImageUtils imageWithImage:image scaledToSize:size];

        //上传到服务器
        //[self uploadRepairImage:image];

        //将图片转换为 NSData
        NSData *data;

        data = UIImageJPEGRepresentation(image, 0.5);

        if (0 == _curName.length)
        {
            return;
        }
        //将图片保存在本地
        NSString *dirPath = [NSHomeDirectory() stringByAppendingString:IMAGE_PATH];

        BOOL suc = [FileUtils writeFile:data Path:dirPath fileName:_curName];

        if ([_curName isEqualToString:self.beforeName])
        {
            _resultView.imageBefore = image;

        }
        else
        {
            _resultView.imageAfter = image;
        }

        if (suc)
        {
            NSLog(@"照片保存成功");

        }
        else
        {
            NSLog(@"照片保存失败");
        }

        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}


/**
 *  取消图片选择时调用
 *
 *  @param picker picker
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)delImage:(NSString *)name
{
    NSString *path = [NSString stringWithFormat:@"%@%@", IMAGE_PATH, name];
    NSString *dirPath = [NSHomeDirectory() stringByAppendingString:path];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL exist = [fileManager fileExistsAtPath:dirPath];

    if (exist)
    {
        NSError *error;
        BOOL suc = [fileManager removeItemAtPath:dirPath error:&error];

        NSLog(@"error:%@", error);

        if (suc)
        {
            NSLog(@"del successfully");
        }
        else
        {
            NSLog(@"del failed");
        }
    }
    else
    {
        NSLog(@"image does not exist");
    }
}

- (void)uploadBefore
{
    NSString *before = [NSString stringWithFormat:@"%@%@", IMAGE_PATH, self.beforeName];
    NSString *after = [NSString stringWithFormat:@"%@%@", IMAGE_PATH, self.afterName];
    NSString *dirBefore = [NSHomeDirectory() stringByAppendingString:before];
    NSString *dirAfter = [NSHomeDirectory() stringByAppendingString:after];

    NSFileManager *fileManager = [NSFileManager defaultManager];

    BOOL existBefore = [fileManager fileExistsAtPath:dirBefore];
    BOOL existAfter = [fileManager fileExistsAtPath:dirAfter];

    if (!existBefore)
    {
        [HUDClass showHUDWithLabel:@"请先获取维保前照片"];
        return;
    }

    if (!existAfter)
    {
        [HUDClass showHUDWithLabel:@"请现获取维保后照片"];
        return;
    }

    UIImage *beforeImage = [UIImage imageWithContentsOfFile:dirBefore];

    NSString *before64 = [Utils image2Base64:beforeImage];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"img"] = before64;

    [[HttpClient sharedClient] post:@"uploadImg" parameter:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *url = responseObject[@"body"][@"url"];

        [self uploadAfter:dirAfter url:url];
    }];
}

- (void)uploadAfter:(NSString *)after url:(NSString *)beforeUrl
{

    UIImage *afterImage = [UIImage imageWithContentsOfFile:after];

    NSString *before64 = [Utils image2Base64:afterImage];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"img"] = before64;

    [[HttpClient sharedClient] post:@"uploadImg" parameter:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *afterUrl = responseObject[@"body"][@"url"];

    }];
}

- (void)submit:(NSString *)before after:(NSString *)after
{
    NSString *remark = _resultView.tvContent.text;
    if (0 == remark.length)
    {
        [HUDClass showHUDWithLabel:@"请填写维保结果"];
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"maintOrderProcessId"] = _maintInfo[@"id"];
    params[@"maintUserFeedback"] = remark;
    params[@"beforeImg"] = before;
    params[@"afterImg"] = after;

    [[HttpClient sharedClient] post:@"editMaintOrderProcessWorkerFinish" parameter:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUDClass showHUDWithLabel:@"维保结果提交成功"];
        NSArray *array = self.navigationController.viewControllers;
        [self.navigationController popToViewController:array[array.count - 3] animated:YES];
    }];
}

#pragma mark - MaintResultViewDelegate

- (void)onClickSubmit
{
    NSString *remark = _resultView.tvContent.text;
    if (0 == remark.length)
    {
        [HUDClass showHUDWithLabel:@"请填写维保结果"];
        return;
    }
    [self uploadBefore];
}

- (void)onClickBeforeImage
{
    if (_resultView.hasBefore)
    {
        NSLog(@"预览");

    }
    else
    {
        self.curName = self.beforeName;
        [self showPicker];
    }
}

- (void)onClickAfterImage
{
    if (_resultView.hasAfter)
    {
        NSLog(@"预览");

    }
    else
    {
        self.curName = self.afterName;
        [self showPicker];
    }
}

- (void)onClickDelBefore
{
    [self delImage:self.beforeName];
}

- (void)onClickDelAfter
{
    [self delImage:self.afterName];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
