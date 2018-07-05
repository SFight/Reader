//
//  VTEpubManager.h
//  VTReader
//
//  Created by JinJie Song on 2018/4/10.
//  Copyright © 2018年 JinJie Song. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VTDataReader.h"

@interface VTEpubManager : NSObject


/**
 获取epub控制器的单利

 @return VTEpubManager
 */
+ (VTEpubManager *_Nonnull)sharedInstance;

/**
 解析epub文件，生成阅读模型数据

 @param epubPath 待解析的epub文件路径
 @return 阅读器数据模型
 */
- (VTDataReader *_Nullable)praserEpub:( NSString * _Nonnull)epubPath;

@end
