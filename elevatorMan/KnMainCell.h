//
//  KnMainCell.h
//  owner
//
//  Created by 长浩 张 on 2017/5/26.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KnMainCellDelegate <NSObject>

- (void)onClickQA;

- (void)onClickFault;

- (void)onClickOperation;

- (void)onClickLaw;

@end

@interface KnMainCell : UITableViewCell

+ (id)cellFromNib;

+ (NSString *)identifier;

+ (CGFloat)cellHeight;

@property (weak, nonatomic) id<KnMainCellDelegate> delegate;

@end
