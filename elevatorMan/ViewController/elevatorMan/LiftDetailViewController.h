//
//  LiftDetailViewController.h
//  elevatorMan
//
//  Created by 长浩 张 on 16/6/29.
//
//

#ifndef LiftDetailViewController_h
#define LiftDetailViewController_h

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface LiftDetailViewController : BaseViewController

@property (strong, nonatomic) NSString *liftCode;

@property (strong, nonatomic) NSString *project;

@property (strong, nonatomic) NSString *address;

@property (strong, nonatomic) NSString *worker;

@property (strong, nonatomic) NSString *tel;

@end



#endif /* LiftDetailViewController_h */
