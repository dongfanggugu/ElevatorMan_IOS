//
//  PlanViewController.m
//  elevatorMan
//
//  Created by 长浩 张 on 15/12/10.
//
//

#import <Foundation/Foundation.h>
#import "PlanViewController.h"
#import "DownPicker.h"
#import "HttpClient.h"
#import "ImageUtils.h"
#import "DatePickerDialog.h"
#import "PaintViewController.h"
#import "UIImageView+AFNetworking.h"

@interface PlanViewController() <UINavigationControllerDelegate, UIImagePickerControllerDelegate, DatePickerDialogDelegate>
{
    BOOL _hasSubmit;
}

@property (weak, nonatomic) IBOutlet UILabel *labelCode;

@property (weak, nonatomic) IBOutlet UILabel *labelAddress;

@property (weak, nonatomic) IBOutlet UILabel *labelMainDate;

@property (weak, nonatomic) IBOutlet UILabel *labelMainType;

@property (weak, nonatomic) IBOutlet UILabel *labelPlanDate;

@property (weak, nonatomic) IBOutlet UITextField *labelPlanType;

@property (strong, nonatomic) UIDatePicker *datePicker;

@property (strong, nonatomic) UIView *datePickerView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView1;

@property (weak, nonatomic) IBOutlet UIImageView *imageView2;

@property (weak, nonatomic) IBOutlet UIImageView *imageView3;

@property (weak, nonatomic) IBOutlet UIButton *btnDel1;

@property (weak, nonatomic) IBOutlet UIButton *btnDel2;

@property (weak, nonatomic) IBOutlet UIButton *btnDel3;

@property (weak, nonatomic) UIBarButtonItem *btnSumbit;


@property (strong, nonatomic) DownPicker *typePicker;

@property (strong, nonatomic) NSMutableDictionary *imageViewDic;

@property (strong, nonatomic) UIImageView *ivOverView;

@property (weak, nonatomic) IBOutlet UIButton *btnHelp;

@property NSInteger curSelectIndex;

- (IBAction)popDatePicker:(id)sender;

- (void)submit;

@end

@implementation PlanViewController

@synthesize imageViewDic;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _hasSubmit = NO;
    [self setNavRightWithText:@"提交"];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_hasSubmit) {
        [self deleteFileAndCleanDic];
    }
}
- (void)onClickNavRight
{
    [self submit];
}

/**
 根据进入的flag展示不同的页面
 **/
