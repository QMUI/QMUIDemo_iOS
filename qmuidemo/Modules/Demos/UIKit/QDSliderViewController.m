//
//  QDSliderViewController.m
//  qmuidemo
//
//  Created by MoLice on 2017/6/1.
//  Copyright © 2017年 QMUI Team. All rights reserved.
//

#import "QDSliderViewController.h"

@interface QDSliderViewController ()

@property(nonatomic, strong) QMUISlider *slider;
@property(nonatomic, strong) UISlider *systemSlider;
@property(nonatomic, strong) UILabel *label1;
@property(nonatomic, strong) UILabel *label2;
@end

@implementation QDSliderViewController

- (void)initSubviews {
    [super initSubviews];
    self.slider = [[QMUISlider alloc] init];
    self.slider.value = .3;
    self.slider.minimumTrackTintColor = [QDThemeManager sharedInstance].currentTheme.themeTintColor;
    self.slider.maximumTrackTintColor = UIColorGray9;
    self.slider.trackHeight = 1;// 支持修改背后导轨的高度
    self.slider.thumbColor = self.slider.minimumTrackTintColor;
    self.slider.thumbSize = CGSizeMake(14, 14);// 支持修改拖拽圆点的大小
    
    // 支持修改圆点的阴影样式
    self.slider.thumbShadowColor = [self.slider.minimumTrackTintColor colorWithAlphaComponent:.3];
    self.slider.thumbShadowOffset = CGSizeMake(0, 2);
    self.slider.thumbShadowRadius = 3;
    
    [self.view addSubview:self.slider];
    
    self.systemSlider = [[UISlider alloc] init];
    self.systemSlider.minimumTrackTintColor = self.slider.minimumTrackTintColor;
    self.systemSlider.maximumTrackTintColor = self.slider.maximumTrackTintColor;
    self.systemSlider.thumbTintColor = self.slider.minimumTrackTintColor;
    self.systemSlider.value = self.slider.value;
    [self.view addSubview:self.systemSlider];
    
    self.label1 = [[UILabel alloc] qmui_initWithFont:UIFontMake(14) textColor:TableViewSectionHeaderTextColor];
    self.label1.text = @"QMUISlider";
    [self.label1 sizeToFit];
    [self.view addSubview:self.label1];
    
    self.label2 = [[UILabel alloc] init];
    [self.label2 qmui_setTheSameAppearanceAsLabel:self.label1];
    self.label2.text = @"UISlider";
    [self.label2 sizeToFit];
    [self.view addSubview:self.label2];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(self.qmui_navigationBarMaxYInViewCoordinator + 32, 24, 24, 24);
    
    self.label1.frame = CGRectSetXY(self.label1.frame, padding.left, padding.top);
    
    [self.slider sizeToFit];
    self.slider.frame = CGRectMake(padding.left, CGRectGetMaxY(self.label1.frame) + 16, CGRectGetWidth(self.view.bounds) - UIEdgeInsetsGetHorizontalValue(padding), CGRectGetHeight(self.slider.frame));
    
    self.label2.frame = CGRectSetXY(self.label2.frame, padding.left, CGRectGetMaxY(self.slider.frame) + 64);
    
    [self.systemSlider sizeToFit];
    self.systemSlider.frame = CGRectSetY(self.slider.frame, CGRectGetMaxY(self.label2.frame) + 16);
}

@end
