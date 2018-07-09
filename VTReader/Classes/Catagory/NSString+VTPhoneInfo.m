//
//  NSString+VTPhoneInfo.m
//  VTEpub
//
//  Created by JinJie Song on 2018/4/9.
//  Copyright © 2018年 JinJie Song. All rights reserved.
//

#import "NSString+VTPhoneInfo.h"

#import <sys/utsname.h>

@implementation NSString (VTPhoneInfo)

#pragma mark - 获取手机序列号
- (NSString *)identifierNumber
{
    //手机序列号
    NSUUID *uuid = [[UIDevice currentDevice] identifierForVendor];
    NSString *identifierNumber = [uuid UUIDString];
    
    VTLog(@"手机序列号: %@",identifierNumber);
    
    return identifierNumber;
}

#pragma mark - 获取手机别名
- (NSString *)userPhoneName
{
    //手机别名： 用户定义的名称
    
    NSString *userPhoneName = [[UIDevice currentDevice] name];
    
    VTLog(@"手机别名: %@", userPhoneName);
    
    return userPhoneName;
}

#pragma mark - 获取设备名称
- (NSString *)deviceName
{
    //设备名称
    
    NSString *deviceName = [[UIDevice currentDevice] systemName];
    
    VTLog(@"设备名称: %@",deviceName );
    
    return deviceName;
}

#pragma mark - 获取手机系统版本
- (NSString *)phoneVersion
{
    //手机系统版本
    
    NSString *phoneVersion = [[UIDevice currentDevice] systemVersion];
    
    VTLog(@"手机系统版本: %@", phoneVersion);
    
    return phoneVersion;
}

#pragma mark - 获取手机型号
- (NSString *)phoneModel
{
    //手机型号
    
    NSString *phoneModel = [[UIDevice currentDevice] model];
    
    VTLog(@"手机型号: %@",phoneModel );
    
    return phoneModel;
}

#pragma mark - 获取地方型号（国际化区域名称)
- (NSString *)localPhoneModel
{
    //地方型号  （国际化区域名称）
    
    NSString *localPhoneModel = [[UIDevice currentDevice] localizedModel];
    
    VTLog(@"国际化区域名称: %@",localPhoneModel );
    
    return localPhoneModel;
}

#pragma mark - 获取当前应用名称
- (NSString *)appCurName
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    // 当前应用名称
    
    NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    
    VTLog(@"当前应用名称：%@",appCurName);
    
    return appCurName;
}

#pragma mark - 获取当前应用软件版本
- (NSString *)appCurVersion
{
    // 当前应用软件版本  比如：1.0.1
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    VTLog(@"当前应用软件版本:%@",appCurVersion);
    
    return appCurVersion;
}

#pragma mark - 获取当前应用版本号码
- (NSString *)appCurVersionNum
{
    // 当前应用版本号码  int类型
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    VTLog(@"当前应用版本号码：%@",appCurVersionNum);
    
    return appCurVersionNum;
}

