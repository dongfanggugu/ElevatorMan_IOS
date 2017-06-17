//
//  MaintInfoController.h
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/5.
//
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, MaintTaskMode)
{
    MaintTaskMode_Edit,
    MaintTaskMode_Show
};

@interface MaintInfoController : BaseViewController

@property (strong, nonatomic) NSDictionary *orderInfo;

@property (strong, nonatomic) NSDictionary *maintInfo;

@property (assign, nonatomic) MaintTaskMode mode;

@end
