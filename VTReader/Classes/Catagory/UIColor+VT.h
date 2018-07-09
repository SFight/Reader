//
//  UIColor+VT.h
//  VTReader
//
//  Created by vtears on 2018/7/9.
//  Copyright © 2018年 JinJie Song. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (VT)

/**
 * 根据hex值，计算得到UIColor对象，例如：#899847 or 899847
 * @param   hexColor        NSString
 * @return      UIColor
 */
+ (UIColor *)colorForHex:(NSString *)hexColor;

@end
