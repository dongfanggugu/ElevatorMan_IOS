//
//  ProMaintenanceDetail.m
//  elevatorMan
//
//  Created by 长浩 张 on 15/12/17.
//
//

#import <Foundation/Foundation.h>
#import "ProMaintenanceDetail.h"
#import "HttpClient.h"
#import "ImageUtils.h"

@interface ProMaintenanceDetail()

@property (weak, nonatomic) IBOutlet UILabel *labelNum;

@property (weak, nonatomic) IBOutlet UILabel *labelAddress;

@property (weak, nonatomic) IBOutlet UILabel *labelDate;

@property (weak, nonatomic) IBOutlet UILabel *labelType;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewDeviceCode;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewMainBefore;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewMainAfter;

@property (strong, nonatomic) NSString *enterFlag;

@property (strong, nonatomic) NSString *mainId;

@property (strong, nonatomic) NSString *liftNum;

@property (strong, nonatomic) NSString *address;

@property (strong, nonatomic) NSString *mainDate;

@property (strong, nonatomic) NSString *mainType;

@property (strong, nonatomic) NSMutableDictionary *imageViewDic;

@property (strong, nonatomic) UIImageView *ivOverView;

@end


@implementation ProMaintenanceDetail


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置图片加载的初始化数据
    self.imageViewDic = [NSMutableDictionary dictionaryWithCapacity:1];
    self.imageViewDeviceCode.tag = 0;
    self.imageViewMainBefore.tag = 1;
    self.imageViewMainAfter.tag = 2;
    
    //初始化视图
    [self initView];
    [self getPicUrlByMainId:self.mainId];
    self.tabBarController.tabBar.hidden = YES;
}


/**
 *  初始化视图
 */
- (void)initView {
    
    if ([self.enterFlag isEqualToString:@"finish"]) {
        UIButton *btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        [btnSubmit setTitle:@"提交" forState:UIControlStateNormal];
        [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnSubmit.titleLabel.font = [UIFont fontWithName:@"System" size:15.0f];
        [btnSubmit addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btnSubmit];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    [self setTitleString:@"维保详情"];
    self.labelNum.text = self.liftNum;
    self.labelAddress.text = self.address;
    self.labelDate.text = self.mainDate;
    self.labelType.text = [self getDescriptionByType:self.mainType];
}


/**
 *  根据维保id获取维保提交的照片路径
 *
 *  @param liftId mainId description
 */
- (void)getPicUrlByMainId:(NSString *)mainId {
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param setObject:mainId forKey:@"mainId"];
    
    [[HttpClient sharedClient] view:self.view post:@"getMainDetail" parameter:param
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                NSLog(@"responseObject:%@", responseObject);
                                NSArray *picArray = [[responseObject objectForKey:@"body"] objectForKey:@"mainPics"];
                                
                                if (picArray.count != 3) {
                                    return;
                                }
                                
                                NSString *deviceCodeUrl = picArray[0];
                                
                                [self setImageView:self.imageViewDeviceCode WithUrl:deviceCodeUrl];
                                
                                NSString *beforeMainUrl = picArray[1];
                                [self setImageView:self.imageViewMainBefore WithUrl:beforeMainUrl];
                                
                                
                                NSString *afterMainUrl = picArray[2];
                                [self setImageView:self.imageViewMainAfter WithUrl:afterMainUrl];
                            }];
    
}


/**
 *  异步下载图片，并添加到UIImageView，保存到本地缓存目录
 *
 *  @param urlString <#urlString description#>
 *  @param imageView <#imageView description#>
 */
- (void)getPictureFromUrlString:(NSString *)urlString imageview:(UIImageView *) imageView
                      cachePath:(NSString *)cachePath fileName:(NSString *)fileName {
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (data.length > 0 && nil == connectionError) {
            
            [self setImageView:imageView data:data url:urlString CachePath:cachePath fileName:fileName];
        
        } else if (connectionError != nil) {
            NSLog(@"download picture error = %@", connectionError);
        }
    }];
}

/**
 *  根据类型返回维保类型的描述
 *
 *  @param type <#type description#>
 *
 *  @return <#return value description#>
 */
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

/**
 *  设置标题
 *
 *  @param title <#title description#>
 */
- (void)setTitleString:(NSString *)title {
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    labelTitle.text = title;
    labelTitle.font = [UIFont fontWithName:@"System" size:17];
    labelTitle.textColor = [UIColor whiteColor];
    [self.navigationItem setTitleView:labelTitle];
}

/**
 *  维保完成确认提交
 */
