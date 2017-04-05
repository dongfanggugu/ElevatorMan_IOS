//
//  CalloutAnnotationView.h
//  elevatorMan
//
//  Created by 长浩 张 on 16/6/28.
//
//

#ifndef CalloutAnnotationView_h
#define CalloutAnnotationView_h

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMKAnnotationView.h>
#import "AlarmInfoView.h"

@interface CalloutAnnotationView : BMKAnnotationView

@property (strong, nonatomic) AlarmInfoView *alarmInfoView;

@property (strong, nonatomic) UIView *contentView;

@property (strong, nonatomic) NSMutableDictionary *info;

- (void)showInfoWindow;

- (void)hideInfoWindow;

@end



#endif /* CalloutAnnotationView_h */