- (void)initView
{
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.bounces = NO;
    
    if ([_flag isEqualToString:@"add"]) {
        
        //[self setTitleString:@"计划制定"];
        [self setNavTitle:@"计划制定"];
        
        self.labelCode.text = self.liftNum;
        self.labelAddress.text = self.address;
        self.labelMainDate.text = (0 == self.mainDate.length ? @"无" : self.mainDate);
        self.labelMainType.text = (0 == self.mainType.length ? @"无" : [self getDescriptionByType:self.mainType]);
        
        self.labelPlanDate.text = [Utils stringFromDate:[NSDate date]];
        self.labelPlanType.text = @"半月保";
        
        NSArray *typeArray = [[NSArray alloc] initWithObjects:@"半月保", @"月保", @"季度保", @"半年保", @"年保", nil];
        self.typePicker = [[DownPicker alloc] initWithTextField:self.labelPlanType withData:typeArray];
        
        [self.typePicker setToolbarDoneButtonText:@"确定"];
        [self.typePicker setToolbarCancelButtonText:@"取消"];
        
    } else if ([_flag isEqualToString:@"complete"]) {
        [self setNavTitle:@"电梯维保"];
        self.labelCode.text = self.liftNum;
        self.labelAddress.text = self.address;
        self.labelMainDate.text = (0 == self.mainDate.length ? @"无" : self.mainDate);
        self.labelMainType.text = (0 == self.mainType.length ? @"无" : [self getDescriptionByType:self.mainType]);
        
        self.labelPlanDate.text = self.planMainDate;
        self.labelPlanType.text = [self getDescriptionByType:self.planMainType];
        
        self.imageViewDic = [NSMutableDictionary dictionaryWithCapacity:1];
        
        self.imageView1.tag = 0;
        self.imageView1.userInteractionEnabled =  YES;
        [self.imageView1 addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                           initWithTarget:self action:@selector(takePhoto:)]];
        self.imageView2.tag = 1;
        self.imageView2.userInteractionEnabled =  YES;
        [self.imageView2 addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(takePhoto:)]];
        self.imageView3.tag = 2;
        self.imageView3.userInteractionEnabled =  YES;
        [self.imageView3 addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(takePhoto:)]];
        
        [self loadImageFile];
        
        [self.labelPlanType setEnabled:NO];
        
    } else if ([_flag isEqualToString:@"edit"]) {
        [self setNavTitle:@"计划修改"];
        
        self.labelCode.text = self.liftNum;
        self.labelAddress.text = self.address;
        self.labelMainDate.text = (0 == self.mainDate.length ? @"无" : self.mainDate);
        self.labelMainType.text = (0 == self.mainType.length ? @"无" : [self getDescriptionByType:self.mainType]);
        
        self.labelPlanDate.text = self.planMainDate;
        self.labelPlanType.text = [self getDescriptionByType:self.planMainType];
        
        NSArray *typeArray = [[NSArray alloc] initWithObjects:@"半月保", @"月保", @"季度保", @"半年保", @"年保", nil];
        self.typePicker = [[DownPicker alloc] initWithTextField:self.labelPlanType withData:typeArray];
        
        [self.typePicker setToolbarDoneButtonText:@"确定"];
        [self.typePicker setToolbarCancelButtonText:@"取消"];
        
        [self.imageView1 removeFromSuperview];
        [self.imageView2 removeFromSuperview];
        [self.imageView3 removeFromSuperview];
        
        //[self.btnHelp removeFromSuperview];
    }
}

/**
 弹出时间选择框
 **/
- (IBAction)popDatePicker:(id)sender {
    
    DatePickerDialog *dialog = [DatePickerDialog viewFromNib];
    
    dialog.delegate = self;
    
    [dialog show];
}

#pragma mark - DatePickerDialogDelegate

- (void)onPickerDate:(NSDate *)date
{
    _labelPlanDate.text = [Utils stringFromDate:date];
}

- (void)submit
{
   
    if ([self.flag isEqualToString:@"add"]) {
        [self addPlan];
        
    } else if ([self.flag isEqualToString:@"edit"]) {
        [self modifyPlan];
        
    } else if ([self.flag isEqualToString:@"complete"]) {
    
        [self completePlan];
    }
}

- (void)showSignAlert
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有设置您的个人签名,\n请到个人中心->设置->我的签名中设置" preferredStyle:UIAlertControllerStyleAlert];
    
//    [controller addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self jumpPaint];
//    }]];
    
    [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
}

- (void)jumpPaint
{
    PaintViewController *controller = [[PaintViewController alloc] init];
    
    [self.navigationController pushViewController:controller animated:YES];
}
/**根据类型返回维保类型的描述**/
- (NSString *)getDescriptionByType:(NSString *)type {
    NSString *description = nil;
    if ([type isEqualToString:@"hm"]) {
        description = @"半月保";
    } else if ([type isEqualToString:@"m"]) {
        description = @"月保";
    } else if ([type isEqualToString:@"s"]) {
        description = @"季度保";
    } else if ([type isEqualToString:@"hy"]) {
        description = @"半年保";
    } else if ([type isEqualToString:@"y"]) {
        description = @"年保";
    }
    return description;
}

- (NSString *)getTypeByDescription:(NSString *)description {
    NSString *type = nil;
    if ([description isEqualToString:@"半月保"]) {
        type = @"hm";
    } else if ([description isEqualToString:@"月保"]) {
        type = @"m";
    } else if ([description isEqualToString:@"季度保"]) {
        type = @"s";
    } else if ([description isEqualToString:@"半年保"]) {
        type = @"hy";
    } else if ([description isEqualToString:@"年保"]) {
        type = @"y";
    }
    return type;
}

