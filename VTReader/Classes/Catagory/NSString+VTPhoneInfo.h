//
//  NSString+VTPhoneInfo.h
//  VTEpub
//
//  Created by JinJie Song on 2018/4/9.
//  Copyright © 2018年 JinJie Song. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 手机型号枚举
 */
typedef NS_ENUM(NSInteger, kDeviceType) {
    None_Type, // 设备类型未知
    // 模拟器
    Simulator, // Simulator
    // AirPods
    Air_Pods, // Air Pods
    // Apple TV
    Apple_TV_2ND_GENERATION, // Apple TV (2nd generation)
    Apple_TV_3RD_GENERATION, // Apple TV (3rd generation)
    Apple_TV_4TH_GENERATION, // APple TV (4th generation)
    Apple_TV_4K, // Apple TV 4k
    // AppleWatch
    Apple_Watch_1ST_GENERATION, // Apple Watch (1st generation)
    Apple_Watch_Series_1, // Apple Watch Series 1
    Apple_Watch_Series_2, // Apple Watch Series 2
    Apple_Watch_Series_3, // Apple Watch Series 3
    // HomePod
    Home_Pod, // Home Pod
    // iPad
    iPad, // iPad 768x1024 768x1024 @1x
    iPad_2, // iPad 2 768x1024 768x1024 @1x
    iPad_3RD_GENERATION, // iPad (3rd generation) 768x1024 1536x2048 @2x
    iPad_4TH_GENERATION, // iPad (4th generation) 768x1024 1536x2048 @2x
    iPad_5TH_GENERATION, // iPad (5th generation) 768x1024 1536x2048 @2x
    iPad_6TH_GENERATION, // iPad (6th generation) 768x1024 1536x2048 @2x
    iPad_Air, // iPad Air 768x1024 1536x2048 @2x
    iPad_Air_2, // iPad Air 2 768x1024 1536x2048 @2x
    iPad_Pro_9_7, // iPad Pro (9.7-inch) 768x1024 1536x2048 @2x
    iPad_Pro_10_5, // iPad Pro (10.5-inch) 834x1112 1668x2224 @2x
    iPad_Pro_12_9, // iPad Pro (12.9-inch) 1024x1336 2048x2732 @2x
    iPad_Pro_12_9_2ND, // iPad Pro (12.9-inch, 2nd generation) 1024x1336 2048x2732 @2x
    // iPad mini
    iPad_MINI, // iPad mini 768x1024 768x1024 @1x
    iPad_MINI_2, // iPad mini 2 768x1024 1536x2048 @2x
    iPad_MINI_3, // iPad mini 3 768x1024 1536x2048 @2x
    iPad_MINI_4, // iPad mini 4 768x1024 1536x2048 @2x
    // iPhone
    iPhone_1G, // iPhone 1G 320x480 320x480 @1x
    iPhone_3G, // iPhone 3G 320x480 320x480 @1x
    iPhone_3GS, // iPhone 3GS 320x480 320x480 @1x
    iPhone_4, // iPhone 4 320x480 640x960 @2x
    iPhone_4S, // iPhone 4S 320x480 640x960 @2x
    iPhone_5, // iPhone 5 320x568 640x1136 @2x
    iPhone_5C, // iPhone 5C 320x568 640x1136 @2x
    iPhone_5S, // iPhone 5S 320x568 640x1136 @2x
    iPhone_6, // iPhone 6 375x667 750x1334 @2x
    iPhone_6_PLUS, // iPhone 6 Plus 414x736 (1242x2208)->1080x1920 @3x
    iPhone_6S, // iPhone 6S 375x667 750x1134 @2x
    iPhone_6S_PLUS, // iPhone 6S Plus 414x736 (1242x2208)->1080x1920 @3x
    iPhone_SE, // iPhone SE 320x568 640x1136 @2x
    iPhone_7, // iPhone 7 375x667 750x1134 @2x
    iPhone_7_PLUS, // iPhone 7 Plus 414x736 (1242x2208)->1080x1920 @3x
    iPhone_8, // iPhone 8 375x667 750x1134 @2x
    iPhone_8_PLUS, // iPhone_8_PLUS 414x736 (1242x2208)->1080x1920 @3x
    iPhone_X, // iPhone_X 375x812 1125x2436 @3x
    // iPod touch
    iPod_TOUCH, // iPod touch 320x480 320x480 @1x
    iPod_TOUCH_2ND_GENERATION, // iPod touch (2nd generation) 320x480 320x480 @1x
    iPod_TOUCH_3RD_GENERATION, // iPod touch (3rd generation) 320x480 320x480 @1x
    iPod_TOUCH_4TH_GENERATION, // iPod touch (4th generation) 320x480 640x960 @2x
    iPod_TOUCH_5TH_GENREATION, // iPod touch (5th generation) 320x568 640x1136 @2x
    iPod_TOUCH_6TH_GENERATION // iPod touch (6th generation) 320x568 640x1136 @2x
};

@interface NSString (VTPhoneInfo)

#pragma mark - 获取手机序列号
- (NSString *)identifierNumber;

#pragma mark - 获取手机别名
- (NSString *)userPhoneName;

#pragma mark - 获取设备名称
- (NSString *)deviceName;

#pragma mark - 获取手机系统版本
- (NSString *)phoneVersion;

#pragma mark - 获取手机型号
- (NSString *)phoneModel;

#pragma mark - 获取地方型号（国际化区域名称)
- (NSString *)localPhoneModel;

#pragma mark - 获取当前应用名称
- (NSString *)appCurName;

#pragma mark - 获取当前应用软件版本
- (NSString *)appCurVersion;

#pragma mark - 获取当前应用版本号码
- (NSString *)appCurVersionNum;

/**
 判断当前手机的型号为4、4s、5、5s、6、6p、6s、6sp、7、7p、8、8p、x
 
 @return  设备型号枚举类型kDeviceType
 */
+ (kDeviceType)currentDeviceType;

/**
 判断是否是iPhoneX
 
 @return iPhoneX判断结果
 */
+ (BOOL)isIphoneX;

@end
