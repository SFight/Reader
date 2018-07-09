//
//  UIColor+VT.m
//  VTReader
//
//  Created by vtears on 2018/7/9.
//  Copyright © 2018年 JinJie Song. All rights reserved.
//

#import "UIColor+VT.h"

@implementation UIColor (VT)

+ (UIColor *)colorForHex:(NSString *)hexColor
{
    if ([hexColor hasPrefix:@"#"]) {
        hexColor = [hexColor substringFromIndex:1];
    }
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [hexColor substringWithRange:range];
    range.location = 2;
    NSString *gString = [hexColor substringWithRange:range];
    range.location = 4;
    NSString *bString = [hexColor substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

@end
