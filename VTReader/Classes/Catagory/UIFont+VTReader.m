//
//  UIFont+VTReader.m
//  VTReader
//
//  Created by vtears on 2018/7/10.
//  Copyright © 2018年 JinJie Song. All rights reserved.
//

#import "UIFont+VTReader.h"

@implementation UIFont (VTReader)

+ (UIFont *)fontWithSize:(CGFloat)fontSize
{
    return [UIFont systemFontOfSize:fontSize];
}

+ (UIFont *)boldFontOfSize:(CGFloat)fontSize
{
    return [UIFont boldSystemFontOfSize:fontSize];
}

@end
