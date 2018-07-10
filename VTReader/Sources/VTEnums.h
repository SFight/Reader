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

typedef NS_OPTIONS(NSInteger, FontSize) {
    FontSize_8 = 8, // 8号字体
    FontSize_12 = 12, // 12号字体
    FontSize_14 = 14, // 14号字
    FontSize_15,
    FontSize_16,
    FontSize_17
};

@interface VTEnums : NSObject

@end