#pragma mark - 设备类型获取
+ (kDeviceType)currentDeviceType
{
    // 参考模型来源：https://www.theiphonewiki.com/wiki/Models
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //simulator
    if ([@"i386" isEqualToString:deviceString] || [@"x86_64" isEqualToString:deviceString]) return Simulator;
    
    //AirPods
    if ([@"AirPods1,1" isEqualToString:deviceString]) {
        return Air_Pods;
    }
    
    //Apple TV
    if ([@"AppleTV2,1" isEqualToString:deviceString])    return Apple_TV_2ND_GENERATION;
    if ([@"AppleTV3,1" isEqualToString:deviceString])    return Apple_TV_3RD_GENERATION;
    if ([@"AppleTV3,2" isEqualToString:deviceString])    return Apple_TV_3RD_GENERATION;
    if ([@"AppleTV5,3" isEqualToString:deviceString])    return Apple_TV_4TH_GENERATION;
    if ([@"AppleTV6,2" isEqualToString:deviceString])    return Apple_TV_4K;
    
    //Apple Watch
    if ([@"Watch1,1" isEqualToString:deviceString])    return Apple_Watch_1ST_GENERATION;
    if ([@"Watch1,2" isEqualToString:deviceString])    return Apple_Watch_1ST_GENERATION;
    if ([@"Watch2,6" isEqualToString:deviceString])    return Apple_Watch_Series_1;
    if ([@"Watch2,7" isEqualToString:deviceString])    return Apple_Watch_Series_1;
    if ([@"Watch2,3" isEqualToString:deviceString])    return Apple_Watch_Series_2;
    if ([@"Watch2,4" isEqualToString:deviceString])    return Apple_Watch_Series_2;
    if ([@"Watch3,1" isEqualToString:deviceString])    return Apple_Watch_Series_3;
    if ([@"Watch3,2" isEqualToString:deviceString])    return Apple_Watch_Series_3;
    if ([@"Watch3,3" isEqualToString:deviceString])    return Apple_Watch_Series_3;
    if ([@"Watch3,4" isEqualToString:deviceString])    return Apple_Watch_Series_3;
    
    //HomePod
    if ([@"AudioAccessory1,1" isEqualToString:deviceString])    return Home_Pod;
    
    //iPad
    if ([@"iPad1,1" isEqualToString:deviceString])    return iPad;
    if ([@"iPad2,1" isEqualToString:deviceString])    return iPad_2;
    if ([@"iPad2,2" isEqualToString:deviceString])    return iPad_2;
    if ([@"iPad2,3" isEqualToString:deviceString])    return iPad_2;
    if ([@"iPad2,4" isEqualToString:deviceString])    return iPad_2;
    if ([@"iPad3,1" isEqualToString:deviceString])    return iPad_3RD_GENERATION;
    if ([@"iPad3,2" isEqualToString:deviceString])    return iPad_3RD_GENERATION;
    if ([@"iPad3,3" isEqualToString:deviceString])    return iPad_3RD_GENERATION;
    if ([@"iPad3,4" isEqualToString:deviceString])    return iPad_4TH_GENERATION;
    if ([@"iPad3,5" isEqualToString:deviceString])    return iPad_4TH_GENERATION;
    if ([@"iPad3,6" isEqualToString:deviceString])    return iPad_4TH_GENERATION;
    if ([@"iPad4,1" isEqualToString:deviceString])    return iPad_Air;
    if ([@"iPad4,2" isEqualToString:deviceString])    return iPad_Air;
    if ([@"iPad4,3" isEqualToString:deviceString])    return iPad_Air;
    if ([@"iPad5,3" isEqualToString:deviceString])    return iPad_Air_2;
    if ([@"iPad5,4" isEqualToString:deviceString])    return iPad_Air_2;
    if ([@"iPad6,7" isEqualToString:deviceString])    return iPad_Pro_12_9;
    if ([@"iPad6,8" isEqualToString:deviceString])    return iPad_Pro_12_9;
    if ([@"iPad6,3" isEqualToString:deviceString])    return iPad_Pro_9_7;
    if ([@"iPad6,4" isEqualToString:deviceString])    return iPad_Pro_9_7;
    if ([@"iPad6,11" isEqualToString:deviceString])    return iPad_5TH_GENERATION;
    if ([@"iPad6,12" isEqualToString:deviceString])    return iPad_5TH_GENERATION;
    if ([@"iPad7,1" isEqualToString:deviceString])    return iPad_Pro_12_9_2ND;
    if ([@"iPad7,2" isEqualToString:deviceString])    return iPad_Pro_12_9_2ND;
    if ([@"iPad7,3" isEqualToString:deviceString])    return iPad_Pro_10_5;
    if ([@"iPad7,4" isEqualToString:deviceString])    return iPad_Pro_10_5;
    if([@"iPad7,5" isEqualToString:deviceString])     return iPad_6TH_GENERATION;
    if([@"iPad7,6" isEqualToString:deviceString])     return iPad_6TH_GENERATION;
    
    //iPad mini
    if ([@"iPad2,5" isEqualToString:deviceString])    return iPad_MINI;
    if ([@"iPad2,6" isEqualToString:deviceString])    return iPad_MINI;
    if ([@"iPad2,7" isEqualToString:deviceString])    return iPad_MINI;
    if ([@"iPad4,4" isEqualToString:deviceString])    return iPad_MINI_2;
    if ([@"iPad4,5" isEqualToString:deviceString])    return iPad_MINI_2;
    if ([@"iPad4,6" isEqualToString:deviceString])    return iPad_MINI_2;
    if ([@"iPad4,7" isEqualToString:deviceString])    return iPad_MINI_3;
    if ([@"iPad4,8" isEqualToString:deviceString])    return iPad_MINI_3;
    if ([@"iPad4,9" isEqualToString:deviceString])    return iPad_MINI_3;
    if ([@"iPad5,1" isEqualToString:deviceString])    return iPad_MINI_4;
    if ([@"iPad5,2" isEqualToString:deviceString])    return iPad_MINI_4;
    
    //iPhone
    if ([@"iPhone1,1" isEqualToString:deviceString])     return iPhone_1G;
    if ([@"iPhone1,2" isEqualToString:deviceString])     return iPhone_3G;
    if ([@"iPhone2,1" isEqualToString:deviceString])     return iPhone_3GS;
    if ([@"iPhone3,1" isEqualToString:deviceString])     return iPhone_4;
    if ([@"iPhone3,2" isEqualToString:deviceString])     return iPhone_4;
    if([@"iPhone3,3" isEqualToString:deviceString])      return iPhone_4;
    if ([@"iPhone4,1" isEqualToString:deviceString])     return iPhone_4S;
    if ([@"iPhone5,1" isEqualToString:deviceString])     return iPhone_5;
    if ([@"iPhone5,2" isEqualToString:deviceString])     return iPhone_5;
    if ([@"iPhone5,3" isEqualToString:deviceString])     return iPhone_5C;
    if ([@"iPhone5,4" isEqualToString:deviceString])     return iPhone_5C;
    if ([@"iPhone6,1" isEqualToString:deviceString])     return iPhone_5S;
    if ([@"iPhone6,2" isEqualToString:deviceString])     return iPhone_5S;
    if ([@"iPhone7,2" isEqualToString:deviceString])     return iPhone_6;
    if ([@"iPhone7,1" isEqualToString:deviceString])     return iPhone_6_PLUS;
    if ([@"iPhone8,1" isEqualToString:deviceString])     return iPhone_6S;
    if ([@"iPhone8,2" isEqualToString:deviceString])     return iPhone_6S_PLUS;
    if ([@"iPhone8,4" isEqualToString:deviceString])     return iPhone_SE;
    if ([@"iPhone9,1" isEqualToString:deviceString])     return iPhone_7;
    if ([@"iPhone9,3" isEqualToString:deviceString])     return iPhone_7;
    if ([@"iPhone9,2" isEqualToString:deviceString])     return iPhone_7_PLUS;
    if ([@"iPhone9,4" isEqualToString:deviceString])     return iPhone_7_PLUS;
    if ([@"iPhone10,1" isEqualToString:deviceString])    return iPhone_8;
    if ([@"iPhone10,4" isEqualToString:deviceString])    return iPhone_8;
    if ([@"iPhone10,2" isEqualToString:deviceString])    return iPhone_8_PLUS;
    if ([@"iPhone10,5" isEqualToString:deviceString])    return iPhone_8_PLUS;
    if ([@"iPhone10,3" isEqualToString:deviceString])    return iPhone_X;
    if ([@"iPhone10,6" isEqualToString:deviceString])    return iPhone_X;
    
    //iPod touch
    if ([@"iPod1,1" isEqualToString:deviceString])    return iPod_TOUCH;
    if ([@"iPod2,1" isEqualToString:deviceString])    return iPod_TOUCH_2ND_GENERATION;
    if ([@"iPod3,1" isEqualToString:deviceString])    return iPod_TOUCH_3RD_GENERATION;
    if ([@"iPod4,1" isEqualToString:deviceString])    return iPod_TOUCH_4TH_GENERATION;
    if ([@"iPod5,1" isEqualToString:deviceString])    return iPod_TOUCH_5TH_GENREATION;
    if ([@"iPod7,1" isEqualToString:deviceString])    return iPod_TOUCH_6TH_GENERATION;
    
    return None_Type;
}

+ (BOOL)isIphoneX
{
    kDeviceType deviceType = [self currentDeviceType];
    if (deviceType == Simulator) {
        // 模拟器根据屏幕尺寸判断iPhoneX
        CGRect nativeBounds = [[UIScreen mainScreen] nativeBounds];
        if(CGSizeEqualToSize(CGSizeMake(1125.f, 2436.f),  nativeBounds.size)) return YES;
    }
    
    if (deviceType == iPhone_X) return YES;
    
    return NO;
}

@end
