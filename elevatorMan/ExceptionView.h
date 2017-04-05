//
//  ExceptionView.h
//  elevatorMan
//
//  Created by 长浩 张 on 2016/10/31.
//
//

#ifndef ExceptionView_h
#define ExceptionView_h

#import <UIKit/UIKit.h>

@protocol ExceptionDelegate <NSObject>

- (void)onClickConfirm:(NSString *)remark;

@optional
- (void)onClickCancel;

@end

@interface ExceptionView : UIView

+ (instancetype)viewFromNib;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) id<ExceptionDelegate> delegate;

@end


#endif /* ExceptionView_h */
