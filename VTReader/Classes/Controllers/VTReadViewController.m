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

#import "VTReadTopMenuView.h"
#import "VTReadBottomMenuView.h"

#import "NSString+VTPhoneInfo.h"

NSString *const kNotificationShowOrHideMenu = @"kNotificationShowOrHideMenu"; // 展示或隐藏上下菜单的通知

@interface VTReadViewController ()

/** 翻页控制器容器 */
@property (nonatomic, strong) VTPageViewController *pageVC;

/** 翻页控制器的数据源代理 */
@property (nonatomic, strong) VTReadModelController *modelController;

/** 顶部菜单 */
@property (nonatomic, strong) VTReadTopMenuView *topMenuView;
/** 底部菜单 */
@property (nonatomic, strong) VTReadBottomMenuView *bottomMenuView;

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
    
    [self addMenuView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotificationShowMenu:) name:kNotificationShowOrHideMenu object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 添加菜单视图
- (void)addMenuView
{
    CGFloat originX = 0;
    CGFloat originY = 0;
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = [NSString isIphoneX] ? 88 : 64; // iPhoneX StatusBar高44px，NavigationBar高44px，底部TabBar高83px
                                                                        // 普通 StatusBar高20px，NavigationBar高44px，底部TabBar高49px
    _topMenuView = [[VTReadTopMenuView alloc] initWithFrame:CGRectMake(originX, originY, width, height)];
    self.topMenuView.backgroundColor = [UIColor redColor];
    self.topMenuView.hidden = YES;
    
    height = [NSString isIphoneX] ? 83 : 49;
    originY = CGRectGetHeight(self.view.frame) - height;
    _bottomMenuView = [[VTReadBottomMenuView alloc] initWithFrame:CGRectMake(originX, originY, width, height)];
    self.bottomMenuView.backgroundColor = [UIColor purpleColor];
    self.bottomMenuView.hidden = YES;
    
    [self.contentView addSubview:self.topMenuView];
    [self.contentView addSubview:self.bottomMenuView];
}

#pragma mark - NSNotification 通知展示菜单
- (void)onNotificationShowMenu:(NSNotification *)notification
{
    [UIView animateWithDuration:0.5f animations:^{
        self.topMenuView.hidden = !self.topMenuView.hidden;
        self.bottomMenuView.hidden = !self.bottomMenuView.hidden;
    }];
}

@end
