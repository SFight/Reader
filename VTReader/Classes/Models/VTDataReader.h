//
//  VTDataReader.h
//  VTReader
//
//  Created by JinJie Song on 2018/4/10.
//  Copyright © 2018年 JinJie Song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VTDataBase.h"

#import "VTDataReaderChapter.h"

@interface VTDataReader : VTDataBase

/** 资源文件路径 */
@property (nonatomic, copy) NSString *filePath;
/** 资源文件章节列表 */
@property (nonatomic, strong) NSArray<VTDataReaderChapter *> *chapters;

@end
