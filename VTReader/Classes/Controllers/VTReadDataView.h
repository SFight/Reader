//
//  VTReadDataView.h
//  VTReader
//
//  Created by JinJie Song on 2018/4/12.
//  Copyright © 2018年 JinJie Song. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VTDataReaderChapter;

@interface VTReadDataView : UIView

/**
 初始化数据源视图

 @param frame 视图大小
 @param chapter 章节数据
 @return 视图实例
 */
- (instancetype)initWithFrame:(CGRect)frame chapter:(VTDataReaderChapter *)chapter page:(id)page;

@end
