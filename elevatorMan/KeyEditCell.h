//
//  KeyEditCell.h
//  ConcreteCloud
//
//  Created by 长浩 张 on 2016/12/14.
//  Copyright © 2016年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef KeyEditCell_h
#define KeyEditCell_h

@interface KeyEditCell : UITableViewCell

+ (id)cellFromNib;

+ (NSString *)identifier;

+ (CGFloat)cellHeight;

@property (weak, nonatomic) IBOutlet UILabel *lbKey;

@property (weak, nonatomic) IBOutlet UITextField *tfValue;

@property (weak, nonatomic) IBOutlet UILabel *lbUnit;

@end


#endif /* KeyEditCell_h */