- (void)submit {
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
    param[@"mainId"] = self.mainId;
    param[@"verify"] = [NSNumber numberWithInt:2];
    
    [[HttpClient sharedClient] view:self.view post:@"verifyMainPlan" parameter:param
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                [self.navigationController popViewControllerAnimated:YES];
                            }];
}


/**
 *  根据url获取文件名
 *
 *  @param url <#url description#>
 *
 *  @return <#return value description#>
 */
- (NSString *)getFileNameByUrl:(NSString *)url {
    NSString *fileName = nil;
    NSArray *array = [url componentsSeparatedByString:@"/"];
    if (array != nil && array.count > 0){
        fileName = array[array.count - 1];
    }
    return fileName;
}

/**
 *  从本地获取图片文件
 *
 *  @param filePath <#filePath description#>
 *
 *  @return <#return value description#>
 */
- (UIImage *)getImageFromLocalByPath:(NSString *)filePath {
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    return image;
}

/**
 *  获取本地缓存目录
 *
 *  @return <#return value description#>
 */
- (NSString *)getLocalCacheDir {
    NSString *privateDir = [[NSString alloc] initWithFormat:@"/tmp/Maintenance/%@/", self.liftNum];
    
    NSString *cacheDir = [NSHomeDirectory() stringByAppendingString:privateDir];
    return cacheDir;
}

/**
 *  设置ImageView显示的图片
 *
 *  @param imageView <#imageView description#>
 *  @param url       <#url description#>
 */
- (void)setImageView:(UIImageView *)imageView WithUrl:(NSString *)url {
    NSString *fileName = [self getFileNameByUrl:url];
    NSString *cachePath = [self getLocalCacheDir];
    
    NSString *filePath = [[NSString alloc] initWithFormat:@"%@%@", cachePath, fileName];
    
    UIImage *originImage = [self getImageFromLocalByPath:filePath];
    
    if (originImage != nil) {
        CGSize size = CGSizeMake(90, 120);
        UIImage *image = [ImageUtils imageWithImage:originImage scaledToSize:size];
        imageView.image = image;
        
        [self.imageViewDic setObject:filePath forKey:[NSNumber numberWithInteger:imageView.tag]];
        
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *overView = [[UITapGestureRecognizer alloc]
                                            initWithTarget:self action:@selector(showOverView:)];
        [imageView addGestureRecognizer:overView];
        return;
    }
    
    [self getPictureFromUrlString:url imageview:imageView cachePath:cachePath fileName:fileName];
}

/**
 *  主线程更新UI回调方法，由于只能传递一个参数，所以，使用dictionary将参数包装一下
 *
 *  @param params <#params description#>
 */
- (void)setImageViewMainTreadCallbackByParams:(NSDictionary *)params {
    UIImageView *imageView = [params objectForKey:@"view"];
    NSString *urlString = [params objectForKey:@"url"];
    [self setImageView:imageView WithUrl:urlString];
}

/**
 *  现将文件写入到本地缓存，然后设置ImageView显示图像
 *
 *  @param imageView <#imageView description#>
 *  @param data      <#data description#>
 *  @param urlString <#urlString description#>
 *  @param cachePath <#cachePath description#>
 *  @param fileName  <#fileName description#>
 */
- (void)setImageView:(UIImageView *)imageView data:(NSData *)data url:(NSString *)urlString
CachePath:(NSString *)cachePath fileName:(NSString *)fileName  {
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString *filePath = [[NSString alloc] initWithFormat:@"%@%@", cachePath, fileName];
    BOOL suc = [manager createFileAtPath:filePath contents:data attributes:nil];
    NSLog(@"write to imge:%@", suc ? @"Successed" : @"Failed");
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    [params setObject:imageView forKey:@"view"];
    [params setObject:urlString forKey:@"url"];
    
    //将更新ImageView图片的功能放到主线程执行
    [self performSelectorOnMainThread:@selector(setImageViewMainTreadCallbackByParams:) withObject:params waitUntilDone:NO];
    
}


/**
 *  显示图片的预览
 *
 *  @param gestureRecognizer <#gestureRecognizer description#>
 */
- (void)showOverView:(UIGestureRecognizer *)gestureRecognizer {
    UIView *view = [gestureRecognizer view];
    NSInteger tag = view.tag;
    NSString *filePath = [self.imageViewDic objectForKey:[NSNumber numberWithLong:tag]];
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

/**
 *  隐藏预览图
 */
- (void)hideOverView {
    [self.ivOverView removeFromSuperview];
}
@end