/**
 拍摄照片
 **/
- (void)takePhoto:(UIGestureRecognizer *)gestureRecognizer
{
    
    UIImageView *imageView = (UIImageView *)[gestureRecognizer view];
    self.curSelectIndex = imageView.tag;
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        
        //设置拍照后的图片可以编辑
        picker.allowsEditing = NO;
        picker.sourceType = sourceType;
        [self showViewController:picker sender:self];
    }
}

/** 当选择一张图片后调用此方法**/
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    NSString *fileName = [self getFileName];
    if (0 == fileName.length) {
        return;
    }
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //选择的是图片
    if ([type isEqualToString:@"public.image"]) {
        
        NSLog(@"public.image");
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        CGSize size = CGSizeMake(600, 800);
        
        image = [self imageWithImage:image scaledToSize:size];
        
        //将图片转换为 NSData
        NSData *data;
        
        data = UIImageJPEGRepresentation(image, 0.5);
        
        NSString *fileDir = [[NSString alloc] initWithFormat:@"Documents/%@/%ld", self.liftNum, self.curSelectIndex];
        NSLog(@"file dir:%@", fileDir);
        NSString *documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:fileDir];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //清除目录中文件
        [self deleteFileByPath:documentsPath];
        
        //将图片保存在沙盒中
        [fileManager createDirectoryAtPath:documentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[documentsPath stringByAppendingString:fileName] contents:data attributes:nil];
        
        NSString *filePath = [[NSString alloc] initWithFormat:@"%@%@", documentsPath, fileName];
        
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        [self.imageViewDic setObject:filePath forKey:[NSNumber numberWithLong:self.curSelectIndex]];
        
        [self setImage:image tag:self.curSelectIndex reset:NO];
    }
}

- (NSString *)getFileName
{
    NSString *fileName = nil;
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    
    long long dTime = [[NSNumber numberWithDouble:time] longLongValue];
    
    fileName = [NSString stringWithFormat:@"/%llu.jpg", dTime];
    
    return fileName;
}

/** 按照给定尺寸压缩图片 **/
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

/** 图片转换为base64码 **/
- (NSString *)image2Base64From:(NSString *)path
{
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    NSData *data = UIImageJPEGRepresentation(image, 1);
    NSString *base64Code = [data base64Encoding];
    return base64Code;
}

/** 获取图片后处理imageView **/
- (void)setImage:(UIImage *)image tag:(NSInteger)tag reset:(BOOL)reset {
    UIImageView *imageView = nil;
    UIButton *button = nil;
    switch (tag) {
        case 0:
            imageView = self.imageView1;
            button = self.btnDel1;
            [button setTag:0];
            break;
            
        case 1:
            imageView = self.imageView2;
            button = self.btnDel2;
            [button setTag:1];
            break;
            
        case 2:
            imageView = self.imageView3;
            button = self.btnDel3;
            [button setTag:2];
            break;
    }
    
    if (nil == imageView || nil == button) {
        return;
    }

    imageView.image = [ImageUtils imageWithImage:image scaledToSize:CGSizeMake(90, 120)];
    
    [button addTarget:self action:@selector(delImage:) forControlEvents:UIControlEventTouchUpInside];
    imageView.userInteractionEnabled = YES;
    
    //如果是删除照片后设置位默认图片，则把删除按钮隐藏，同时设置点击触发事件为显示菜单
    if (reset) {
        button.hidden = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(takePhoto:)]];
    } else {
        button.hidden = NO;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(showOverView:)]];
    }
    
}

