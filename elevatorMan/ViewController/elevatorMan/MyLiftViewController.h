//
//  MyLiftViewController.h
//  elevatorMan
//
//  Created by 长浩 张 on 16/6/29.
//
//

#ifndef MyLiftViewController_h
#define MyLiftViewController_h

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, LiftType)
{
    TYPE_ALL,
    TYPE_PLAN
};

@interface MyLiftViewController : BaseViewController

@property (nonatomic) LiftType liftType;

@end


#endif /* MyLiftViewController_h */
