//
//  hbydtUI.m
//  SdkExampleDemo
//
//  Created by jasonchen on 16/4/14.
//  Copyright © 2016年 jason chen. All rights reserved.
//

#import "hbydtUI.h"

@implementation hbydtUI
CGFloat screen_Width() {
    return [UIScreen mainScreen].bounds.size.width;
}

CGFloat screen_Width_Rotated() {
    return [UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height;
}

CGFloat screen_Height() {
    return [UIScreen mainScreen].bounds.size.height;
}

CGFloat screen_Height_Rotated() {
    return [UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.width;
}

CGFloat fView_Width(UIView *aView) {
    return aView.frame.size.width;
}

CGFloat fView_Height(UIView *aView) {
    return aView.frame.size.height;
}

CGFloat fView_Width_Rotated(UIView *aView) {
    return aView.frame.size.width > aView.frame.size.height ? aView.frame.size.width : aView.frame.size.height;
}

CGFloat fView_Height_Rotated(UIView *aView) {
    return aView.frame.size.width > aView.frame.size.height ? aView.frame.size.height : aView.frame.size.width;
}

CGFloat fView_Origin_X(UIView *aView) {
    return aView.frame.origin.x;
}

CGFloat fView_Origin_Y(UIView *aView) {
    return aView.frame.origin.y;
}

CGFloat fView_Center_X(UIView *aView) {
    return aView.center.x;
}

CGFloat fView_Center_Y(UIView *aView) {
    return aView.center.y;
}

CGFloat fView_SelfCenter_X(UIView *aView) {
    return aView.frame.size.width / 2;
}

CGFloat fView_SelfCenter_Y(UIView *aView) {
    return aView.frame.size.height / 2;
}

CGFloat fView_OffsetY(UIView *aView) {
    return fView_Origin_Y(aView) + fView_Height(aView);
}

CGFloat fView_OffsetX(UIView *aView) {
    return fView_Origin_X(aView) + fView_Width(aView);
}

@end
