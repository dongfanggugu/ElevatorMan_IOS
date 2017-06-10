//
//  HelpContentController.m
//  owner
//
//  Created by 长浩 张 on 2017/1/9.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HelpContentController.h"

@interface HelpContentController ()

@property (weak, nonatomic) IBOutlet UILabel *lbContent;

@end

@implementation HelpContentController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:_pageTitle];
    [self initView];
}

- (void)initView
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 64 + 8, self.view.bounds.size.width - 16, 100)];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = _content;
    label.font = [UIFont systemFontOfSize:14];

    CGSize size = [label sizeThatFits:CGSizeMake(label.frame.size.width, MAXFLOAT)];
    label.frame = CGRectMake(8, 64 + 8, self.view.bounds.size.width - 16, size.height);
    [self.view addSubview:label];
}

@end
