//
//  KeyValueCell.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/12/14.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef KeyValueCell_h
#define KeyValueCell_h

@interface KeyValueCell : UITableViewCell


+ (id)cellFromNib;

+ (NSString *)identifier;

+ (CGFloat)cellHeight;

+ (CGFloat)cellHeightWithContent:(NSString *)content;


@property (weak, nonatomic) IBOutlet UILabel *lbKey;

@property (weak, nonatomic) IBOutlet UILabel *lbValue;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *valueWidth;


@end


#endif /* KeyValueCell_h */
