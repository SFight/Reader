//
//  VTXmlParser.h
//  VTReader
//
//  Created by JinJie Song on 2018/4/10.
//  Copyright © 2018年 JinJie Song. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VTXmlParser : NSObject


/**
 xml解析器单利

 @return 解析器单利数据模型
 */
+ (VTXmlParser *)sharedInstance;


/**
 解析xml数据

 @param attribute 要获取的值的属性
 @param xmlURL 用来解析的xml文件路径
 @return 对应的属性的值
 */
- (NSString *)valueForAttribute:(NSString *)attribute inXMLFile:(NSString *)xmlURL;

/**
 根据指定属性及对应的值，查询另一个属性的值

 @param attribute 要查询的值的属性
 @param attribute1 已知的属性
 @param attributeValue 已知属性的值
 @param xmlURL 用来解析的xml文件路径
 @return 对应的属性的值
 */
- (NSString *)valueForAttribute:(NSString *)attribute withAttribute:(NSString *)attribute1 attributeValue:(NSString *)attributeValue inXMLFile:(NSString *)xmlURL;

/**
 解析xml数据

 @param attribute 要获取的属性的值
 @param namespace 命名空间
 @param xmlURL 用来解析的xml文件路径
 @return 对应命名空间下的属性的值
 */
- (NSString *)valueForNSAttribute:(NSString *)attribute withNamespace:(NSString *)namespace inXMLFile:(NSString *)xmlURL;

@end
