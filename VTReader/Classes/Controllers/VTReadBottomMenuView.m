//
//  VTReadBottomMenuView.m
//  VTReader
//
//  Created by vtears on 2018/7/6.
//  Copyright © 2018年 JinJie Song. All rights reserved.
//

#import "VTReadBottomMenuView.h"

#import "VTReadBottomChapterControlView.h"

typedef NS_OPTIONS(NSInteger, MenuButtonTag) {
    Tag_Catalog_Button = 100, // 菜单按钮tag值
    Tag_Brightness_Button, // 屏幕亮度按钮tag值
    Tag_Font_Button, // 字体设置按钮tag值
    Tag_Setting_Button // 更多设置按钮
};

#define HEIGHT_MENU_BUTTON              50
#define WIDTH_MENU_BUTTON               CGRectGetWidth(self.frame)/4.0f
#define OriginX_MenuButton(x)                 WIDTH_MENU_BUTTON * x
#define OriginY_MenuButton                     0 // CGRectGetHeight(self.frame) - HEIGHT_MENU_BUTTON

@interface VTReadBottomMenuView()

/** 目录按钮 */
@property (nonatomic, strong) UIButton *catalogButton;
/** 屏幕亮度按钮 */
@property (nonatomic, strong) UIButton *brightnessButton;
/** 字体设置按钮 */
@property (nonatomic, strong) UIButton *fontButton;
/** 更多设置按钮 */
@property (nonatomic, strong) UIButton *settingButton;

@property (nonatomic, strong) UIView *bottomBar;

@property (nonatomic, strong) VTReadBottomChapterControlView *chapterControlView;
@property (nonatomic, strong) UIView *brightnessView;
@property (nonatomic, strong) UIView *fontView;
@property (nonatomic, strong) UIView *settingView;

@end

@implementation VTReadBottomMenuView

#pragma mark - lazyInit
- (UIView *)bottomBar
{
    if (!_bottomBar) {
        CGFloat height = [NSString isIphoneX] ? HEIGHT_MENU_BUTTON + 34 : HEIGHT_MENU_BUTTON;
        CGFloat originY = CGRectGetHeight(self.frame) - height;
        _bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, originY, CGRectGetWidth(self.frame), height)];
        _bottomBar.backgroundColor = [UIColor colorForReaderMenu];
    }
    
    return _bottomBar;
}

- (VTReadBottomChapterControlView *)chapterControlView
{
    if (!_chapterControlView) {
        _chapterControlView = [[VTReadBottomChapterControlView alloc] initWithFrame:CGRectMake(0, self.bottomBar.frame.origin.y - 45, CGRectGetWidth(self.frame), 45)];
        _chapterControlView.backgroundColor = [UIColor colorForReaderMenu];
    }
    
    return _chapterControlView;
}

- (UIView *)brightnessView
{
    if (!_brightnessView) {
        _brightnessView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bottomBar.frame.origin.y - 150, CGRectGetWidth(self.frame), 150)];
        _brightnessView.backgroundColor = [UIColor colorForReaderMenu];
        _brightnessView.hidden = YES;
    }
    
    return _brightnessView;
}

- (UIView *)fontView
{
    if (!_fontView) {
        _fontView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bottomBar.frame.origin.y - 150, CGRectGetWidth(self.frame), 150)];
        _fontView.backgroundColor = [UIColor colorForReaderMenu];
        _fontView.hidden = YES;
    }
    
    return _fontView;
}

- (UIView *)settingView
{
    if (!_settingView) {
        _settingView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bottomBar.frame.origin.y - 170, CGRectGetWidth(self.frame), 170)];
        _settingView.backgroundColor = [UIColor colorForReaderMenu];
        _settingView.hidden = YES;
    }
    
    return _settingView;
}

