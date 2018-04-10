//
//  NSString+VTSandBox.h
//  VTEpub
//
//  Created by JinJie Song on 2018/4/9.
//  Copyright © 2018年 JinJie Song. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (VTSandBox)

/**
 用户沙盒根目录
 
 @return 根目录字符串
 */
+ (NSString *)homePath;

/**
 用户沙盒的Documents目录
 
 @return Documents目录的字符串
 */
+ (NSString *)documentsPath;

/**
 用户沙盒的Library目录
 
 @return Library目录的字符串
 */
+ (NSString *)libraryPath;

/**
 用户沙盒的缓存目录
 
 @return Library/Caches目录的字符串
 */
+ (NSString *)cachesPath;

@end
