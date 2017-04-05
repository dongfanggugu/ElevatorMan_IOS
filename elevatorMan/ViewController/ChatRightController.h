//
//  ChatRightController.h
//  elevatorMan
//
//  Created by 长浩 张 on 2017/4/5.
//
//

#import "BaseViewController.h"

@protocol ChatRightControllerDelegate <NSObject>

- (void)onSelectItem:(NSString *)text withKey:(NSString *)alarmId;

@end

@interface ChatRightController : BaseViewController

- (void)setItemUnRead:(NSString *)alarmId;

@property (strong, nonatomic) NSArray *arrayAlarm;

@property (weak, nonatomic) id<ChatRightControllerDelegate> delegate;

@end
