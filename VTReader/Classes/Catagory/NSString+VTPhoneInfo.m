//
//  NSString+VTPhoneInfo.m
//  VTEpub
//
//  Created by JinJie Song on 2018/4/9.
//  Copyright © 2018年 JinJie Song. All rights reserved.
//

#import "NSString+VTPhoneInfo.h"

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

@end