- (UIButton *)catalogButton
{
    if (!_catalogButton) {
        _catalogButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _catalogButton.frame = CGRectMake(OriginX_MenuButton(0), OriginY_MenuButton, WIDTH_MENU_BUTTON, HEIGHT_MENU_BUTTON);
        _catalogButton.tag = Tag_Catalog_Button;
        [_catalogButton setImage:[UIImage imageNamed:@"vt_catalog" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [_catalogButton addTarget:self action:@selector(onClickMenuButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _catalogButton;
}

- (UIButton *)brightnessButton
{
    if (!_brightnessButton) {
        _brightnessButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _brightnessButton.frame = CGRectMake(OriginX_MenuButton(1), OriginY_MenuButton, WIDTH_MENU_BUTTON, HEIGHT_MENU_BUTTON);
        _brightnessButton.tag = Tag_Brightness_Button;
        [_brightnessButton setImage:[UIImage imageNamed:@"vt_brightness" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [_brightnessButton addTarget:self action:@selector(onClickMenuButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _brightnessButton;
}

- (UIButton *)fontButton
{
    if (!_fontButton) {
        _fontButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _fontButton.frame = CGRectMake(OriginX_MenuButton(2), OriginY_MenuButton, WIDTH_MENU_BUTTON, HEIGHT_MENU_BUTTON);
        _fontButton.tag = Tag_Font_Button;
        [_fontButton setImage:[UIImage imageNamed:@"vt_font" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [_fontButton addTarget:self action:@selector(onClickMenuButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _fontButton;
}

- (UIButton *)settingButton
{
    if (!_settingButton) {
        _settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _settingButton.frame = CGRectMake(OriginX_MenuButton(3), OriginY_MenuButton, WIDTH_MENU_BUTTON, HEIGHT_MENU_BUTTON);
        _settingButton.tag = Tag_Setting_Button;
        [_settingButton setImage:[UIImage imageNamed:@"vt_setting" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [_settingButton addTarget:self action:@selector(onClickMenuButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _settingButton;
}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor redColor];
//        [self setupSubviews];
    }
    
    return self;
}

#pragma mark - Override
- (void)layoutSubviews
{
    VTLog(@"重新初始化底部菜单视图");
    for (UIView *aView in [self subviews]) {
        [aView removeFromSuperview];
    }
    
    [self setupSubviews];
}

#pragma mark - 设置界面
- (void)setupSubviews
{
    [self addSubview:self.bottomBar];
    [self addSubview:self.chapterControlView];
    [self addSubview:self.brightnessView];
    [self addSubview:self.fontView];
    [self addSubview:self.settingView];
    
    [self.bottomBar addSubview:self.catalogButton];
    [self.bottomBar addSubview:self.brightnessButton];
    [self.bottomBar addSubview:self.fontButton];
    [self.bottomBar addSubview:self.settingButton];
    
    // 分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, OriginY_MenuButton, CGRectGetWidth(self.bottomBar.frame), 0.5)];
    lineView.backgroundColor = [UIColor colorForLine];
    [self.bottomBar addSubview:lineView];
    
}

#pragma mark - SEL
- (void)onClickMenuButton:(UIButton *)button
{
    VTLog(@"点击菜单：%zi", button.tag);
    
    switch (button.tag) {
        case Tag_Catalog_Button:
        {
            // 目录点击， 重置回原来状态
            self.chapterControlView.hidden = NO;
            self.brightnessView.hidden = YES;
            self.fontView.hidden = YES;
            self.settingView.hidden = YES;
            break;
        }
            
        case Tag_Brightness_Button:
        {
            // 屏幕亮度按钮点击
            self.chapterControlView.hidden = YES;
            self.brightnessView.hidden = NO;
            self.fontView.hidden = YES;
            self.settingView.hidden = YES;
            break;
        }
            
        case Tag_Font_Button:
        {
            // 字体设置按钮
            self.chapterControlView.hidden = YES;
            self.brightnessView.hidden = YES;
            self.fontView.hidden = NO;
            self.settingView.hidden = YES;
            break;
        }
            
        case Tag_Setting_Button:
        {
            // 更多设置按钮
            self.chapterControlView.hidden = YES;
            self.brightnessView.hidden = YES;
            self.fontView.hidden = YES;
            self.settingView.hidden = NO;
            break;
        }
    }
}

@end
