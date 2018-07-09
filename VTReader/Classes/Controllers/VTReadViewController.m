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

#import "VTReadMenuView.h"

#import "NSString+VTPhoneInfo.h"

NSString *const kNotificationShowOrHideMenu = @"kNotificationShowOrHideMenu"; // 展示或隐藏上下菜单的通知

@interface VTReadViewController ()

/** 翻页控制器容器 */
@property (nonatomic, strong) VTPageViewController *pageVC;

/** 翻页控制器的数据源代理 */
@property (nonatomic, strong) VTReadModelController *modelController;

///** 顶部菜单背景 */
//@property (nonatomic, strong) UIView *topMenuBgView;
///** 顶部菜单 */
//@property (nonatomic, strong) VTReadTopMenuView *topMenuView;
///** 底部菜单背景 */
//@property (nonatomic, strong) UIView *bottomMenuBgView;
///** 底部菜单 */
//@property (nonatomic, strong) VTReadBottomMenuView *bottomMenuView;

/** 菜单界面 */
@property (nonatomic, strong) VTReadMenuView *menuView;

/** statusBar的显示和隐藏 */
@property (nonatomic) BOOL hiddenStatusBar;

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

- (VTReadMenuView *)menuView
{
    if (!_menuView) {
        _menuView = [[VTReadMenuView alloc] initWithFrame:self.contentView.bounds];
    }
    
    return _menuView;
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
    
    _hiddenStatusBar = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    
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
//    CGFloat originX = 0;
//    CGFloat originY = 0;
//    CGFloat width = CGRectGetWidth(self.view.frame);
//    CGFloat height = [NSString isIphoneX] ? 88 : 64; // iPhoneX StatusBar高44px，NavigationBar高44px，底部TabBar高83px
//                                                                        // 普通 StatusBar高20px，NavigationBar高44px，底部TabBar高49px
//
//    _topMenuBgView = [[UIView alloc] initWithFrame:CGRectMake(originX, originY, width, height)];
//    self.topMenuBgView.backgroundColor = [UIColor colorForReaderMenu];
//    self.topMenuBgView.hidden = YES;
//
//    originY = [NSString isIphoneX] ? 44 : 20;
//    height = CGRectGetHeight(self.topMenuBgView.frame) - originY;
//    _topMenuView = [[VTReadTopMenuView alloc] initWithFrame:CGRectMake(originX, originY, width, height)];
//    [self.topMenuBgView addSubview:self.topMenuView];
//
//    height = [NSString isIphoneX] ? 220 + 34 : 220;
//    originY = CGRectGetHeight(self.view.frame) - height;
//
//    _bottomMenuBgView = [[UIView alloc] initWithFrame:CGRectMake(originX, originY, width, height)];
//    self.bottomMenuBgView.backgroundColor = [UIColor colorForReaderMenu];
//    self.bottomMenuBgView.hidden = YES;
//
//    originY = 0;
//    height = [NSString isIphoneX] ? CGRectGetHeight(self.bottomMenuBgView.frame) - 34 : CGRectGetHeight(self.bottomMenuBgView.frame);
//    _bottomMenuView = [[VTReadBottomMenuView alloc] initWithFrame:CGRectMake(originX, originY, width, height)];
//    [self.bottomMenuBgView addSubview:self.bottomMenuView];
//
//    [self.contentView addSubview:self.topMenuBgView];
//    [self.contentView addSubview:self.bottomMenuBgView];
    self.menuView.hidden = YES;
    [self.contentView addSubview:self.menuView];
}

#pragma mark - Override
- (BOOL)prefersStatusBarHidden
{
    return self.hiddenStatusBar;
}

#pragma mark - NSNotification 通知展示菜单
- (void)onNotificationShowMenu:(NSNotification *)notification
{
//    CATransition *animation = [CATransition animation];
//    animation.type = kCATransitionFade;
//    animation.duration = 0.5;
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    [self.topMenuBgView.layer addAnimation:animation forKey:nil] ;
//    [self.bottomMenuBgView.layer addAnimation:animation forKey:nil];
//
//    self.topMenuBgView.hidden = !self.topMenuBgView.hidden;
//    self.hiddenStatusBar = self.topMenuBgView.hidden;
//    [self setNeedsStatusBarAppearanceUpdate];
//    self.bottomMenuBgView.hidden = !self.bottomMenuBgView.hidden;
    
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.5;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.menuView.layer addAnimation:animation forKey:nil];
    
    self.menuView.hidden = !self.menuView.hidden;
    self.hiddenStatusBar = self.menuView.hidden;
    [self setNeedsStatusBarAppearanceUpdate];
    
    
    
}

@end
