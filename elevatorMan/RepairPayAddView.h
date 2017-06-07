//
//  RepairPayAddView.h
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/7.
//
//

#import <UIKit/UIKit.h>

@protocol RepairPayAddViewDelegate <NSObject>

- (void)onClickConfirm:(NSString *)item fee:(CGFloat)money;

@end

@interface RepairPayAddView : UIView

+ (id)viewFromNib;

- (void)show;

@property (weak, nonatomic) IBOutlet UITextField *tfItem;

@property (weak, nonatomic) IBOutlet UITextField *tfMoney;

@property (weak, nonatomic) id<RepairPayAddViewDelegate> delegate;

@end
