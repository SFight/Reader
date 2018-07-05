//
//  VTReaderConfig.h
//  VTReader
//
//  Created by JinJie Song on 2018/4/13.
//  Copyright © 2018年 JinJie Song. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VTReaderConfig : NSObject<NSCoding>

/** 字体名称 */
@property (nonatomic, copy, readonly) NSString *fontName;
/** 字体大小 */
@property (nonatomic, assign, readonly) NSInteger fontSize;

/**
 获取阅读全局配置

 @return 获得全局配置对象
 */
+ (VTReaderConfig *)sharedInstance;

/**
 归档
 */
- (void)archive;

/**
 解档
 */
- (void)unArchive;

@end
