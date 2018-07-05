//
//  VTReadModelController.h
//  VTEpub
//
//  Created by JinJie Song on 2018/3/31.
//  Copyright © 2018年 JinJie Song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "VTDataReader.h"

@class VTReadDataViewController;

@interface VTReadModelController : NSObject<UIPageViewControllerDataSource>

@property (nonatomic, strong) VTDataReader *dataReader;

/**
 * 生成开始的控制器
 * @return VTReadDataViewController
 */
- (VTReadDataViewController *)generateStartViewController;

@end
