//
//  VTReadDataViewController.h
//  VTEpub
//
//  Created by JinJie Song on 2018/3/31.
//  Copyright © 2018年 JinJie Song. All rights reserved.
//

#import "VTBaseViewController.h"

#import "VTDataReaderChapter.h"

@interface VTReadDataViewController : VTBaseViewController

/** 当前控制器处于第几页 */
@property (nonatomic, assign) NSInteger pageIndex;

/** 要解析的章节 */
@property (nonatomic, strong) VTDataReaderChapter *chapter;
/** 要展示的页 */
@property (nonatomic, strong) id page;

@end
