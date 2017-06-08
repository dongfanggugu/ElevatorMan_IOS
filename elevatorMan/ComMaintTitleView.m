//
//  ComMaintTitleView.m
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/8.
//
//

#import "ComMaintTitleView.h"
#import "ListDialogView.h"
#import "ListDialogData.h"

#define COM 1001
#define WORKER 1002

@interface ComMaintTitleView () <ListDialogViewDelegate>

@property (weak,nonatomic) IBOutlet UIButton *btn1;

@property (weak,nonatomic) IBOutlet UIButton *btn2;

@property (weak,nonatomic) IBOutlet UIButton *btn3;

@property (weak,nonatomic) IBOutlet UIButton *btn4;

@property (weak,nonatomic) IBOutlet UIImageView *ivCom;

@property (weak,nonatomic) IBOutlet UIImageView *ivWorker;

@end

@implementation ComMaintTitleView

+ (id)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ComMaintTitleView" owner:nil options:nil];
    
    if (0 == array.count) {
        return nil;
    }
    
    return array[0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    
    [_btn1 addTarget:self action:@selector(clickBtn1) forControlEvents:UIControlEventTouchUpInside];
    
    [_btn2 addTarget:self action:@selector(clickBtn2) forControlEvents:UIControlEventTouchUpInside];
    
    [_btn3 addTarget:self action:@selector(clickBtn3) forControlEvents:UIControlEventTouchUpInside];
    
    [_btn4 addTarget:self action:@selector(clickBtn4) forControlEvents:UIControlEventTouchUpInside];
    
    _lbCompany.userInteractionEnabled = YES;
    
    _lbWorker.userInteractionEnabled = YES;
    
    [_lbCompany addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCompany)]];
    
    [_lbWorker addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showWorker)]];
    
}

- (void)showCompany
{
    ListDialogView *dialog = [ListDialogView viewFromNib];
    
    ListDialogData *data1 = [[ListDialogData alloc] initWithKey:@"" content:@"中建华宇"];
    
    ListDialogData *data2 = [[ListDialogData alloc] initWithKey:@"" content:@"中航机电"];
    
    [dialog setData:[NSArray arrayWithObjects:data1, data2, nil]];
    
    dialog.delegate = self;
    
    dialog.tag = COM;
    
    _ivCom.image = [UIImage imageNamed:@"icon_up_new"];
    
    [dialog show];
}

- (void)showWorker
{
    ListDialogView *dialog = [ListDialogView viewFromNib];
    
    ListDialogData *data1 = [[ListDialogData alloc] initWithKey:@"" content:@"张三"];
    
    ListDialogData *data2 = [[ListDialogData alloc] initWithKey:@"" content:@"李四"];
    
    [dialog setData:[NSArray arrayWithObjects:data1, data2, nil]];
    
    dialog.delegate = self;
    
    dialog.tag = WORKER;
    
     _ivWorker.image = [UIImage imageNamed:@"icon_up_new"];
    
    [dialog show];
}

#pragma mark - ListDialogViewDelegate

- (void)onSelectItem:(ListDialogView *)view key:(NSString *)key content:(NSString *)content
{
    NSInteger tag = view.tag;
    
    if (WORKER == tag) {
        _lbWorker.text = content;
        
        _ivWorker.image = [UIImage imageNamed:@"icon_down_new"];
        
    } else {
        _lbCompany.text = content;
        
        _ivCom.image = [UIImage imageNamed:@"icon_down_new"];
    }
}

- (void)onClickCancel:(ListDialogView *)view
{
    NSInteger tag = view.tag;
    
    if (WORKER == tag) {
        _ivWorker.image = [UIImage imageNamed:@"icon_down_new"];
        
    } else {
        _ivCom.image = [UIImage imageNamed:@"icon_down_new"];
    }

}

- (void)resetBtn
{
    [_btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [_btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [_btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [_btn4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void)clickBtn1
{
    [self resetBtn];
    [_btn1 setTitleColor:RGB(TITLE_COLOR) forState:UIControlStateNormal];

    if (_delegate && [_delegate respondsToSelector:@selector(onClickBtn1)]) {
        [_delegate onClickBtn1];
    }
}

- (void)clickBtn2
{
    [self resetBtn];
    [_btn2 setTitleColor:RGB(TITLE_COLOR) forState:UIControlStateNormal];

    if (_delegate && [_delegate respondsToSelector:@selector(onClickBtn2)]) {
        [_delegate onClickBtn2];
    }
}
- (void)clickBtn3
{
    [self resetBtn];
    [_btn3 setTitleColor:RGB(TITLE_COLOR) forState:UIControlStateNormal];

    if (_delegate && [_delegate respondsToSelector:@selector(onClickBtn3)]) {
        [_delegate onClickBtn3];
    }
}
- (void)clickBtn4
{
    [self resetBtn];
    [_btn4 setTitleColor:RGB(TITLE_COLOR) forState:UIControlStateNormal];

    if (_delegate && [_delegate respondsToSelector:@selector(onClickBtn4)]) {
        [_delegate onClickBtn4];
    }
}
@end
