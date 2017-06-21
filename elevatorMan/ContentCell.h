//
//  ContentCell.h
//  owner
//
//  Created by 长浩 张 on 2017/4/19.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentCell : UITableViewCell

+ (id)cellFromNib;

+ (NSString *)identifier;

+ (CGFloat)cellHeight:(NSString *)content;

@property (weak, nonatomic) IBOutlet UILabel *lbContent;

@end
