//
//  ProjectMainCell.m
//  elevatorMan
//
//  Created by 长浩 张 on 2016/12/26.
//
//

#import <Foundation/Foundation.h>
#import "ProjectMainCell.h"

@interface ProjectMainCell()

@property (weak, nonatomic) IBOutlet UIButton *btnDetail;

@property (strong, nonatomic) void(^onClickDetail)();

@end

@implementation ProjectMainCell

+ (id)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ProjectMainCell" owner:nil options:nil];
    if (0 == array.count)
    {
        return nil;
    }
    
    return array[0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [_btnDetail addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
}

+ (CGFloat)cellHeight
{
    return 44;
}

+ (NSString *)getIdentifier
{
    return @"project_main_cell";
}

- (void)setOnClickDetailListener:(void (^)())onClickDetail
{
    _onClickDetail = onClickDetail;
}

- (void)onClick
{
    if (_onClickDetail)
    {
        _onClickDetail();
    }
}

@end
