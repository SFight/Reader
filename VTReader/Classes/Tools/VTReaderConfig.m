//
//  VTReaderConfig.m
//  VTReader
//
//  Created by JinJie Song on 2018/4/13.
//  Copyright © 2018年 JinJie Song. All rights reserved.
//

#import "VTReaderConfig.h"

@interface VTReaderConfig()

/** 字体名称 */
@property (nonatomic, copy) NSString *fontName;
/** 字体大小 */
@property (nonatomic, assign) NSInteger fontSize;

@end

static VTReaderConfig *_config = nil;

@implementation VTReaderConfig

#pragma mark - 单利
+ (VTReaderConfig *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_config) {
            _config = [[self alloc] init];
            _config.fontSize = 14;
            _config.fontName = @"Times New Roman";
        }
    });
    
    return _config;
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.fontName ? self.fontName : @"Times New Roman" forKey:@"fontName"];
    [aCoder encodeInteger:self.fontSize ? self.fontSize : 14 forKey:@"fontSize"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [VTReaderConfig sharedInstance];
    if (self) {
        _fontName = [aDecoder decodeObjectForKey:@"fontName"] ? [aDecoder decodeObjectForKey:@"fontName"] : @"Times New Roman";
        _fontSize = [aDecoder decodeIntegerForKey:@"fontSize"] ? [aDecoder decodeIntegerForKey:@"fontSize"] : 14;
    }
    
    return self;
}

#pragma mark - 归档、解档
- (void)archive
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *homePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"ReaderConfig.plist"]];
    [NSKeyedArchiver archiveRootObject:_config toFile:homePath];
//    //1:准备路径
//    NSString *path = NSHomeDirectory();
//    path = [path stringByAppendingString:@"Singel.plist"];
//    //2:准备存储数据对象(用可变数组进行接收)
//    NSMutableData *data = [NSMutableData new];
//    //3:创建归档对象
//    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
//    //4:开始归档
//    [archiver encodeObject:self forKey:@"ReaderConfig"];
//    //5:完成归档
//    [archiver finishEncoding];
//    //6:写入文件
//    BOOL result = [data writeToFile:path atomically:YES];
//    if (result) {
//        VTLog(@"归档成功:%@",path);
//    }
//
//    return result;
}

- (void)unArchive
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *homePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"ReaderConfig.plist"]];
    [NSKeyedUnarchiver unarchiveObjectWithFile:homePath];
    
    
    //1:准备路径
//    NSString *path = NSHomeDirectory();
//    path = [path stringByAppendingString:@"Singel.plist"];
//    //1:获取解档路径
//    NSData *MyData = [NSData dataWithContentsOfFile:path];
//    //2:创建反归档对象
//    NSKeyedUnarchiver  *unarchiver= [[NSKeyedUnarchiver alloc]initForReadingWithData:MyData];
//    //3:反归档
//    _config = [unarchiver decodeObjectForKey:@"ReaderConfig"];
//    //4:结束归档
//    [unarchiver finishDecoding];
//    VTLog(@"%@", _config.fontName);
//    return _config ? YES : NO;
}

@end
