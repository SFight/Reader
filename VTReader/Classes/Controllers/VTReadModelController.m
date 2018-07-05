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

#pragma mark - 取一章的数据
- (NSInteger)indexOfChapter:(VTDataReaderChapter *)chapter
{
    return [self.dataReader.chapters indexOfObject:chapter];
}

- (VTDataReaderChapter *)chapterAtIndex:(NSInteger)index
{
    if (self.dataReader.chapters.count > index && index >= 0) {
        return self.dataReader.chapters[index];
    }
    
    return nil;
}

#pragma mark - 初始化开始控制器
- (VTReadDataViewController *)generateStartViewController
{
    VTReadDataViewController *dataVC = [[VTReadDataViewController alloc] init];
    dataVC.pageIndex = 0;
    VTDataReaderChapter *chapter = [self chapterAtIndex:0];
    if (chapter) {
        dataVC.chapter = chapter;
        dataVC.page = [[chapter pages] objectAtIndex:0];
    }
    
    return dataVC;
}

#pragma mark - 计算控制器
- (VTReadDataViewController *)viewControllerAtIndex:(NSInteger)index withChapter:(NSInteger)chapter
{
    if (index < 0 || chapter == NSNotFound) {
        return nil;
    }
    VTReadDataViewController *dataVC = [[VTReadDataViewController alloc] init];
    dataVC.pageIndex = index;
    dataVC.chapter = [self chapterAtIndex:chapter];
    if (dataVC.chapter) {
        dataVC.page = [[dataVC.chapter pages] objectAtIndex:index];
    }
    return dataVC;
}

- (NSInteger)indexOfViewController:(VTReadDataViewController *)dataVC
{
    return dataVC.pageIndex;
}

#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    VTReadDataViewController *dataVC = (VTReadDataViewController *)viewController;
    
    NSInteger index = [self indexOfViewController:dataVC];
    NSInteger chapter = [self indexOfChapter:dataVC.chapter];
    
    index--;
    
    if (index < 0) {
        // 当前章节展示完毕，返回上一章节的最后一页数据
        NSInteger count = [[[self chapterAtIndex:(chapter - 1)] pages] count];
        return [self viewControllerAtIndex:(count - 1) withChapter:(chapter - 1)];
    }
    
    return [self viewControllerAtIndex:index withChapter:chapter];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    VTReadDataViewController *dataVC = (VTReadDataViewController *)viewController;
    
    NSInteger index = [self indexOfViewController:dataVC];
    NSInteger chapter = [self indexOfChapter:dataVC.chapter];
    
    NSInteger count = [[[self chapterAtIndex:chapter] pages] count];
    
    index++;
    
    if (index >= count) {
        // 当前章节展示完毕，返回下一章节的第一页数据
        return [self viewControllerAtIndex:0 withChapter:(chapter + 1)];
    }
    
    return [self viewControllerAtIndex:index withChapter:chapter];
}

@end
