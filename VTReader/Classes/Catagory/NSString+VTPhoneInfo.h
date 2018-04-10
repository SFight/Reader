//
//  NSString+VTPhoneInfo.h
//  VTEpub
//
//  Created by JinJie Song on 2018/4/9.
//  Copyright © 2018年 JinJie Song. All rights reserved.
//

#import <Foundation/Foundation.h>

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

@end
