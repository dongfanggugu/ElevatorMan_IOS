//
//  UIRegisterThreeViewController.m
//  elevatorMan
//
//  Created by 长浩 张 on 15/12/4.
//
//

#import <Foundation/Foundation.h>
#import "UIRegisterThreeViewController.h"
#import "HttpClient.h"
#import <CommonCrypto/CommonDigest.h>
#import "ImageUtils.h"


@interface UIRegisterThreeViewController()<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageViewBack;

@property (weak, nonatomic) IBOutlet UIView *viewTitle;

@property (strong, nonatomic) UIActionSheet *actionSheet;

@property (weak, nonatomic) IBOutlet UIImageView *ivCard;

@property (weak, nonatomic) IBOutlet UIImageView *ivOperation;

@property (weak, nonatomic) IBOutlet UIImageView *ivMix;

@property (weak, nonatomic) IBOutlet UIButton *btnDelCard;

@property (weak, nonatomic) IBOutlet UIButton *btnDelOperation;

@property (weak, nonatomic) IBOutlet UIButton *btnDelMix;

@property (weak, nonatomic) IBOutlet UIImageView *ivOverView;

@property (strong, nonatomic) NSMutableDictionary *imageViewDic;

- (IBAction)pressedConfirm:(id)sender;



@end

@implementation UIRegisterThreeViewController

@synthesize imageViewDic;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setNavTitle:@"维修工注册"];
    
    imageViewDic = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    //拍摄照片
    self.ivCard.userInteractionEnabled = YES;
    self.ivCard.tag = 0;
    self.ivCard.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.ivCard addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(showMenu:)]];
    
    self.ivOperation.userInteractionEnabled = YES;
    self.ivOperation.tag = 1;
    [self.ivOperation addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                            initWithTarget:self action:@selector(showMenu:)]];
    
    self.ivMix.userInteractionEnabled = YES;
    self.ivMix.tag = 2;
    [self.ivMix addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                      initWithTarget:self action:@selector(showMenu:)]];
}

///**
// 点击后退按钮
// **/
//- (void)pressedBack {
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

/** 显示拍照和选取选项 **/
- (void)showMenu:(UIGestureRecognizer *)gestureRecognizer {
    
    UIImageView *imageView = (UIImageView *)[gestureRecognizer view];
    NSInteger tag = imageView.tag;
    NSLog(@"tag:%ld", tag);
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍摄", @"选取", nil];
    self.actionSheet.tag = tag;
    [self.actionSheet showInView:self.view];
}


/**ActionSheet 菜单点击回调方法**/
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == self.actionSheet.cancelButtonIndex) {
        NSLog(@"action sheet cancel");
    }
    
    switch (buttonIndex) {
        case 0:
            [self takePhoto];
            break;
            
        case 1:
            [self pickPhoto];
            break;
    }
}

/**拍摄照片**/
- (void)takePhoto {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        
        //设置拍照后的图片可以编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self showViewController:picker sender:self];
    }
}

/**从本地选取照片**/
- (void)pickPhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    
    //设置选择后的图片可以编辑
    picker.allowsEditing = YES;
    
    [self showViewController:picker sender:self];
}

/** 当选择一张图片后调用此方法**/
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    NSString *fileName = [self getFileNameBy:self.actionSheet.tag];
    NSLog(@"file name:%@", fileName);
    if (0 == fileName.length) {
        return;
    }
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    NSLog(@"type:%@", type);
    
    //选择的是图片
    if ([type isEqualToString:@"public.image"]) {
        
        NSLog(@"public.image");
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        CGSize size = CGSizeMake(600, 800);
        
        image = [self imageWithImage:image scaledToSize:size];
        
        //将图片转换为 NSData
        NSData *data;
        
        data = UIImageJPEGRepresentation(image, 0.5);
        
        //        if (UIImagePNGRepresentation(image) == nil) {
        //            data = UIImageJPEGRepresentation(image, 0.2);
        //            NSLog(@"jpg data size:%ld", data.length);
        //        } else {
        //            data = UIImagePNGRepresentation(image);
        //            NSLog(@"png data size:%ld", data.length);
        //        }
        
        NSString *documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //将图片保存为image.jpg
        [fileManager createDirectoryAtPath:documentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[documentsPath stringByAppendingString:fileName] contents:data attributes:nil];
        
        NSString *filePath = [[NSString alloc] initWithFormat:@"%@%@", documentsPath, fileName];
        
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        [imageViewDic setObject:filePath forKey:[NSNumber numberWithLong:self.actionSheet.tag]];
        
        [self setImage:image tag:self.actionSheet.tag reset:NO];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"取消选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/** 显示预览 **/
- (void)showOverView:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"show overview");
    UIView *view = [gestureRecognizer view];
    NSInteger tag = view.tag;
    NSString *filePath = [imageViewDic objectForKey:[NSNumber numberWithLong:tag]];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    long long size = [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    
    float sizeK = size / 1024.0;
    
    NSLog(@"file size:%f", sizeK);
    
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    
    self.ivOverView.image = image;
    self.ivOverView.hidden = NO;
    
    self.ivOverView.userInteractionEnabled = YES;
    UITapGestureRecognizer *hideView = [[UITapGestureRecognizer alloc]
                                        initWithTarget:self action:@selector(hideOverView)];
    [self.ivOverView addGestureRecognizer:hideView];
}

