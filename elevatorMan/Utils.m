//
//  Utils.m
//  elevatorMan
//
//  Created by 长浩 张 on 15/12/17.
//
//

#import <Foundation/Foundation.h>
#import "Utils.h"
#import <CommonCrypto/CommonDigest.h>


@implementation Utils

+ (UIColor *)getColorByRGB:(NSString *)RGB {
    
    if (RGB.length != 7) {
        NSLog(@"illegal RGB value!");
        return [UIColor clearColor];
    }
    
    if (![RGB hasPrefix:@"#"]) {
        NSLog(@"illegal RGB value!");
        return [UIColor clearColor];
    }
    
    NSString *colorString = [RGB substringFromIndex:1];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    NSString *red = [colorString substringWithRange:range];
    
    range.location = 2;
    NSString *green = [colorString substringWithRange:range];
    
    range.location = 4;
    NSString *blue = [colorString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:red] scanHexInt:&r];
    [[NSScanner scannerWithString:green] scanHexInt:&g];
    [[NSScanner scannerWithString:blue] scanHexInt:&b];
    return [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1.0];
}


+ (NSString *)getServer {
    NSString *urlTextString =  [[NSUserDefaults standardUserDefaults] objectForKey:@"urlString"];
    
    NSString *string = nil;
    
    //string = @"http://123.57.10.16:8080/lift/mobile/";
    
    string = @"http://211.147.152.6:8080/lift/mobile/";
    
    
    
    //string = @"http://192.168.0.82:8080/mobile/";
    
     //string = @"http://192.168.0.82:8080/lift/mobile/";
    
    if ([urlTextString isEqualToString:@"北京"]) {
        string = @"http://211.147.152.6:8080/lift/mobile/";
        
    } else if ([urlTextString isEqualToString:@"全国"]) {
        string = @"http://123.57.10.16:8081/lift/mobile/";
        
    } else if ([urlTextString isEqualToString:@"上海"]) {
        string = @"http://47.93.123.2:8080/lift/mobile/";
        
    } else if ([urlTextString isEqualToString:@"马晓明"]) {
        string = @"http://119.57.248.130/mobile/";
        
    } else if ([urlTextString isEqualToString:@"张明锁"]) {
        string = @"http://192.168.0.82:8080/mobile/";
        
    } else if ([urlTextString isEqualToString:@"演示"]) {
        string = @"http://182.92.177.247:8080/lift/mobile/";
        
    } else if ([urlTextString isEqualToString:@"Azure"]) {
        string = @"http://smartydt-lift-beijing.chinacloudapp.cn:8080/lift/mobile/";
    } else {
        //默认使用全国的服务器
        string = @"http://123.57.10.16:8080/lift/mobile/";
    }
    
    return string;
}


/**
 *  检测是否为合法的年龄 1-99
 *
 *  @param age <#age description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)isLegalAge:(NSString *)age {
    NSString *ageRegex = @"^([1-9]\\d{0,1})$";
    NSPredicate *ageTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ageRegex];
    return [ageTest evaluateWithObject:age];
}

/**
 *  手机号码是否合法
 *
 *  @param phoneNumber <#phoneNumber description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)isCorrectPhoneNumberOf:(NSString *)phoneNumber {
    
    NSString *phoneRegex = @"^((13[0-9])|(14[0-9])|(15[^4,\\D])|(17[0-9])|(18[0,5-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phoneNumber];
}


/**
 *  MD5加密
 *
 *  @param str <#str description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString *)stringFromDate:(NSDate *)date
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}


/** 图片转换为base64码 **/
+ (NSString *)image2Base64:(UIImage *)image
{
    NSData *data = UIImageJPEGRepresentation(image, 1);
    NSString *base64Code = [data base64Encoding];
    return base64Code;
}

@end
