//
//  VTReaderManager.m
//  VTReader
//
//  Created by JinJie Song on 2018/4/10.
//  Copyright © 2018年 JinJie Song. All rights reserved.
//

#import "VTReaderManager.h"

#import "VTEpubManager.h"
#import "VTTXTManager.h"
#import "VTPDFManager.h"

#import "VTReaderConfig.h"

#import "VTReadViewController.h"

@interface VTReaderManager()

@property (nonatomic, copy) UIWindow *window;

@end

static VTReaderManager *_manager = nil;

@implementation VTReaderManager

#pragma mark - 单利控制器
+ (VTReaderManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_manager) {
            _manager = [[VTReaderManager alloc] init];
        }
    });
    
    return _manager;
}

#pragma mark - 打开阅读器
- (BOOL)openReaderWithPath:(NSURL *_Nonnull)path type:(NSString *_Nonnull)readType inViewController:(nullable UIViewController *)viewController onDismiss:(DismissBlock)dismissBlock
{
    if (path == nil) {
        VTLog(@"打开阅读器失败，文件路径为空");
        @throw [NSException exceptionWithName:@"打开阅读器失败" reason:@"阅读器文件路径不能为空" userInfo:nil];
        return NO;
    }
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[path path]]) {
        VTLog(@"打开阅读器失败，文件不存在：%@", path);
        @throw [NSException exceptionWithName:@"打开阅读器失败" reason:@"文件不存在" userInfo:nil];
        return NO;
    }
    
    // 解档
    [[VTReaderConfig sharedInstance] unArchive];
    
    if ([VT_READER_TYPE_TXT isEqualToString:readType]) {
        
        return [self openTxtReaderWithPath:path inViewController:viewController onDismiss:dismissBlock];
    }
    
    if ([VT_READER_TYPE_EPUB isEqualToString:readType]) {
        
        return [self openEpubReaderWithPath:path inViewController:viewController onDismiss:dismissBlock];
    }
    
    if ([VT_READER_TYPE_PDF isEqualToString:readType]) {
        
        return [self openPDFReaderWithPath:path inViewController:viewController onDismiss:dismissBlock];
    }
    
    return NO;
}

#pragma mark - txt阅读器
- (BOOL)openTxtReaderWithPath:(NSURL *_Nonnull)txtPath inViewController:(nullable UIViewController *)viewController onDismiss:(DismissBlock)dismissBlock
{
    return YES;
}

#pragma mark - epub阅读器
- (BOOL)openEpubReaderWithPath:(NSURL *_Nonnull)epubPath inViewController:(nullable UIViewController *)viewController onDismiss:(DismissBlock)dismissBlock
{
    // 交给epub的控制器去处理
    VTDataReader *dataReader = [[VTEpubManager sharedInstance] praserEpub:[epubPath path]];
    
    VTReadViewController *readVC = [[VTReadViewController alloc] init];
    readVC.dataReader = dataReader;
    [viewController presentViewController:readVC animated:YES completion:^{
        
    }];
    return YES;
}

#pragma mark - pdf阅读器
- (BOOL)openPDFReaderWithPath:(NSURL *_Nonnull)pdfPath inViewController:(nullable UIViewController *)viewController onDismiss:(DismissBlock)dismissBlock
{
    return YES;
}

@end
