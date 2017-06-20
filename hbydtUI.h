//
//  hbydtUI.h
//  SdkExampleDemo
//
//  Created by jasonchen on 16/4/14.
//  Copyright © 2016年 jason chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface hbydtUI : NSObject

/* 获取屏幕宽度 */
CGFloat screen_Width();
CGFloat screen_Width_Rotated();
/* 获取屏幕高度 */
CGFloat screen_Height();
CGFloat screen_Height_Rotated();

/**** View ****/
/* view宽度 */
CGFloat fView_Width(UIView *aView);
/* view高度 */
CGFloat fView_Height(UIView *aView);
/* view起点x值 */
CGFloat fView_Origin_X(UIView *aView);
/* view起点y值 */
CGFloat fView_Origin_Y(UIView *aView);
/* view中心x值 */
CGFloat fView_Center_X(UIView *aView);
CGFloat fView_Center_Y(UIView *aView);
/* 父视图view中心x值 */
CGFloat fView_SelfCenter_X(UIView *aView);
CGFloat fView_SelfCenter_Y(UIView *aView);
/* view中心Y值+height值 */
CGFloat fView_OffsetY(UIView *aView);
CGFloat fView_OffsetX(UIView *aView);

@end
