//
//  RepairSubmitController.m
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/7.
//
//

#import "RepairSubmitController.h"
#import "ImageViewDelView.h"

#define Image_Width 90

#define Image_Height 120

#define Image_Top 180

#define IMAGE_PATH @"/tmp/repair/"


@interface RepairSubmitController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) UITextView *tvContent;

@property (strong, nonatomic) NSMutableArray *arrayImage;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIButton *btnCheck;

@property (strong, nonatomic) UIButton *btnFinish;

@property (strong, nonatomic) NSMutableArray *arrayUrl;

@end

@implementation RepairSubmitController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"维修提交"];
    [self initView];
}

- (void)initView
{
    self.automaticallyAdjustsScrollViewInsets = NO;

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.screenWidth, self.screenHeight - 64)];
    [self.view addSubview:_scrollView];

    [self initDealView];
}

- (NSMutableArray *)arrayUrl
{
    if (!_arrayUrl)
    {
        _arrayUrl = [NSMutableArray array];
    }
    return _arrayUrl;
}


- (NSMutableArray *)arrayImage
{
    if (!_arrayImage)
    {
        _arrayImage = [NSMutableArray array];
    }

    return _arrayImage;
}

- (void)initDealView
{
    //处理意见  6 + 21 = 27
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 6, 100, 21)];

    label.font = [UIFont systemFontOfSize:14];
    label.text = @"处理结果";

    [_scrollView addSubview:label];

    //输入框 35 + 120 = 155
    _tvContent = [[UITextView alloc] initWithFrame:CGRectMake(8, 35, self.screenWidth - 16, 120)];

    _tvContent.backgroundColor = RGB(BG_GRAY);

    _tvContent.layer.masksToBounds = YES;

    _tvContent.layer.cornerRadius = 5;

    _tvContent.layer.borderWidth = 1;

    _tvContent.layer.borderColor = RGB(BG_GRAY).CGColor;

    [_scrollView addSubview:_tvContent];

    //现场照片 171 + 21 = 192
    UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(8, 171, 100, 21)];

    lable2.font = [UIFont systemFontOfSize:14];
    lable2.text = @"现场照片";

    [_scrollView addSubview:lable2];

    //拍照
    ImageViewDelView *imageView = [ImageViewDelView viewFromNib];

    [self addSubmitButton];

    [self addToArray:imageView];

}

- (void)addToArray:(ImageViewDelView *)imageView
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    dic[@"iv"] = imageView;

    [self.arrayImage addObject:dic];


    [self addImageViews];
}

- (void)addClickEvent
{
    __weak typeof(self) weakSelf = self;

    NSEnumerator *iterator = [self.arrayImage reverseObjectEnumerator];

    NSDictionary *dic = nil;

    while (dic = [iterator nextObject])
    {
        ImageViewDelView *iv = dic[@"iv"];

        if (iv.hasImage)
        {
            [iv setOnClickDel:^{
                [weakSelf deleteImageView:dic];
            }];

            [iv setOnClickImage:^{
                NSLog(@"预览");
            }];

        }
        else
        {
            [iv setOnClickImage:^{
                [weakSelf showPicker];
            }];

        }
    }
}

- (void)clearImageViews
{
    for (NSDictionary *dic in self.arrayImage)
    {
        ImageViewDelView *iv = dic[@"iv"];

        if (iv.superview)
        {
            [iv removeFromSuperview];
        }
    }
}

- (void)deleteImageView:(NSDictionary *)dic
{
    [self clearImageViews];

    [self.arrayImage removeObject:dic];

    [self addImageViews];
}

- (void)addImageViews
{
    [self clearImageViews];

    CGFloat space = (self.screenWidth - Image_Width * 3) / 4;

    for (NSInteger i = 0;
            i < self.arrayImage.count;
            i++)
    {

        NSInteger row = i / 3;

        NSInteger column = i % 3;

        CGFloat x = space + (Image_Width + space) * column;

        CGFloat y = Image_Top + 16 + (Image_Height + 16) * row;

        CGRect frame = CGRectMake(x, y, Image_Width, Image_Height);

        ImageViewDelView *imageView = [self.arrayImage[i] objectForKey:@"iv"];

        imageView.frame = frame;

        [_scrollView addSubview:imageView];
    }

    [self addClickEvent];

    //处理内容高度,包含提交按钮
    NSInteger rows = (self.arrayImage.count - 1) / 3;

    CGFloat height = Image_Top + 16 + (16 + Image_Height) * (rows + 1) + 16 + 26 + 16 + 26 + 16;

    _scrollView.contentSize = CGSizeMake(self.screenWidth, height);

    [self updateBtn];
}


