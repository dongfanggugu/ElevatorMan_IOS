//
//  EvaluateView.h
//  owner
//
//  Created by 长浩 张 on 2017/1/11.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef EvaluateView_h
#define EvaluateView_h

@protocol EvaluateViewDelegate <NSObject>

- (void)onSubmit:(NSInteger)star content:(NSString *)content;

@end

@interface EvaluteView : UIView

+ (id)viewFromNib;

+ (CGFloat)viewHight;

- (void)setModeShow;

- (void)setContent:(NSString *)content;

- (void)setStar:(NSInteger)star;

@property (weak, nonatomic) id<EvaluateViewDelegate> delegate;


@end

#endif /* EvaluateView_h */
