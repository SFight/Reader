//
//  VTBaseViewController.h
//  VTEpub
//
//  Created by JinJie Song on 2018/3/31.
//  Copyright © 2018年 JinJie Song. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTBaseViewController : UIViewController

/** 内容视图，用于添加所有的子视图所用 */
@property (nonatomic, strong, readonly) UIView *contentView;
/** 内容视图，用于添加所有的子视图所用（可滚动） */
@property (nonatomic, strong, readonly) UIScrollView *containerView;

@end
