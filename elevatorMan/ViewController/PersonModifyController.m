//
//  PersonModifyController.m
//  elevatorMan
//
//  Created by 长浩 张 on 15/12/24.
//
//

#import <Foundation/Foundation.h>
#import "PersonModifyController.h"
#import "DownPicker.h"
#import "Utils.h"
#import "HttpClient.h"


@interface PersonModifyController ()

@property (strong, nonatomic) NSString *enterType;

@property (weak, nonatomic) IBOutlet UITextField *textFieldContent;

@property (strong, nonatomic) DownPicker *downPicker;

@end


@implementation PersonModifyController

@synthesize enterType;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setTitleRight];
    //设置左右边框，看起来美观
    UIView *padView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 5)];
    self.textFieldContent.leftView = padView;
    self.textFieldContent.leftViewMode = UITextFieldViewModeAlways;

    self.textFieldContent.rightView = padView;
    self.textFieldContent.rightViewMode = UITextFieldViewModeAlways;

    [self initView];
}

/**
 *  初始化视图
 */
- (void)initView {

    if ([enterType isEqualToString:@"operation"]) {
        [self setTitleString:@"操作证号"];
        self.textFieldContent.text = [User sharedUser].operation;
    } else if ([enterType isEqualToString:@"name"]) {
        [self setTitleString:@"姓名"];
        self.textFieldContent.text = [User sharedUser].name;
    } else if ([enterType isEqualToString:@"sex"]) {
        [self setTitleString:@"性别"];
        NSInteger sexValue = [User sharedUser].sex.integerValue;
        self.textFieldContent.text = sexValue == 0 ? @"女" : @"男";
        NSArray *sexArray = [NSArray arrayWithObjects:@"男", @"女", nil];
        self.downPicker = [[DownPicker alloc] initWithTextField:self.textFieldContent withData:sexArray];
        [self.downPicker setToolbarDoneButtonText:@"完成"];
        [self.downPicker setToolbarCancelButtonText:@"取消"];
        //[self.view addSubview:downPicker];
    } else if ([enterType isEqualToString:@"age"]) {
        [self setTitleString:@"年龄"];
        self.textFieldContent.text = [NSString stringWithFormat:@"%ld", [User sharedUser].age.integerValue];
    } else if ([enterType isEqualToString:@"tel"]) {
        [self setTitleString:@"手机号码"];
        self.textFieldContent.text = [User sharedUser].tel;
    }
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
 *  设置标题栏右侧
 */
- (void)setTitleRight {
    UIButton *btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [btnSubmit setTitle:@"提交" forState:UIControlStateNormal];
    [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnSubmit.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnSubmit addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btnSubmit];
    self.navigationItem.rightBarButtonItem = rightItem;
}

/**
 *  提交到服务器
 */
- (void)submit {
    NSString *content = self.textFieldContent.text;
    if (0 == content.length) {
        [HUDClass showHUDWithLabel:@"输入不能为空,请重新输入!" view:self.view];
        return;
    }
    NSString *name = [User sharedUser].name;
    NSNumber *age = [User sharedUser].age;
    NSNumber *sex = [User sharedUser].sex;
    NSString *operationCard = [User sharedUser].operation == nil ? @"" : [User sharedUser].operation;
    NSString *tel = [User sharedUser].tel;

    if ([enterType isEqualToString:@"operation"]) {
        operationCard = content;

    } else if ([enterType isEqualToString:@"name"]) {
        name = content;

    } else if ([enterType isEqualToString:@"sex"]) {
        if ([content isEqualToString:@"男"]) {
            sex = [NSNumber numberWithInt:1];
        } else {
            sex = [NSNumber numberWithInt:0];
        }

    } else if ([enterType isEqualToString:@"age"]) {
        if (![Utils isLegalAge:content]) {
            [HUDClass showHUDWithLabel:@"请输入合法的年龄" view:self.view];
            return;
        }
        age = [NSNumber numberWithInteger:[content integerValue]];

    } else if ([enterType isEqualToString:@"tel"]) {
        if (![Utils isCorrectPhoneNumberOf:content]) {
            [HUDClass showHUDWithLabel:@"请输入合法的电话号码" view:self.view];
            return;
        }
        tel = content;
    }

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];

    [params setObject:name forKey:@"name"];
    [params setObject:age forKey:@"age"];
    [params setObject:sex forKey:@"sex"];
    [params setObject:operationCard forKey:@"operationCard"];
    [params setObject:tel forKey:@"tel"];

    __weak PersonModifyController *weakSelf = self;

    [[HttpClient sharedClient] view:self.view post:@"editUser" parameter:params
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {

                                //更新本地存储的个人信息
                                [User sharedUser].name = name;
                                [User sharedUser].age = age;
                                [User sharedUser].sex = sex;
                                [User sharedUser].operation = operationCard;
                                [User sharedUser].tel = tel;
                                [[User sharedUser] setUserInfo];
                                [weakSelf.navigationController popViewControllerAnimated:YES];
                            }];

}
@end