/** 删除文件 **/
- (void)delImage:(id)sender {
    
    NSInteger tag = ((UIButton *)sender).tag;
    NSLog(@"button tag:%ld", tag);
    
    NSString *filePath = [imageViewDic objectForKey:[NSNumber numberWithLong:tag]];
    NSLog(@"delete image path:%@", filePath);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL exist = [fileManager fileExistsAtPath:filePath];
    
    if (exist) {
        NSError *error;
        [fileManager removeItemAtPath:filePath error:&error];
        [imageViewDic removeObjectForKey:[NSNumber numberWithLong:tag]];
        NSLog(@"imageview dictionary size:%ld", imageViewDic.count);
        if (0 == tag) {
            [self setImage:[UIImage imageNamed:@"card_id.png"] tag:tag reset:YES];
        } else if (1 == tag) {
            [self setImage:[UIImage imageNamed:@"operation.png"] tag:tag reset:YES];
        } else if (2 == tag) {
            [self setImage:[UIImage imageNamed:@"mix.png"] tag:tag reset:YES];
        }
    }
    
}

/** 显示预览 **/
- (void)showOverView:(UIGestureRecognizer *)gestureRecognizer {
    UIView *view = [gestureRecognizer view];
    NSInteger tag = view.tag;
    NSString *filePath = [imageViewDic objectForKey:[NSNumber numberWithLong:tag]];
    NSFileManager *manager = [NSFileManager defaultManager];
    long long size = [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    
    float sizeK = size / 1024.0;
    
    NSLog(@"file size:%f", sizeK);
    
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    
    
    if (nil == self.ivOverView) {
        self.ivOverView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.ivOverView.userInteractionEnabled = YES;
        UITapGestureRecognizer *hideView = [[UITapGestureRecognizer alloc]
                                        initWithTarget:self action:@selector(hideOverView)];
        [self.ivOverView addGestureRecognizer:hideView];
    }
    
    self.ivOverView.image = image;
    [self.view addSubview:self.ivOverView];
}

/** 隐藏预览图 **/
- (void)hideOverView {
    [self.ivOverView removeFromSuperview];
}

/**
 制定计划
 **/
- (void)addPlan {
    NSString *planDate = self.labelPlanDate.text;
    NSString *planType = [self getTypeByDescription:self.labelPlanType.text];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:self.liftId forKey:@"id"];
    [param setValue:planDate forKey:@"planTime"];
    [param setValue:planType forKey:@"mainType"];
    
    [[HttpClient sharedClient] view:self.view post:@"newMainPlan" parameter:param
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)modifyPlan {
    NSString *planDate = self.labelPlanDate.text;
    NSString *planType = [self getTypeByDescription:self.labelPlanType.text];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:self.liftId forKey:@"id"];
    [param setValue:planDate forKey:@"planTime"];
    [param setValue:planType forKey:@"mainType"];
    
    [[HttpClient sharedClient] view:self.view post:@"updateMainPlan" parameter:param
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)completePlan
{
    NSString *signUrl = [User sharedUser].signUrl;
    
    if (0 == signUrl.length) {
        [self showSignAlert];
        return;
    }
    
    if (self.imageViewDic.count != 3) {
        [HUDClass showHUDWithLabel:@"请拍摄三张照片!" view:self.view];
        return;
    }
    
    //三张图片的文件名称
    NSString *imageFileName1 = [self getFileNameFromPath:[self.imageViewDic objectForKey:[NSNumber numberWithInt:0]]];
    NSString *imageFileName2 = [self getFileNameFromPath:[self.imageViewDic objectForKey:[NSNumber numberWithInt:1]]];
    NSString *imageFileName3 = [self getFileNameFromPath:[self.imageViewDic objectForKey:[NSNumber numberWithInt:2]]];
    
    NSArray *fileNameArray = [[NSArray alloc] initWithObjects:imageFileName1, imageFileName2, imageFileName3, nil];
    
    //三张图片的BASE64编码
    NSString *base64Image1 = [self image2Base64From:[self.imageViewDic objectForKey:[NSNumber numberWithInt:0]]];
    NSString *base64Image2 = [self image2Base64From:[self.imageViewDic objectForKey:[NSNumber numberWithInt:1]]];
    NSString *base64Image3 = [self image2Base64From:[self.imageViewDic objectForKey:[NSNumber numberWithInt:2]]];
                              
    NSArray *imageArray = [[NSArray alloc] initWithObjects:base64Image1, base64Image2, base64Image3, nil];
    
    
    NSString *planDate = self.labelPlanDate.text;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setValue:self.liftId forKey:@"id"];
    [param setValue:planDate forKey:@"mainTime"];
    [param setValue:fileNameArray forKey:@"photoFileName"];
    [param setValue:imageArray forKey:@"photoBase64"];
    
    [[HttpClient sharedClient] view:self.view post:@"finishMain" parameter:param
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                [self afterComplete];
                                _hasSubmit = YES;
                            }];
}


