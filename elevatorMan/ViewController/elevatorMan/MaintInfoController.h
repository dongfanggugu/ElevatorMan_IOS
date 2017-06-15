//
//  MaintInfoController.h
//  elevatorMan
//
//  Created by changhaozhang on 2017/6/5.
//
//

#import "BaseViewController.h"

@interface MaintInfoController : BaseViewController

@property (copy, nonatomic) NSString *serviceId;

@property (strong, nonatomic) NSDictionary *maintInfo;

@end
