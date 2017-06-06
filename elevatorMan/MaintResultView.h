//
//  MaintResultView.h
//  owner
//
//  Created by changhaozhang on 2017/6/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MaintResultViewDelegate <NSObject>

- (void)onClickBeforeImage;

- (void)onClickAfterImage;

- (void)onClickDelBefore;

- (void)onClickDelAfter;

- (void)onClickSubmit;

@end

@interface MaintResultView : UIView

+ (id)viewFromNib;

@property (weak, nonatomic) IBOutlet UITextView *tvContent;

@property (weak, nonatomic) UIImage *imageBefore;

@property (weak, nonatomic) UIImage *imageAfter;

@property (assign, nonatomic) BOOL hasBefore;

@property (assign, nonatomic) BOOL hasAfter;

@property (assign, nonatomic) BOOL showMode;

@property (weak, nonatomic) IBOutlet UIImageView *ivBefore;

@property (weak, nonatomic) IBOutlet UIImageView *ivAfter;

@property (weak, nonatomic) id<MaintResultViewDelegate> delegate;

@end