- (void)afterComplete
{
    [self setNavRightWithText:@""];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, 100)];
    
    //footerView.backgroundColor = [UIColor redColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, 100)];
    
    [footerView addSubview:imageView];
    
    [imageView setImageWithURL:[NSURL URLWithString:[User sharedUser].signUrl]];
    
    
    [self.tableView setTableFooterView:imageView];
}



/**
 根据路径获取文件名称
 **/
- (NSString *)getFileNameFromPath:(NSString *)path {
    NSArray *array = [path componentsSeparatedByString:@"/"];
    NSInteger size = array.count;
    
    return [array objectAtIndex:size - 1];
}


/**
 删除指定路径下的文件
 **/
- (void)deleteFileByPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL exist = [fileManager fileExistsAtPath:path];
    
    if (exist) {
        NSError *error;
        [fileManager removeItemAtPath:path error:&error];
    }
}

/**
 删除拍照的文件
 **/
- (void)deleteFileAndCleanDic {
    for (int i = 0; i < self.imageViewDic.count; i++) {
        [self deleteFileByPath:[self.imageViewDic objectForKey:[NSNumber numberWithInt:i]]];
    }
    [self.imageViewDic removeAllObjects];
}

- (void)loadImageFile {
    for (int i = 0; i < 3; i++) {
        NSString *fileDir = [NSHomeDirectory() stringByAppendingPathComponent:
                             [[NSString alloc] initWithFormat:@"Documents/%@/%d", self.liftNum, i]];
        NSString *fileName = [self getFileNameInPath:fileDir];
        if (fileName.length != 0) {
            NSString *imageFile = [fileDir stringByAppendingFormat:@"/%@", fileName];
            [self.imageViewDic setObject:imageFile forKey:[NSNumber numberWithInt:i]];
            [self setImageViewFromPath:imageFile tag:i];
        }
    }
}

- (void)setImageViewFromPath:(NSString *)imagePath tag:(NSInteger)tag {
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    if (image != nil) {
        [self setImage:image tag:tag reset:NO];
    }
}

/**
 获取指定路径下的第一个文件
 **/
- (NSString *)getFileNameInPath:(NSString *)path {
    NSString *fileName = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileArray = [fileManager contentsOfDirectoryAtPath:path error:nil];
    NSLog(@"file count:%ld", fileArray.count);
    if (fileArray != nil && fileArray.count > 0) {
        fileName = [fileArray objectAtIndex:0];
    }
    NSLog(@"fileName:%@", fileName);
    return fileName;
}

///**
// 删除指定目录下的文件
// **/
//- (void)cleanFilesFromDir:(NSString *)path {
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSArray *fileArray = [fileManager contentsOfDirectoryAtPath:path error:nil];
//    for (int i = 0; i < fileArray.count; i++) {
//        NSString *filePath = [path stringByAppendingFormat:@"/%@", [fileArray objectAtIndex:i]];
//        [self deleteFileByPath:filePath];
//    }
//}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_flag isEqualToString:@"add"] || [_flag isEqualToString:@"edit"]) {
        return 6;
        
    } else {
        return 7;
        
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (1 == indexPath.row) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth - 8 - 100 - 8 - 8, 0)];
        
        label.text = _address;
        
        label.font = [UIFont systemFontOfSize:14];
        
        label.numberOfLines = 0;
        
        [label sizeToFit];
        
        return label.frame.size.height + 10 + 10;
        
    } else if (6 == indexPath.row) {
        return 188;
    
    } else {
        return 44;
    }

}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 100;
//}

@end
