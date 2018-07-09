//
//  VTReadMenuView.m
//  VTReader
//
//  Created by vtears on 2018/7/6.
//  Copyright © 2018年 JinJie Song. All rights reserved.
//

#import "VTReadMenuView.h"

#import "VTReadTopMenuView.h"
#import "VTReadBottomMenuView.h"

extern NSString *const kNotificationShowOrHideMenu;

@interface VTReadMenuView()<UIGestureRecognizerDelegate>

/** 顶部菜单背景 */
@property (nonatomic, strong) UIView *topMenuBgView;
/** 顶部菜单 */
@property (nonatomic, strong) VTReadTopMenuView *topMenuView;
/** 底部菜单背景 */
@property (nonatomic, strong) UIView *bottomMenuBgView;
/** 底部菜单 */
@property (nonatomic, strong) VTReadBottomMenuView *bottomMenuView;


@end

@implementation VTReadMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupSubviews];
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
////        tap.delegate = self;
//        [self addGestureRecognizer:tap];
    }
    
    return self;
}

- (void)setupSubviews
{
    CGFloat originX = 0;
    CGFloat originY = 0;
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = [NSString isIphoneX] ? 88 : 64; // iPhoneX StatusBar高44px，NavigationBar高44px，底部TabBar高83px
    // 普通 StatusBar高20px，NavigationBar高44px，底部TabBar高49px
    
    _topMenuBgView = [[UIView alloc] initWithFrame:CGRectMake(originX, originY, width, height)];
    self.topMenuBgView.backgroundColor = [UIColor colorForReaderMenu];
//    self.topMenuBgView.hidden = YES;
    
    originY = [NSString isIphoneX] ? 44 : 20;
    height = CGRectGetHeight(self.topMenuBgView.frame) - originY;
    _topMenuView = [[VTReadTopMenuView alloc] initWithFrame:CGRectMake(originX, originY, width, height)];
    [self.topMenuBgView addSubview:self.topMenuView];
    
    height = [NSString isIphoneX] ? 220 + 34 : 220;
    originY = CGRectGetHeight(self.frame) - height;
    
    _bottomMenuBgView = [[UIView alloc] initWithFrame:CGRectMake(originX, originY, width, height)];
    self.bottomMenuBgView.backgroundColor = [UIColor colorForReaderMenu];
//    self.bottomMenuBgView.hidden = YES;
    
    originY = 0;
    height = [NSString isIphoneX] ? CGRectGetHeight(self.bottomMenuBgView.frame) - 34 : CGRectGetHeight(self.bottomMenuBgView.frame);
    _bottomMenuView = [[VTReadBottomMenuView alloc] initWithFrame:CGRectMake(originX, originY, width, height)];
    [self.bottomMenuBgView addSubview:self.bottomMenuView];
    
    [self addSubview:self.topMenuBgView];
    [self addSubview:self.bottomMenuBgView];
}

#pragma mark - SEL
- (void)handleTapGesture:(UITapGestureRecognizer *)recognizer
{
//    CGPoint point = [recognizer locationInView:self];
//    // 判断是否点击到中间区域
//    CGRect centerRect = CGRectMake(self.center.x - 20, 0, 40, CGRectGetHeight(self.frame));
//    if (CGRectContainsPoint(centerRect, point)) {
//        // 点击到中间区域, 展示上下菜单栏
//        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationShowOrHideMenu object:nil];
//    }
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationShowOrHideMenu object:nil];
}

//#pragma mark - UIGestureRecognizerDelegate
////- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    CGPoint point = [touch locationInView:self];
//    // 判断是否点击到中间区域
//    CGRect centerRect = CGRectMake(self.center.x - 20, 0, 40, CGRectGetHeight(self.frame));
//    if (CGRectContainsPoint(centerRect, point)) {
//        // 点击到中间区域, 展示上下菜单栏
//        //        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCloseReader object:nil];
//        //        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationShowOrHideMenu object:nil];
//        return YES;
//    }
//
//    return NO;
//}

@end
