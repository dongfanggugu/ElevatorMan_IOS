//
//  AddBannerView.h
//  WNES
//
//  Created by 长浩 张 on 16/8/3.
//  Copyright © 2016年 长浩 张. All rights reserved.
//

#ifndef AddBannerView_h
#define AddBannerView_h

#import <UIKit/UIKit.h>

#pragma mark - AddBannerDataDelegate

@protocol AddBannerDataDelegate <NSObject>

- (NSString *)getPicUrl;

- (NSString *)getClickUrl;

@end

@protocol AddBannerViewDelegate;


#pragma mark - AddBannerView

@interface AddBannerView : UIView

@property (weak, nonatomic) id<AddBannerViewDelegate> delegate;

@property (strong, nonatomic) NSArray<id<AddBannerDataDelegate>> *arrayData;

@property BOOL isTwoPic;

- (void)shouldAutoShow:(BOOL)shouldStart;

@end

@protocol AddBannerViewDelegate<NSObject>

@optional

- (void)didClickPage:(AddBannerView *)view url:(NSString *)url;


@end


#endif /* ScrollAndPageView_h */
