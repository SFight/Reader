//
//  VTReadViewController.m
//  VTEpub
//
//  Created by JinJie Song on 2018/3/31.
//  Copyright © 2018年 JinJie Song. All rights reserved.
//

#import "VTReadViewController.h"
#import "VTPageViewController.h"
#import "VTReadModelController.h"

#import "VTReaderConfig.h"

@interface VTReadViewController ()

/** 翻页控制器容器 */
@property (nonatomic, strong) VTPageViewController *pageVC;

/** 翻页控制器的数据源代理 */
@property (nonatomic, strong) VTReadModelController *modelController;

@end

@implementation VTReadViewController

#pragma mark - lazyInit
- (VTReadModelController *)modelController
{
    if (!_modelController) {
        _modelController = [[VTReadModelController alloc] init];
    }
    
    return _modelController;
}

#pragma mark - 生命周期
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 归档，存储阅读数据
    [[VTReaderConfig sharedInstance] archive];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _pageVC = [[VTPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageVC.dataSource = self.modelController;
    
    // 设置控制器的数据源
    self.modelController.dataReader = self.dataReader;
    
    UIViewController *startingViewController = (UIViewController *)[self.modelController generateStartViewController];
    NSArray *viewControllers = @[startingViewController];
    [self.pageVC setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self.contentView addSubview:self.pageVC.view];
    [self addChildViewController:self.pageVC];
    
    [self.pageVC didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
