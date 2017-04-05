//
//  FinishedReportViewController.m
//  elevatorMan
//
//  Created by Cove on 15/6/26.
//
//

#import "FinishedReportViewController.h"
#import "HttpClient.h"
#import "AlarmViewController.h"
#import "ImageUtils.h"


@interface FinishedReportViewController ()<UITextFieldDelegate, UIAlertViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *savedTF;

@property (weak, nonatomic) IBOutlet UITextField *injuredTF;

@property (weak, nonatomic) IBOutlet UITextView *remarkTV;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (weak, nonatomic) IBOutlet UIImageView *ivSubmit;

@property (weak, nonatomic) IBOutlet UIButton *btnDel;

@property (strong, nonatomic) UIImageView *ivOverView;

@end

@implementation FinishedReportViewController

- (void)finishedReport
{
    //判断
    if ([[_savedTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] ||
        [[_injuredTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
    {
        [HUDClass showHUDWithLabel:@"请填写完整信息" view:self.view];
        return;
    }
    
    if (_btnDel.hidden)
    {
        [HUDClass showHUDWithLabel:@"请先拍摄电梯合格证" view:self.view];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[self image2Base64] forKey:@"pic"];
    
    [[HttpClient sharedClient] view:self.view post:@"updateLoadCert" parameter:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *url = [[responseObject objectForKey:@"body"] objectForKey:@"pic"];
        
        NSLog(@"url:%@", url);
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
        [dic setObject:_alarmId forKey:@"alarmId"];
        [dic setObject:@"3" forKey:@"state"];
        [dic setObject:_injuredTF.text forKey:@"injureCount"];
        [dic setObject:_savedTF.text forKey:@"savedCount"];
        [dic setObject:_remarkTV.text forKey:@"result"];
        [dic setObject:url forKey:@"pic"];
        
        [[HttpClient sharedClient] view:self.view post:@"saveProcessRecord" parameter:dic
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您已经完成此次应急救援,感谢您的参与!"
                                                                                   delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                    [alert show];
                                    
                                } failed:^(id responseObject) {
                                    NSString *rspMsg = [[responseObject objectForKey:@"head"] objectForKey:@"rspMsg"];
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:rspMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                    [alert show];
                                }];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"救援完成"];
    [self initView];
}

- (void)initView
{
    _submitBtn.layer.masksToBounds = YES;
    _submitBtn.layer.cornerRadius = 5;
    [_submitBtn addTarget:self action:@selector(finishedReport) forControlEvents:UIControlEventTouchUpInside];
    
    _ivSubmit.userInteractionEnabled = YES;
    [_ivSubmit addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePhoto)]];
    
    _btnDel.hidden = YES;
    [_btnDel addTarget:self action:@selector(delImage) forControlEvents:UIControlEventTouchUpInside];
    [self loadImage];
}


/**
 拍摄照片
 **/
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

/** 当选择一张图片后调用此方法**/
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    NSString *fileName = [self getFileName];
    if (0 == fileName.length)
    {
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
        
        NSString *fileDir = [[NSString alloc] initWithFormat:@"Documents/%@", _alarmId];
        NSLog(@"file dir:%@", fileDir);
        NSString *documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:fileDir];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //清除目录中文件
        [self deleteFileByPath:documentsPath];
        
        //将图片保存在沙盒中
        [fileManager createDirectoryAtPath:documentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[documentsPath stringByAppendingString:fileName] contents:data attributes:nil];
        
        //NSString *filePath = [[NSString alloc] initWithFormat:@"%@%@", documentsPath, fileName];
        
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
        [self loadImage];
    }
}


/** 显示预览 **/
- (void)showOverView
{
    NSString *filePath = [[NSString alloc] initWithFormat:@"Documents/%@/%@_submit.jpg", _alarmId, _alarmId];
    
    filePath = [NSHomeDirectory() stringByAppendingPathComponent:filePath];
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    
    
    if (nil == _ivOverView) {
        _ivOverView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _ivOverView.userInteractionEnabled = YES;
        UITapGestureRecognizer *hideView = [[UITapGestureRecognizer alloc]
                                            initWithTarget:self action:@selector(hideOverView)];
        [self.ivOverView addGestureRecognizer:hideView];
    }
    
    _ivOverView.image = image;
    [self.view addSubview:self.ivOverView];
}

/** 隐藏预览图 **/
- (void)hideOverView {
    [self.ivOverView removeFromSuperview];
}

/**
 获取文件名称
 **/
- (NSString *)getFileName
{
    NSString *fileName = nil;
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    
    fileName = [NSString stringWithFormat:@"/%@_submit.jpg", _alarmId];
    
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

/** 删除文件 **/
- (void)delImage
{
    NSString *filePath = [[NSString alloc] initWithFormat:@"Documents/%@/%@_submit.jpg", _alarmId, _alarmId];
    
    filePath = [NSHomeDirectory() stringByAppendingPathComponent:filePath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL exist = [fileManager fileExistsAtPath:filePath];
    
    if (exist)
    {
        NSError *error;
        [fileManager removeItemAtPath:filePath error:&error];
        [_ivSubmit setImage:[UIImage imageNamed:@"icon_photo_submit"]];
        _btnDel.hidden = YES;
        [_ivSubmit addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePhoto)]];
    }
    
}

- (void)loadImage
{
    NSString *filePath = [[NSString alloc] initWithFormat:@"Documents/%@/%@_submit.jpg", _alarmId, _alarmId];
    filePath = [NSHomeDirectory() stringByAppendingPathComponent:filePath];
    NSFileManager *manager = [NSFileManager defaultManager];
    
    BOOL exist = [manager fileExistsAtPath:filePath];
    
    if (exist)
    {
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        
        if (image)
        {
            [_ivSubmit setImage:image];
            _btnDel.hidden = NO;
            [_ivSubmit addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOverView)]];
        }
    }
}

/**
 删除指定路径下的文件
 **/
- (void)deleteFileByPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL exist = [fileManager fileExistsAtPath:path];
    
    if (exist) {
        NSError *error;
        [fileManager removeItemAtPath:path error:&error];
    }
}

/** 图片转换为base64码 **/
- (NSString *)image2Base64
{
    NSString *filePath = [[NSString alloc] initWithFormat:@"Documents/%@/%@_submit.jpg", _alarmId, _alarmId];
    filePath = [NSHomeDirectory() stringByAppendingPathComponent:filePath];
    
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    NSData *data = UIImageJPEGRepresentation(image, 1);
    NSString *base64Code = [data base64Encoding];
    return base64Code;
}

#pragma mark - UITextFiledDelegate
//当用户按下return键或者按回车键，keyboard消失
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (ALARM_RECEIVED == alertView.tag || ALARM_ASSIGNED == alertView.tag)
    {
        if (1 == buttonIndex)
        {
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Worker" bundle:nil];
            AlarmViewController *controller = [board instantiateViewControllerWithIdentifier:@"alarm_process"];
            controller.alarmId = self.notifyAlarmId;
            
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
    else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
 
}
@end
