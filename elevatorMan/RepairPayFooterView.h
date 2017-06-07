//
//  RepairPayFooterView.h
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/7.
//
//

#import <UIKit/UIKit.h>

@protocol RepairPayFooterViewDelegate <NSObject>

- (void)onClickSubmit;

@end

@interface RepairPayFooterView : UIView

+ (id)viewFromNib;

@property (weak, nonatomic) IBOutlet UILabel *lbTotal;

@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@property (weak, nonatomic) id<RepairPayFooterViewDelegate> delegate;

@end
