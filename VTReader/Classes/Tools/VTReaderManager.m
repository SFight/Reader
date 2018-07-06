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
#import "VTWindow.h"

NSString *const kNotificationCloseReader = @"kNotificationCloseReader"; // 关闭阅读器的通知
NSString *const kAnimationOpenReader = @"kAnimationOpenReader"; // 打开阅读器的动画key值
NSString *const kAnimationCloseReader = @"kAnimationCloseReader"; // 关闭阅读器的动画key值

@interface VTReaderManager()

@property (nonatomic, strong) VTWindow *window;

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
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:readVC];
    [nav setNavigationBarHidden:YES];
    
    _window = [[VTWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = nav;
    
    CATransition *animation = [CATransition animation];
//    animation.type = @"push";
//    animation.subtype = @"fromTop";
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = 0.3f;
    [self.window.layer addAnimation:animation forKey:kAnimationOpenReader];
    
    self.window.windowLevel = UIWindowLevelAlert;
    [self.window becomeKeyWindow];
    [self.window becomeFirstResponder];
    self.window.alpha = 1.0f;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotificatoinCloseReader:) name:kNotificationCloseReader object:nil];
    
    return YES;
}

#pragma mark - pdf阅读器
- (BOOL)openPDFReaderWithPath:(NSURL *_Nonnull)pdfPath inViewController:(nullable UIViewController *)viewController onDismiss:(DismissBlock)dismissBlock
{
    return YES;
}

#pragma mark - 通知关闭阅读器
- (void)onNotificatoinCloseReader:(NSNotification *)notification
{
    CATransition *animation = [CATransition animation];
//    animation.type = @"reveal";
//    animation.subtype = @"fromBottom";
    animation.type = kCATransitionReveal;
    animation.subtype = kCATransitionFromBottom;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    animation.duration = 0.3f;
    [self.window.layer addAnimation:animation forKey:kAnimationCloseReader];
    
    [self.window resignKeyWindow];
    [self.window resignFirstResponder];
    self.window.alpha = 0.0f;
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        _window = nil;
    });
//    _window = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark - 销毁
- (void)dealloc
{
    VTLog(@"阅读器要销毁了");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
