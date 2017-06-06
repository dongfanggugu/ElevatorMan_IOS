//
//  ListDialogData.h
//  owner
//
//  Created by 长浩 张 on 2017/5/23.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListDialogData : NSObject

- (id)initWithKey:(NSString *)key content:(NSString *)content;

@property (copy, nonatomic) NSString *key;

@property (copy, nonatomic) NSString *content;


@end
