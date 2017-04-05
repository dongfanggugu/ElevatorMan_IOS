//
//  AlarmInfoView.h
//  elevatorMan
//
//  Created by 长浩 张 on 16/6/28.
//
//

#ifndef AlarmInfoView_h
#define AlarmInfoView_h

#import <UIKit/UIKit.h>

@interface AlarmInfoView : UIView

+ (id)viewFromNib;

@property (strong, nonatomic) NSString *alarmId;


@property (weak, nonatomic) IBOutlet UILabel *projectLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *propertyTel;

- (void)onClickTel:(void(^)(NSString* tel))clickTel;

@end


#endif /* AlarmInfoView_h */
