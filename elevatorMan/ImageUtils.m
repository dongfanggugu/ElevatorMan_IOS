//
//  ImageUtils.m
//  elevatorMan
//
//  Created by 长浩 张 on 15/12/18.
//
//

#import <Foundation/Foundation.h>
#import "ImageUtils.h"

@interface ImageUtils()

@end


@implementation ImageUtils

/**
 *  按照比例压缩图片
 *
 *  @param image   <#image description#>
 *  @param newSize <#newSize description#>
 *
 *  @return <#return value description#>
 */
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}


/**
 *  图片转换为BASE64
 *
 *  @param path <#path description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)image2Base64From:(NSString *)path {
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    NSData *data = UIImageJPEGRepresentation(image, 1);
    NSString *base64Code = [data base64Encoding];
    return base64Code;
}

@end