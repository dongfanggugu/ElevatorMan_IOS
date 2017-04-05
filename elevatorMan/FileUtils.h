//
//  FileUtils.h
//  elevatorMan
//
//  Created by 长浩 张 on 15/12/23.
//
//

#ifndef FileUtils_h
#define FileUtils_h


#endif /* FileUtils_h */

@interface FileUtils : NSObject

/**
 *  将数据写入到指定目录的文件中
 *
 *  @param data     <#data description#>
 *  @param dirPath  <#dirPath description#>
 *  @param fileName <#fileName description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)writeFile:(NSData *)data Path:(NSString *)dirPath fileName:(NSString *)fileName;


/**
 *  返回文件是否存在
 *
 *  @param dirPath  <#dirPath description#>
 *  @param fileName <#fileName description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)existInPath:(NSString *)dirPath name:(NSString *)fileName;

/**
 *  返回文件是否存在
 *
 *  @param filePath <#filePath description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)existInFilePath:(NSString *)filePath;


/**
 *  从url字符串中解析文件名称
 *
 *  @param urlString <#urlString description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)getFileNameFromUrlString:(NSString *)urlString;


/**
 *  将同一个目录下的文件重命名
 *
 *  @param dirPath <#dirPath description#>
 *  @param oldName <#oldName description#>
 *  @param newName <#newName description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)renameFileNameInPath:(NSString *)dirPath oldName:(NSString *)oldName toNewName:(NSString *)newName;


+ (BOOL)copyFilesFrom:(NSString *)sourcePath to:(NSString *)destinationPath fileName:(NSString *)name;

@end
