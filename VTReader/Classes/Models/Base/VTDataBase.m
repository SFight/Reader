//
//  VTDataBase.m
//  VTReader
//
//  Created by JinJie Song on 2018/4/10.
//  Copyright © 2018年 JinJie Song. All rights reserved.
//

#import "VTDataBase.h"

@implementation VTDataBase

- (NSString *)stringValue:(id)value
{
    if ([value isKindOfClass:[NSNull class]] || value == nil) {
        return @"";
    }
    
    if ([value isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)value stringValue];
    }
    
    return value;
}

- (NSNumber *)numberValue:(id)value
{
    if ([value isKindOfClass:[NSNull class]] || value == nil) {
        return [NSNumber numberWithInt:0];
    }
    
    if ([value isKindOfClass:[NSString class]]) {
        return [NSNumber numberWithFloat:[value floatValue]];
    }
    
    return value;
}

@end