/** 隐藏预览图 **/
- (void)hideOverView {
    self.ivOverView.hidden = YES;
}


/** 根据标签值返回文件名称 **/
- (NSString *)getFileNameBy:(NSInteger)tag {
    NSString *fileName = nil;
    switch (tag) {
        case 0:
            fileName = @"/card.jpg";
            break;
        case 1:
            fileName = @"/operation.jpg";
            break;
        case 2:
            fileName = @"/mix.jpg";
    }
    return fileName;
}

/** 获取图片后处理imageView **/
- (void)setImage:(UIImage *)image tag:(NSInteger)tag reset:(BOOL)reset {
    UIImageView *imageView = nil;
    UIButton *button = nil;
    switch (tag) {
        case 0:
            imageView = self.ivCard;
            button = self.btnDelCard;
            [button setTag:0];
            break;
            
        case 1:
            imageView = self.ivOperation;
            button = self.btnDelOperation;
            [button setTag:1];
            break;
            
        case 2:
            imageView = self.ivMix;
            button = self.btnDelMix;
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
                                                                                action:@selector(showMenu:)]];
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


/** 按照给定尺寸压缩图片 **/
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

/** 图片转换为base64码 **/
- (NSString *)image2Base64From:(NSString *)path {
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    NSData *data = UIImageJPEGRepresentation(image, 1);
    NSString *base64Code = [data base64Encoding];
    return base64Code;
}

/**
 提交新用户
 **/
- (IBAction)pressedConfirm:(id)sender {
    
    //三张照片必须全部都拍照完毕
    if (imageViewDic.count != 3) {
        [HUDClass showHUDWithLabel:@"请拍摄完成三张照片!" view:self.view];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    
    NSMutableArray *pics = [NSMutableArray arrayWithCapacity:1];
    [pics addObject:[self image2Base64From:[imageViewDic objectForKey:[NSNumber numberWithInt:0]]]];
    [pics addObject:[self image2Base64From:[imageViewDic objectForKey:[NSNumber numberWithInt:1]]]];
    [pics addObject:[self image2Base64From:[imageViewDic objectForKey:[NSNumber numberWithInt:2]]]];
    
    
    NSInteger sex = 0;
    if ([self.sex isEqualToString:@"男"]) {
        sex = 1;
    }
    
    
    [params setObject:self.userName forKey:@"loginname"];
    [params setObject:[self md5:self.password] forKey:@"password"];
    [params setObject:self.name forKey:@"name"];
    [params setObject:[NSNumber numberWithLong:sex] forKey:@"sex"];
    [params setObject:[NSNumber numberWithLong:[self.age integerValue]] forKey:@"age"];
    [params setObject:self.operation forKey:@"operationCard"];
    [params setObject:self.branch forKey:@"branchName"];
    [params setObject:self.branchId forKey:@"branchId"];
    
    [params setObject:self.cellphone forKey:@"tel"];
    [params setObject:@"1" forKey:@"operateState"];
    [params setObject:self.city forKey:@"city"];
    [params setObject:self.cardId forKey:@"idNumber"];
    [params setObject:pics forKey:@"pics"];
    
    [[HttpClient sharedClient] view:self.view post:@"registerRepair" parameter:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [HUDClass showHUDWithLabel:@"注册成功,请稍后查看您的短信确认管理员审核结果" view:self.view];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

//MD5加密
- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (void)dealloc {
    NSLog(@"deal loc 3");
}


@end
