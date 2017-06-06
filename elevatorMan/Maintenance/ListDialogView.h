//
//  ListDialogView.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/12/7.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef ListDialogView_h
#define ListDialogView_h

@protocol ListDialogDataDelegate <NSObject>

- (NSString *)getShowContent;

- (NSString *)getKey;

@end

@protocol ListDialogViewDelegate <NSObject>

- (void)onSelectItem:(NSString *)key content:(NSString *)content;

@end

#pragma mark - ListDialogView

@interface ListDialogView : UIView


@property (strong, nonatomic) NSArray<id<ListDialogDataDelegate>> *arrayData;

@property (weak, nonatomic) id<ListDialogViewDelegate> delegate;


+ (id)viewFromNib;

- (void)setData:(NSArray<id<ListDialogDataDelegate>> *)arrayData;

- (void)show;


@end
#endif /* ListDialogView_h */
