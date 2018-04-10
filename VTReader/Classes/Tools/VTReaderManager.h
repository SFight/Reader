//
//  VTReaderManager.h
//  VTReader
//
//  Created by JinJie Song on 2018/4/10.
//  Copyright © 2018年 JinJie Song. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef BOOL(^DismissBlock)(UIViewController * _Nonnull viewController);

@interface VTReaderManager : NSObject

/**
 阅读器控制单利
 
 @return VTEpubManager  阅读器控制器
 */
+ (VTReaderManager *_Nonnull)sharedInstance;


/**
 根据文件路径，类型打开阅读器
 
 @param path 文件路径
 @param readType 阅读器类型(VT_READER_TYPE_TXT、VT_READER_TYPE_PDF、VTREADER_TYPE_EPUB)
 @param viewController 打开阅读器所在的控制器
 @param dismissBlock 阅读器关闭后回调的block
 @return 打开成功与否的标志 NO：失败 YES：成功
 */
- (BOOL)openReaderWithPath:(NSURL *_Nonnull)path type:(NSString *_Nonnull)readType inViewController:(nullable UIViewController *)viewController onDismiss:(DismissBlock _Nonnull )dismissBlock;

@end
