//
//  VTReadTopMenuView.m
//  VTReader
//
//  Created by vtears on 2018/7/6.
//  Copyright © 2018年 JinJie Song. All rights reserved.
//

#import "VTReadTopMenuView.h"

extern NSString *const kNotificationCloseReader;

@implementation VTReadTopMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    
    return self;
}

#pragma mark - 设置视图
- (void)setupSubviews
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame));
    [button setImage:[UIImage imageNamed:@"vt_back" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onClickBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

#pragma mark - SEL
- (void)onClickBackButton:(UIButton *)button
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCloseReader object:nil];
}

@end
