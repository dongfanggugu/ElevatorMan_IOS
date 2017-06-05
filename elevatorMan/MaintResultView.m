//
//  MaintResultView.m
//  owner
//
//  Created by changhaozhang on 2017/6/3.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import "MaintResultView.h"

@implementation MaintResultView

+ (id)viewFromNib
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MaintResultView" owner:nil options:nil];
    
    if (0 == array.count) {
        return nil;
    }
    
    return array[0];
}


@end
