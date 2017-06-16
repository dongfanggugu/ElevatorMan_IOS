//
//  Utils.h
//  elevatorMan
//
//  Created by 长浩 张 on 15/12/17.
//
//

#ifndef Utils_h
#define Utils_h


#endif /* Utils_h */


@interface Utils : NSObject

/**
 *  根据RGB值获取颜色值
 *
 *  @param RGB <#RGB description#>
 *
 *  @return <#return value description#>
 */
+ (UIColor *)getColorByRGB:(NSString *)RGB;

/**
 *  获取当前服务器
 *
 *  @return <#return value description#>
 */
+(NSString *)getServer;

/**
 *  检测是否为合法的年龄 1-99
 *
 *  @param age <#age description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)isLegalAge:(NSString *)age;

/**
 *  手机号码是否合法
 *
 *  @param phoneNumber <#phoneNumber description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)isCorrectPhoneNumberOf:(NSString *)phoneNumber;

/**
 *  MD5加密
 *
 *  @param str <#str description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)md5:(NSString *)str;

+ (NSString *)stringFromDate:(NSDate *)date;


+ (NSString *)image2Base64:(UIImage *)image;

/**
 * 格式化今天  yyyy-MM-dd HH:hh:ss
 * @param format
 * @return
 */
+ (NSString *)today:(NSString *)format;

@end
