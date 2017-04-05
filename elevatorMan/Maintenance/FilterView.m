//
//  FilterView.m
//  elevatorMan
//
//  Created by 长浩 张 on 2016/12/26.
//
//

#import <Foundation/Foundation.h>
#import "FilterView.h"
#import "ListDialogView.h"

#pragma mark - KeyData

@interface KeyData : NSObject<ListDialogDataDelegate>

@property (strong, nonatomic) NSString *keyValue;

@property (strong, nonatomic) NSString *keyId;

@end

@implementation KeyData

- (NSString *)getKey
{
    return _keyId;
}

- (NSString *)getShowContent
{
    return _keyValue;
}

@end

#pragma mark - FilterView

@interface FilterView()<ListDialogViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lbSelection;

@property (weak, nonatomic) IBOutlet UITextField *tfContent;

@property (weak, nonatomic) IBOutlet UIButton *btnSearch;

@property (weak, nonatomic) IBOutlet UIView *view;

@end

@implementation FilterView

+ (id)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"FilterView" owner:nil options:nil];
    if (0 == array.count)
    {
        return nil;
    }
    
    return array[0];
}

+ (CGFloat)viewHeight
{
    return 88;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _lbSelection.userInteractionEnabled = YES;
    [_lbSelection addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showListDialog)]];
    
    [_btnSearch addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)search
{
    if (_delegate)
    {
        [_delegate onClickSearch];
    }
}

- (void)setView:(UIView *)view
{
    _view = view;
}

- (void)showListDialog
{
    KeyData *data1 = [[KeyData alloc] init];
    data1.keyId = @"1";
    data1.keyValue = @"全部";
    
    KeyData *data2 = [[KeyData alloc] init];
    data2.keyId = @"2";
    data2.keyValue = @"未完成";
    
    KeyData *data3 = [[KeyData alloc] init];
    data3.keyId = @"3";
    data3.keyValue = @"已完成";

    NSMutableArray<ListDialogDataDelegate> *array = [[NSMutableArray<ListDialogDataDelegate> alloc] init];
    [array addObject:data1];
    [array addObject:data2];
    [array addObject:data3];
    
    ListDialogView *dialog = [ListDialogView viewFromNib];
    
    [dialog setData:array];
    dialog.delegate = self;
    
    [_view addSubview:dialog];
}

#pragma mark - ListDialogViewDelegate

- (void)onSelectItem:(NSString *)key content:(NSString *)content
{
    _lbSelection.text = content;
    
    if (_delegate)
    {
        [_delegate afterSelection:content];
    }
}

@end
