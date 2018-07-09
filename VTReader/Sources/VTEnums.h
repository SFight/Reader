//
//  VTEnums.h
//  VTEpub
//
//  Created by JinJie Song on 2018/4/9.
//  Copyright © 2018年 JinJie Song. All rights reserved.
//

#import <Foundation/Foundation.h>

UIKIT_EXTERN NSString * const VT_READER_TYPE_TXT; // 阅读器为文本格式
UIKIT_EXTERN NSString * const VT_READER_TYPE_EPUB; // 阅读器为epub格式
UIKIT_EXTERN NSString * const VT_READER_TYPE_PDF; // 阅读器为pdf格式

typedef NS_OPTIONS(NSInteger, CenterWidth) {
    CenterWidth_Default = 1<<7
};

@interface VTEnums : NSObject

@end
