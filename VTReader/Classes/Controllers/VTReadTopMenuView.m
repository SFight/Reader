//
//  VTReadTopMenuView.m
//  VTReader
//
//  Created by vtears on 2018/7/6.
//  Copyright © 2018年 JinJie Song. All rights reserved.
//

#import "VTReadTopMenuView.h"

extern NSString *const kNotificationCloseReader;

@interface VTReadTopMenuView()

@property (nonatomic, strong) UIView *navigationBar;

@end

@implementation VTReadTopMenuView

#pragma mark - lazyInit
- (UIView *)navigationBar
{
    if (!_navigationBar) {
        _navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, [NSString isIphoneX] ? 44 : 20, CGRectGetWidth(self.frame), [NSString isIphoneX] ? CGRectGetHeight(self.frame) - 44 : CGRectGetHeight(self.frame) - 20)];
    }
    
    return _navigationBar;
}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorForReaderMenu];
        [self setupSubviews];
    }
    
    return self;
}

#pragma mark - 设置视图
- (void)setupSubviews
{
    [self addSubview:self.navigationBar];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, CGRectGetHeight(self.navigationBar.frame), CGRectGetHeight(self.navigationBar.frame));
    [button setImage:[UIImage imageNamed:@"vt_back" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onClickBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:button];
}

#pragma mark - SEL
- (void)onClickBackButton:(UIButton *)button
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCloseReader object:nil];
}

@end
