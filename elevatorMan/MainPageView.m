//
// Created by changhaozhang on 2017/6/17.
//

#import "MainPageView.h"


@implementation MainPageView
{

}

+ (id)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MainpageView" owner:self options:nil];

    if (0 == array.count)
    {
        return nil;
    }

    return array[0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    _viewAlarm.userInteractionEnabled = YES;

    _viewMaint.userInteractionEnabled = YES;

    _viewHouseMaint.userInteractionEnabled = YES;

    _viewHouseRepair.userInteractionEnabled = YES;

    _viewQa.userInteractionEnabled = YES;

    _viewFault.userInteractionEnabled = YES;

    _viewOp.userInteractionEnabled = YES;

    _viewSafety.userInteractionEnabled = YES;
}

@end