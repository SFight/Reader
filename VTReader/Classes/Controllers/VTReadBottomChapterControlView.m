//
//  VTReadBottomChapterControlView.m
//  VTReader
//
//  Created by vtears on 2018/7/10.
//  Copyright © 2018年 JinJie Song. All rights reserved.
//

#import "VTReadBottomChapterControlView.h"

@interface VTReadBottomChapterControlView()

/** 上一章 */
@property (nonatomic, strong) UIButton *previousButton;
/** 下一章 */
@property (nonatomic, strong) UIButton *nextButton;
/** 滑动章节 */
@property (nonatomic, strong) UISlider *sliderBar;
/** 章节提示 */
@property (nonatomic, strong) UILabel *chapterLabel;

@end

@implementation VTReadBottomChapterControlView

#pragma mark - lazyInit
- (UIButton *)previousButton
{
    if (!_previousButton) {
        _previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _previousButton.frame = CGRectMake(0, 0, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame));
        _previousButton.titleLabel.font = [UIFont fontWithSize:FontSize_12];
        [_previousButton setTitle:@"上一章" forState:UIControlStateNormal];
        [_previousButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_previousButton addTarget:self action:@selector(onClickPreviousButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _previousButton;
}

- (UIButton *)nextButton
{
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextButton.frame = CGRectMake(CGRectGetWidth(self.frame) - CGRectGetHeight(self.frame), 0, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame));
        _nextButton.titleLabel.font = [UIFont fontWithSize:FontSize_12];
        [_nextButton setTitle:@"下一章" forState:UIControlStateNormal];
        [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(onClickNextButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _nextButton;
}

- (UISlider *)sliderBar
{
    if (!_sliderBar) {
        _sliderBar = [[UISlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.previousButton.frame), 0, CGRectGetWidth(self.frame) - CGRectGetWidth(self.previousButton.frame) - CGRectGetWidth(self.nextButton.frame), 15)];
        _sliderBar.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
    }
    
    return _sliderBar;
}

- (UILabel *)chapterLabel
{
    if (!_chapterLabel) {
        _chapterLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.sliderBar.frame), 8)];
        _chapterLabel.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetMaxY(self.sliderBar.frame) + 7);
        _chapterLabel.textColor = [UIColor whiteColor];
        _chapterLabel.font = [UIFont fontWithSize:FontSize_8];
        _chapterLabel.textAlignment = NSTextAlignmentCenter;
        _chapterLabel.text = @"1/21";
    }
    
    return _chapterLabel;
}


#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    
    return self;
}

#pragma mark - Override
- (void)layoutSubviews
{
    for (UIView *aView in [self subviews]) {
        [aView removeFromSuperview];
    }
    
    [self setupSubviews];
}

#pragma mark - 添加子视图
- (void)setupSubviews
{
    [self addSubview:self.previousButton];
    [self addSubview:self.nextButton];
    [self addSubview:self.sliderBar];
    [self addSubview:self.chapterLabel];
}

#pragma mark - SEL
- (void)onClickPreviousButton:(UIButton *)button
{
    VTLog(@"上一章");
}

- (void)onClickNextButton:(UIButton *)button
{
    VTLog(@"下一章");
}

@end
