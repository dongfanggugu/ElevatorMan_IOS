//
//  AppDelegate.h
//  elevatorMan
//
//  Created by Cove on 15/3/15.
//
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSDictionary *mLaunchOptions;

@property (strong, nonatomic) NSTimer *locationTimer;

@property (strong, nonatomic) NSTimer *bgCheckTimer;

@end

