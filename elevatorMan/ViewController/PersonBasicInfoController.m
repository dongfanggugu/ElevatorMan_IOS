//
//  PersonBasicInfoController.m
//  elevatorMan
//
//  Created by 长浩 张 on 15/12/23.
//
//

#import <Foundation/Foundation.h>
#import "PersonBasicInfoController.h"
#import "FileUtils.h"
#import "ImageUtils.h"
#import "HttpClient.h"


#define ICON_PATH @"/tmp/person/"
#define ICON_TEMP @"person_temp.jpg"


#pragma mark - IconCell

@interface IconCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageViewIcon;

@end

@implementation IconCell

@end


#pragma mark - TextCell

@interface TextCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

@property (weak, nonatomic) IBOutlet UILabel *labelContent;

@end

@implementation TextCell


@end

#pragma mark - PersonBasicInfoController

@interface PersonBasicInfoController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) UIActionSheet *actionSheet;

@end


@implementation PersonBasicInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"基本资料"];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    //设置回退icon
    //[self setNavIcon];
    //self.navigationController.interactivePopGestureRecognizer.delegate = self;
}



//- (void)setNavIcon
//{
//    if (!self.navigationController)
//    {
//        return;
//    }
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
//    imageView.image = [UIImage imageNamed:@"back_normal"];
//    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popup)]];
//    
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:imageView];
//    self.navigationItem.leftBarButtonItem = item;
//}
//
//
//
//- (void)popup
//{
//    [self.navigationController popViewControllerAnimated:YES];
//    
//}
//
//
//- (void)setNavTitle:(NSString *)title
//{
//    if (!self.navigationController)
//    {
//        return;
//    }
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
//    label.text = title;
//    label.font = [UIFont fontWithName:@"System" size:17];
//    label.textColor = [UIColor whiteColor];
//    [label setTextAlignment:NSTextAlignmentCenter];
//    [self.navigationItem setTitleView:label];
//}


#pragma mark - TableView DataSource and Delegate

/**
 *  返回section数量
 *
 *  @param tableView <#tableView description#>
 *
 *  @return <#return value description#>
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


/**
 *  返回每个section rows
 *
 *  @param tableView <#tableView description#>
 *  @param section   <#section description#>
 *
 *  @return <#return value description#>
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (0 == section) {
        return 1;
    } else {
        return 5;
    }
}


/**
 *  为每一行添加内容
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 *
 *  @return <#return value description#>
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;

    if (0 == section) {
        IconCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IconCell"];

        //设置圆形
        cell.imageViewIcon.layer.masksToBounds = YES;
        cell.imageViewIcon.layer.cornerRadius = 30;
        [self setPersonIcon:cell.imageViewIcon];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userInteractionEnabled = YES;
        UIGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMenu)];
        [cell addGestureRecognizer:recognizer];
        return cell;

    } else if (1 == section) {
        TextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextCell"];

        if (0 == row) {
            cell.labelTitle.text = @"用户名";
            cell.labelContent.text = [User sharedUser].userName;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellEditingStyleNone;
            NSMutableDictionary *views = [NSMutableDictionary dictionaryWithCapacity:1];
            [views setObject:cell.labelContent forKey:@"content"];
            [cell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[content]-60-|"
                                                                         options:0 metrics:nil views:views]];
        } else if (1 == row) {
            cell.labelTitle.text = @"姓名";
            cell.labelContent.text = [User sharedUser].name;
        } else if (2 == row) {
            cell.labelTitle.text = @"性别";
            cell.labelContent.text = [User sharedUser].sex.integerValue == 0 ? @"女" : @"男";
        } else if (3 == row) {
            cell.labelTitle.text = @"年龄";
            cell.labelContent.text = [NSString stringWithFormat:@"%ld", [User sharedUser].age.integerValue];
        } else if (4 == row) {
            cell.labelTitle.text = @"手机号码";
            cell.labelContent.text = [User sharedUser].tel;
        }

        return cell;
    }
    return nil;
}


/**
 *  设置tableview 行高
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 *
 *  @return <#return value description#>
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        return 80;
    }

    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (1 == section) {

        if (0 == row) {
            return;
        }
        UIViewController *destinationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ModifyDetail"];
        if (1 == row) {
            [destinationVC setValue:@"name" forKey:@"enterType"];
        } else if (2 == row) {
            [destinationVC setValue:@"sex" forKey:@"enterType"];
        } else if (3 == row) {
            [destinationVC setValue:@"age" forKey:@"enterType"];
        } else if (4 == row) {
            [destinationVC setValue:@"tel" forKey:@"enterType"];
        }
        [self.navigationController pushViewController:destinationVC animated:YES];
    }
}

#pragma mark - deal with icon image


/**
 *  设置图片
 *
 *  @param imageView <#imageView description#>
 */
