//
//  FileUtils.m
//  elevatorMan
//
//  Created by 长浩 张 on 15/12/23.
//
//

#import <Foundation/Foundation.h>
#import "FileUtils.h"

@interface FileUtils()

@end

@implementation FileUtils

/**
 *  将数据写入到指定目录的文件中
 *
 *  @param data     <#data description#>
 *  @param dirPath  <#dirPath description#>
 *  @param fileName <#fileName description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)writeFile:(NSData *)data Path:(NSString *)dirPath fileName:(NSString *)fileName
{
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL dirExist = [manager fileExistsAtPath:dirPath];
    if (!dirExist) {
        [manager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *filePath = [dirPath stringByAppendingString:fileName];
    
    BOOL fileExist = [manager fileExistsAtPath:filePath];
    
    if (fileExist) {
        [manager removeItemAtPath:filePath error:nil];
    }
    
    return [manager createFileAtPath:filePath contents:data attributes:nil];
}

/**
 *  返回文件是否存在
 *
 *  @param dirPath  <#dirPath description#>
 *  @param fileName <#fileName description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)existInPath:(NSString *)dirPath name:(NSString *)fileName
{
    
    NSString *filePath = [dirPath stringByAppendingString:fileName];
    return [self existInFilePath:filePath];
}


/**
 *  返回文件是否存在
 *
 *  @param filePath <#filePath description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)existInFilePath:(NSString *)filePath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    return [manager fileExistsAtPath:filePath];
}


/**
 *  从url字符串中解析文件名称
 *
 *  @param urlString <#urlString description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)getFileNameFromUrlString:(NSString *)urlString
{
    NSString *fileName = nil;
    NSArray *array = [urlString componentsSeparatedByString:@"/"];
    if (array != nil && array.count > 0){
        fileName = array[array.count - 1];
    }
    return fileName;
}

/**
 *  将同一个目录下的文件重命名
 *
 *  @param dirPath <#dirPath description#>
 *  @param oldName <#oldName description#>
 *  @param newName <#newName description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)renameFileNameInPath:(NSString *)dirPath oldName:(NSString *)oldName toNewName:(NSString *)newName
{
    if (![self existInFilePath:dirPath]) {
        NSLog(@"dir does not exist");
        return NO;
    }
    
    if (![self existInPath:dirPath name:oldName]) {
        NSLog(@"file does not exist");
        return NO;
    }
    
    NSString *filePath = [dirPath stringByAppendingString:oldName];
    NSString *newFilePath = [dirPath stringByAppendingString:newName];
    NSFileManager *manager = [NSFileManager defaultManager];
    
    return [manager moveItemAtPath:filePath toPath:newFilePath error:nil];
}

/**
 *  copy files
 *
 *  @param sourcePath      <#sourcePath description#>
 *  @param destinationPath <#destinationPath description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)copyFilesFrom:(NSString *)sourcePath to:(NSString *)destinationPath fileName:(NSString *)name
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    if (![fileManager fileExistsAtPath:sourcePath])
    {
        NSLog(@"the file %@ does not exist!", sourcePath);
        return NO;
    }
    
    NSLog(@"sandbox path:%@", destinationPath);
    
    if (![fileManager fileExistsAtPath:destinationPath])
    {
        //[fileManager removeItemAtPath:destinationPath error:nil];
        //return YES;
        [fileManager createDirectoryAtPath:destinationPath withIntermediateDirectories:YES attributes:nil
                                     error:nil];
    }
    NSString *filePath = [destinationPath stringByAppendingString:name];
    
    if ([fileManager fileExistsAtPath:filePath])
    {
        //[fileManager removeItemAtPath:filePath error:nil];
        return YES;
    }
    
    return [fileManager copyItemAtPath:sourcePath toPath:filePath error:&error];
}
@end