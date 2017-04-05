//
//  ChatController.h
//  elevatorMan
//
//  Created by 长浩 张 on 2016/12/27.
//
//

#ifndef ChatController_h
#define ChatController_h

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, Enter_Type)
{
    Enter_Worker,
    Enter_Property
};

@interface ChatController : BaseViewController

@property (nonatomic, strong) NSMutableArray *resultArray;

@property (copy, nonatomic) NSString *alarmId;

@property (assign, nonatomic) Enter_Type enterType;

@end


#endif /* ChatController_h */
