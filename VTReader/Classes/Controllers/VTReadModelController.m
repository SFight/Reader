//
//  VTReadModelController.m
//  VTEpub
//
//  Created by JinJie Song on 2018/3/31.
//  Copyright © 2018年 JinJie Song. All rights reserved.
//

#import "VTReadModelController.h"
#import "VTReadDataViewController.h"

@implementation VTReadModelController

#pragma mark - 初始化开始控制器
- (VTReadDataViewController *)generateStartViewController
{
    VTReadDataViewController *dataVC = [[VTReadDataViewController alloc] init];
    return dataVC;
}

#pragma mark - 计算控制器
- (VTReadDataViewController *)viewControllerAtIndex:(NSInteger)index
{
    VTReadDataViewController *dataVC = [[VTReadDataViewController alloc] init];
    dataVC.pageIndex = index;
    return dataVC;
}

- (NSInteger)indexOfViewController:(VTReadDataViewController *)dataVC
{
    return dataVC.pageIndex;
}

#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [self indexOfViewController:(VTReadDataViewController *)viewController];
    index--;
    if (index == NSNotFound) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [self indexOfViewController:(VTReadDataViewController *)viewController];
    index++;
    
    return [self viewControllerAtIndex:index];
}

@end