- (void)setPersonIcon:(UIImageView *)imageView {

    if (0 == [User sharedUser].picUrl.length) {
        return;
    }
    NSString *dirPath = [NSHomeDirectory() stringByAppendingString:ICON_PATH];
    NSString *fileName = [FileUtils getFileNameFromUrlString:[User sharedUser].picUrl];
    NSString *filePath = [dirPath stringByAppendingString:fileName];

    if ([FileUtils existInFilePath:filePath]) {

        UIImage *icon = [UIImage imageWithContentsOfFile:filePath];
        imageView.image = icon;
    }
}

#pragma mark -- take the photo

/**
 *  选择拍照或者选取图片
 */
- (void)showMenu {

    self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍摄", @"选取", nil];
    [self.actionSheet showInView:self.view];
}

/**
 *  ActionSheet按钮
 *
 *  @param actionSheet <#actionSheet description#>
 *  @param buttonIndex <#buttonIndex description#>
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == self.actionSheet.cancelButtonIndex) {
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

/**
 *  拍摄照片
 */
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

/**
 *  从本地选取照片
 */
- (void)pickPhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];

    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;

    //设置选择后的图片可以编辑
    picker.allowsEditing = YES;

    [self showViewController:picker sender:self];
}

/**
 *  当选择一张图片后调用此方法
 *
 *  @param picker <#picker description#>
 *  @param info   <#info description#>
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info {


    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];

    //选择的是图片
    if ([type isEqualToString:@"public.image"]) {

        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];

        CGSize size = CGSizeMake(120, 120);

        image = [ImageUtils imageWithImage:image scaledToSize:size];

        //将图片转换为 NSData
        NSData *data;

        data = UIImageJPEGRepresentation(image, 0.5);


        //将图片保存为person_temp.jpg
        NSString *dirPath = [NSHomeDirectory() stringByAppendingString:ICON_PATH];


        [FileUtils writeFile:data Path:dirPath fileName:ICON_TEMP];


        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];

        //上传图片
        NSString *filePath = [dirPath stringByAppendingString:ICON_TEMP];
        NSString *base64String = [ImageUtils image2Base64From:filePath];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:base64String forKey:@"pic"];

        [[HttpClient sharedClient] view:self.view post:@"updateLoadPic" parameter:params success:^(AFHTTPRequestOperation *operation, id responseObject) {

            NSDictionary *responseBody = [responseObject objectForKey:@"body"];
            NSString *iconUrlString = [responseBody objectForKey:@"pic"];
            NSString *fileName = [FileUtils getFileNameFromUrlString:iconUrlString];

            //重命名选择的新图片
            [FileUtils renameFileNameInPath:dirPath oldName:ICON_TEMP toNewName:fileName];

            //更新本地存储的头像url
            [User sharedUser].picUrl = iconUrlString;
            [[User sharedUser] setUserInfo];

            //设置页面展示的头像
            IconCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell.imageViewIcon.image = image;
        }];
    }
}


/**
 *  取消图片选择时调用
 *
 *  @param picker <#picker description#>
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
