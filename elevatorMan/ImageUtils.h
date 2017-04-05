//
//  ImageUtils.h
//  elevatorMan
//
//  Created by 长浩 张 on 15/12/18.
//
//

#ifndef ImageUtils_h
#define ImageUtils_h


#endif /* ImageUtils_h */

@interface ImageUtils : NSObject

/**
 *  按照比例压缩图片
 *
 *  @param image   <#image description#>
 *  @param newSize <#newSize description#>
 *
 *  @return <#return value description#>
 */
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;


/**
 *  图片转换为BASE64
 *
 *  @param path <#path description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)image2Base64From:(NSString *)path;


@end
