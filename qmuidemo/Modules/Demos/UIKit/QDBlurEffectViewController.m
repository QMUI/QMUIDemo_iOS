//
//  QDBlurEffectViewController.m
//  qmuidemo
//
//  Created by molice on 2021/11/26.
//  Copyright © 2021 QMUI Team. All rights reserved.
//

#import "QDBlurEffectViewController.h"

@interface QDBlurEffectViewController ()

@property(nonatomic, strong) UIImageView *contentImageView;
@property(nonatomic, strong) UIVisualEffectView *effectView;
@property(nonatomic, strong) UILabel *contentLabel;

@property(nonatomic, strong) UILabel *label1;
@property(nonatomic, strong) UISlider *slider1;

@property(nonatomic, strong) UILabel *label2;
@property(nonatomic, strong) QMUIButton *button2;

@property(nonatomic, strong) UILabel *label3;
@property(nonatomic, strong) QMUIButton *button3;
@property(nonatomic, strong) UIViewPropertyAnimator *animator;
@end

@implementation QDBlurEffectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentImageView = [[UIImageView alloc] initWithImage:UIImageMake(@"image4")];
    self.contentImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.contentImageView.clipsToBounds = YES;
    [self.view addSubview:self.contentImageView];
    
    self.effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect qmui_effectWithBlurRadius:2]];
    [self.view addSubview:self.effectView];
    
    self.contentLabel = [[UILabel alloc] qmui_initWithFont:UIFontBoldMake(32) textColor:UIColorWhite];
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    self.contentLabel.text = @"UIBlurEffect+QMUI";
    self.contentLabel.layer.shadowColor = UIColorBlack.CGColor;
    self.contentLabel.layer.shadowOpacity = 1;
    self.contentLabel.layer.shadowRadius = 6;
    self.contentLabel.layer.shadowOffset = CGSizeMake(1, 1);
    [self.contentLabel sizeToFit];
    [self.effectView.contentView addSubview:self.contentLabel];
    
    self.label1 = [self generateLabel];
    [self.view addSubview:self.label1];
    
    self.slider1 = [self generateSlider];
    self.slider1.minimumValue = 0;
    self.slider1.maximumValue = 40;
    [self.slider1 addTarget:self action:@selector(handleBlurRadiusChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.slider1];
    self.slider1.value = 5;
    [self.slider1 sendActionsForControlEvents:UIControlEventValueChanged];
    
    self.label2 = [self generateLabel];
    self.label2.text = @"2. 支持精确指定磨砂颜色(系统每一种 UIBlurEffectStyle 都会带有默认的前景色，并且无法修改，这会导致我们无法精准设置自己的前景色)";
    [self.view addSubview:self.label2];
    
    self.button2 = [QDUIHelper generateLightBorderedButton];
    [self.button2 setTitle:@"点击更换前景色" forState:UIControlStateNormal];
    [self.button2 addTarget:self action:@selector(handleForegroundColorEvent:) forControlEvents:UIControlEventTouchUpInside];
    self.button2.qmui_preventsRepeatedTouchUpInsideEvent = NO;// 为了方便展示效果
    [self.view addSubview:self.button2];
    
    self.label3 = [self generateLabel];
    self.label3.text = @"3. 磨砂支持动画（系统能力，这里仅作展示用），也支持配合 UIGestureRecognizer 控制动画进度。";
    [self.view addSubview:self.label3];
    
    self.button3 = [QDUIHelper generateLightBorderedButton];
    [self.button3 setTitle:@"开始动画" forState:UIControlStateNormal];
    [self.button3 setTitle:@"动画中..." forState:UIControlStateDisabled];
    [self.button3 addTarget:self action:@selector(handleAnimationEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button3];
}

- (void)dealloc {
    [self.animator stopAnimation:YES];
}

- (void)handleBlurRadiusChanged:(UISlider *)slider {
    CGFloat radius = slider.value;
    self.effectView.effect = [UIBlurEffect qmui_effectWithBlurRadius:radius];
    self.label1.text = [NSString stringWithFormat:@"1. 支持精确指定模糊半径(当前%.2f)", radius];
    [self.view setNeedsLayout];
}

- (void)handleForegroundColorEvent:(QMUIButton *)button {
    UIColor *color = [QDCommonUI.randomThemeColor colorWithAlphaComponent:.3];
    self.effectView.qmui_foregroundColor = color;
}

- (void)handleAnimationEvent:(QMUIButton *)button {
    [self.animator stopAnimation:YES];
    self.effectView.effect = nil;
    self.animator = [[UIViewPropertyAnimator alloc] initWithDuration:3 curve:UIViewAnimationCurveEaseInOut animations:^{
        self.effectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    }];
    __weak __typeof(self)weakSelf = self;
    [self.animator addCompletion:^(UIViewAnimatingPosition finalPosition) {
        weakSelf.button3.enabled = YES;
    }];
    [self.animator startAnimation];
    self.button3.enabled = NO;
}

- (UILabel *)generateLabel {
    UILabel *label = [[UILabel alloc] qmui_initWithFont:UIFontMake(14) textColor:UIColor.qd_mainTextColor];
    label.qmui_lineHeight = 20;
    label.numberOfLines = 0;
    return label;
}

- (UISlider *)generateSlider {
    UISlider *slider = [[UISlider alloc] init];
    slider.minimumTrackTintColor = UIColor.qd_tintColor;
    slider.maximumTrackTintColor = UIColor.qd_separatorColor;
    slider.qmui_trackHeight = 1;// 支持修改背后导轨的高度
    slider.qmui_thumbColor = slider.minimumTrackTintColor;
    slider.qmui_thumbSize = CGSizeMake(14, 14);
    return slider;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIEdgeInsets padding = UIEdgeInsetsMake(self.qmui_navigationBarMaxYInViewCoordinator + 24, 24, 24, 24);
    CGFloat minY = padding.top;
    CGFloat contentWidth = CGRectGetWidth(self.view.bounds) - UIEdgeInsetsGetHorizontalValue(padding);
    
    self.contentImageView.frame = CGRectMake(padding.left, minY, contentWidth, 120);
    self.effectView.frame = self.contentImageView.frame;
    self.contentLabel.center = CGPointMake(CGRectGetWidth(self.effectView.bounds) / 2, CGRectGetHeight(self.effectView.bounds) / 2);
    minY = CGRectGetMaxY(self.effectView.frame) + 38;
    
    self.label1.frame = CGRectMake(padding.left, minY, contentWidth, QMUIViewSelfSizingHeight);
    self.slider1.frame = CGRectMake(padding.left, CGRectGetMaxY(self.label1.frame) + 16, contentWidth, QMUIViewSelfSizingHeight);
    minY = CGRectGetMaxY(self.slider1.frame) + 38;
    
    self.label2.frame = CGRectMake(padding.left, minY, contentWidth, QMUIViewSelfSizingHeight);
    self.button2.frame = CGRectMake(padding.left, CGRectGetMaxY(self.label2.frame) + 16, contentWidth, CGRectGetHeight(self.button2.frame));
    minY = CGRectGetMaxY(self.button2.frame) + 38;
    
    self.label3.frame = CGRectMake(padding.left, minY, contentWidth, QMUIViewSelfSizingHeight);
    self.button3.frame = CGRectMake(padding.left, CGRectGetMaxY(self.label3.frame) + 16, contentWidth, CGRectGetHeight(self.button3.frame));
    minY = CGRectGetMaxY(self.button3.frame) + 38;
}

@end
