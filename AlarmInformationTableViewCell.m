//
//  AlarmInformationTableViewCell.m
//  SdkExampleDemo
//
//  Created by jasonchen on 16/4/18.
//  Copyright © 2016年 jason chen. All rights reserved.
//

#import "AlarmInformationTableViewCell.h"

@interface AlarmInformationTableViewCell ()
@property (nonatomic, strong) UILabel *alarmInfoLabel;
@end

@implementation AlarmInformationTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        [self configUI];
    }
    return self;
}

- (void)configUI {
    _alarmInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0 )];
    _alarmInfoLabel.textColor = [UIColor blackColor];
    _alarmInfoLabel.numberOfLines = 0;
    _alarmInfoLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_alarmInfoLabel];
}

- (void)alarmLabelNewHeghtWithContent:(NSString *)alarmInformation {
  
    CGSize alarmInfoSize =[alarmInformation boundingRectWithSize:CGSizeMake(320,1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    _alarmInfoLabel.frame = CGRectMake(0, 0, self.frame.size.width, alarmInfoSize.height+10);
    _alarmInfoLabel.text = alarmInformation;
}

- (void)awakeFromNib {
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
