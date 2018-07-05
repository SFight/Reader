//
//  VTConstants.h
//  VTEpub
//
//  Created by JinJie Song on 2018/4/9.
//  Copyright © 2018年 JinJie Song. All rights reserved.
//

#ifndef VTConstants_h
#define VTConstants_h 

#pragma mark - 日志开关
#ifdef DEBUG
#define VTLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define VTLog(...)
#endif


#endif /* VTConstants_h */
