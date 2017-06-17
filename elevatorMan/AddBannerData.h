//
//  AddBannerData.h
//  owner
//
//  Created by 长浩 张 on 2017/1/16.
//  Copyright © 2017年 北京创鑫汇智科技发展有限公司. All rights reserved.
//

#ifndef AddBannerData_h
#define AddBannerData_h

#import "AddBannerView.h"

@interface AddBannerData : NSObject<AddBannerDataDelegate>

- (instancetype)initWithUrl:(NSString *)url clickUrl:(NSString *)clickUrl;

@end


#endif /* AddBannerData_h */