- (void)addSubmitButton
{
    _btnCheck = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 26)];
    [_btnCheck setTitle:@"检修完成" forState:UIControlStateNormal];
    [_btnCheck setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnCheck setBackgroundColor:RGB(TITLE_COLOR)];
    _btnCheck.layer.masksToBounds = YES;
    _btnCheck.layer.cornerRadius = 5;
    _btnCheck.titleLabel.font = [UIFont systemFontOfSize:13];

    [_btnCheck addTarget:self action:@selector(check) forControlEvents:UIControlEventTouchUpInside];

    _btnCheck.center = CGPointMake(self.screenWidth / 2, _scrollView.contentSize.height - 16 - 26 - 16 - 13);

    [_scrollView addSubview:_btnCheck];

    _btnFinish = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 26)];
    [_btnFinish setTitle:@"维修完成" forState:UIControlStateNormal];
    [_btnFinish setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnFinish setBackgroundColor:RGB(TITLE_COLOR)];
    _btnFinish.layer.masksToBounds = YES;
    _btnFinish.layer.cornerRadius = 5;
    _btnFinish.titleLabel.font = [UIFont systemFontOfSize:13];

    [_btnFinish addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];

    _btnFinish.center = CGPointMake(self.screenWidth / 2, _scrollView.contentSize.height - 16 - 13);

    [_scrollView addSubview:_btnFinish];
}

- (void)updateBtn
{
    _btnCheck.center = CGPointMake(self.screenWidth / 2, _scrollView.contentSize.height - 16 - 26 - 16 - 13);

    _btnFinish.center = CGPointMake(self.screenWidth / 2, _scrollView.contentSize.height - 16 - 13);
}

- (void)check
{
    NSString *remark = _tvContent.text;
    if ( 0 == remark.length)
    {
        [HUDClass showHUDWithLabel:@"请填写检修结果"];
        return;
    }

    if (0 == self.arrayImage.count)
    {
        [HUDClass showHUDWithLabel:@"请先获取检修照片"];
        return;
    }

    [self uploadImage:0 state:5];
}

- (void)finish
{
    NSString *remark = _tvContent.text;
    if ( 0 == remark.length)
    {
        [HUDClass showHUDWithLabel:@"请填写维修结果"];
        return;
    }

    if (0 == self.arrayImage.count)
    {
        [HUDClass showHUDWithLabel:@"请先获取维修照片"];
        return;
    }

    [self uploadImage:0 state:6];
}


- (void)uploadImage:(NSInteger)index state:(NSInteger)state
{
    if (self.arrayImage.count <= index)
    {
        [self submitResult:state];
    }
    else
    {
        NSString *name = self.arrayImage[index][@"name"];
        NSString *path = [NSString stringWithFormat:@"%@%@", IMAGE_PATH, name];
        NSString *dirPath = [NSHomeDirectory() stringByAppendingString:path];

        UIImage *image = [UIImage imageWithContentsOfFile:dirPath];

        NSString *image64 = [Utils image2Base64:image];

        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"img"] = image64;

        [[HttpClient sharedClient] post:@"uploadImg" parameter:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *url = responseObject[@"body"][@"url"];
            [self.arrayUrl addObject:url];
            [self uploadImage:index + 1 state:state];
        }];
    }
}

- (void)submitResult:(NSInteger)state
{
    NSString *pictures = [self.arrayUrl componentsJoinedByString:@","];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"repairOrderProcessId"] = _taskInfo[@"id"];
    params[@"state"] = [NSString stringWithFormat:@"%ld", state];
    params[@"finishResult"] = _tvContent.text;
    params[@"pictures"] = pictures;

    [[HttpClient sharedClient] post:@"editRepairOrderProcessWorkerFinish" parameter:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUDClass showHUDWithLabel:@"结果提交成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }];

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

        //将图片转换为 NSData
        NSData *data;

        data = UIImageJPEGRepresentation(image, 0.5);

        //将图片保存在本地

        NSString *fileName = [self fileName];

        [self showPhoto:image fileName:fileName];

        NSString *dirPath = [NSHomeDirectory() stringByAppendingString:IMAGE_PATH];

        BOOL suc = [FileUtils writeFile:data Path:dirPath fileName:fileName];

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

- (void)showPhoto:(UIImage *)image fileName:(NSString *)name
{
    NSMutableDictionary *dic = self.arrayImage.lastObject;

    dic[@"name"] = name;

    ImageViewDelView *iv = dic[@"iv"];

    iv.image = image;

    //添加新的待拍照图片
    ImageViewDelView *imageView = [ImageViewDelView viewFromNib];

    [self addToArray:imageView];
}

- (NSString *)fileName
{
    long long seconds = [[NSDate date] timeIntervalSince1970];

    return [NSString stringWithFormat:@"%lld.jpg", seconds];
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

- (void)dealloc
{
    for (NSDictionary *dic in self.arrayImage)
    {
        NSString *name = dic[@"name"];

        if (0 == name.length)
        {
            return;
        }

        [self delImage:name];
    }
}

@end
