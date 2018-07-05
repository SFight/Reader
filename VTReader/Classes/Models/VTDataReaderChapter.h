//
//  VTDataReaderChapter.h
//  VTReader
//
//  Created by JinJie Song on 2018/4/10.
//  Copyright © 2018年 JinJie Song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VTDataBase.h"

@interface VTDataReaderChapter : VTDataBase

/** 章节路径 */
@property (nonatomic, copy) NSString *chapterPath;

- (NSArray *)pages;

@end
