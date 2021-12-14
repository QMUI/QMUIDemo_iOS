//
//  QDSliderViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 2017/6/1.
//  Copyright © 2017年 QMUI Team. All rights reserved.
//

#import "QDSliderViewController.h"
#import "QMUIInteractiveDebugger.h"

@interface QDSliderViewController ()

@property(nonatomic, strong) UISlider *slider;
@property(nonatomic, strong) QMUIInteractiveDebugPanelViewController *debugViewController;
@end

@implementation QDSliderViewController

- (void)initSubviews {
    [super initSubviews];
    self.slider = [[UISlider alloc] init];
    self.slider.value = .3;
    self.slider.minimumTrackTintColor = UIColor.qd_tintColor;
    self.slider.maximumTrackTintColor = UIColor.qd_separatorColor;
    self.slider.qmui_trackHeight = 1;
    self.slider.qmui_thumbSize = CGSizeMake(14, 14);
    self.slider.qmui_thumbColor = self.slider.minimumTrackTintColor;
    self.slider.qmui_thumbShadowColor = self.slider.minimumTrackTintColor;
    self.slider.qmui_thumbShadowRadius = 5;
    [self.view addSubview:self.slider];
    
    [self generateDebugViewController];
}

- (void)generateDebugViewController {
    __weak __typeof(self)weakSelf = self;
    self.debugViewController = [QDUIHelper generateDebugViewControllerWithTitle:@"输入新的值" items:@[
        [QMUIInteractiveDebugPanelItem boolItemWithTitle:@"steps" valueGetter:^(UISwitch * _Nonnull actionView) {
            actionView.on = weakSelf.slider.qmui_numberOfSteps >= 2;
        } valueSetter:^(UISwitch * _Nonnull actionView) {
            if (actionView.on) {
                weakSelf.slider.qmui_numberOfSteps = 5;
                weakSelf.slider.qmui_step = 3;
                weakSelf.slider.qmui_stepControlConfiguration = ^(UISlider *slider, QMUISliderStepControl * _Nonnull stepControl, NSUInteger index) {
                    stepControl.titleLabel.text = [NSString stringWithFormat:@"第%@档", @(index)];
                };
            } else {
                weakSelf.slider.qmui_numberOfSteps = 0;
            }
        }],
        [QMUIInteractiveDebugPanelItem numbericItemWithTitle:@"trackHeight" valueGetter:^(QMUITextField * _Nonnull actionView) {
            actionView.text = [NSString stringWithFormat:@"%.2f", weakSelf.slider.qmui_trackHeight];
        } valueSetter:^(QMUITextField * _Nonnull actionView) {
            weakSelf.slider.qmui_trackHeight = actionView.text.doubleValue;
        }],
        [QMUIInteractiveDebugPanelItem numbericItemWithTitle:@"thumbSize" valueGetter:^(QMUITextField * _Nonnull actionView) {
            actionView.text = [NSString stringWithFormat:@"%.2f", weakSelf.slider.qmui_thumbSize.height];
        } valueSetter:^(QMUITextField * _Nonnull actionView) {
            weakSelf.slider.qmui_thumbSize = CGSizeMake(actionView.text.doubleValue, actionView.text.doubleValue);
        }],
        [QMUIInteractiveDebugPanelItem colorItemWithTitle:@"thumbShadowColor" valueGetter:^(QMUITextField * _Nonnull actionView) {
            actionView.text = weakSelf.slider.qmui_thumbShadowColor.qmui_RGBAString;
        } valueSetter:^(QMUITextField * _Nonnull actionView) {
            weakSelf.slider.qmui_thumbShadowColor = [UIColor qmui_colorWithRGBAString:actionView.text];
        }],
        [QMUIInteractiveDebugPanelItem numbericItemWithTitle:@"outsideEdge" valueGetter:^(QMUITextField * _Nonnull actionView) {
            actionView.text = [NSString stringWithFormat:@"%.2f", weakSelf.slider.qmui_outsideEdge.left];
        } valueSetter:^(QMUITextField * _Nonnull actionView) {
            CGFloat outside = actionView.text.doubleValue;
            weakSelf.slider.qmui_outsideEdge = UIEdgeInsetsMake(outside, outside, outside, outside);
        }],
    ]];
    [self.view addSubview:self.debugViewController.view];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(24 + self.qmui_navigationBarMaxYInViewCoordinator, 24 + self.view.safeAreaInsets.left, 24 + self.view.safeAreaInsets.bottom, 24 + self.view.safeAreaInsets.right);
    CGFloat contentWidth = MIN(CGRectGetWidth(self.view.bounds) - UIEdgeInsetsGetHorizontalValue(padding), 426);
    CGFloat minX = CGFloatGetCenter(CGRectGetWidth(self.view.bounds), contentWidth);
    [self.slider sizeToFit];
    self.slider.frame = CGRectMake(minX, padding.top + 16, contentWidth, CGRectGetHeight(self.slider.frame));
    
    CGSize size = [self.debugViewController contentSizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
    self.debugViewController.view.frame = CGRectMake(minX, CGRectGetMaxY(self.slider.frame) + 36, contentWidth, size.height);
}

@end
