//
//  VTDataBase.h
//  VTReader
//
//  Created by JinJie Song on 2018/4/10.
//  Copyright © 2018年 JinJie Song. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VTDataBase : NSObject


/**
 返回格式化的字符串

 @param value 要格式化的数据，可以是NSNull类、nil、NSString
 @return 格式化后的字符串
 */
- (NSString *)stringValue:(id)value;


/**
 返回格式化的数字

 @param value 要格式化的数据，可以是NSNull类、nil、NSString、NSNumber
 @return 格式化后的数字
 */
- (NSNumber *)numberValue:(id)value;

@end
