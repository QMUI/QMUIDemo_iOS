//
//  QDFontPointSizeAndLineHeightViewController.m
//  qmuidemo
//
//  Created by MoLice on 2016/10/30.
//  Copyright © 2016年 QMUI Team. All rights reserved.
//

#import "QDFontPointSizeAndLineHeightViewController.h"

@interface QDFontPointSizeAndLineHeightViewController ()

@property(nonatomic, strong) UILabel *fontPointSizeLabel;
@property(nonatomic, strong) UILabel *lineHeightLabel;
@property(nonatomic, strong) QMUISlider *fontPointSizeSlider;
@property(nonatomic, strong) UILabel *exampleLabel;

@property(nonatomic, assign) NSInteger oldFontPointSize;
@end

@implementation QDFontPointSizeAndLineHeightViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.oldFontPointSize = 16;
    }
    return self;
}

- (void)initSubviews {
    [super initSubviews];
    self.fontPointSizeLabel = [[UILabel alloc] qmui_initWithFont:UIFontMake(18) textColor:UIColorGray1];
    [self.fontPointSizeLabel qmui_calculateHeightAfterSetAppearance];
    [self.view addSubview:self.fontPointSizeLabel];
    
    self.lineHeightLabel = [[UILabel alloc] init];
    [self.lineHeightLabel qmui_setTheSameAppearanceAsLabel:self.fontPointSizeLabel];
    [self.lineHeightLabel qmui_calculateHeightAfterSetAppearance];
    [self.view addSubview:self.lineHeightLabel];
    
    self.fontPointSizeSlider = [[QMUISlider alloc] init];
    self.fontPointSizeSlider.tintColor = [QDThemeManager sharedInstance].currentTheme.themeTintColor;
    self.fontPointSizeSlider.thumbSize = CGSizeMake(16, 16);
    self.fontPointSizeSlider.thumbColor = self.fontPointSizeSlider.tintColor;
    self.fontPointSizeSlider.thumbShadowColor = [self.fontPointSizeSlider.tintColor colorWithAlphaComponent:.3];
    self.fontPointSizeSlider.thumbShadowOffset = CGSizeMake(0, 2);
    self.fontPointSizeSlider.thumbShadowRadius = 3;
    self.fontPointSizeSlider.minimumValue = 8;
    self.fontPointSizeSlider.maximumValue = 50;
    self.fontPointSizeSlider.value = self.oldFontPointSize;
    [self.fontPointSizeSlider sizeToFit];
    [self.fontPointSizeSlider addTarget:self action:@selector(handleSliderEvent:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.fontPointSizeSlider];
    
    self.exampleLabel = [[UILabel alloc] init];
    self.exampleLabel.backgroundColor = [QDThemeManager sharedInstance].currentTheme.themeTintColor;
    self.exampleLabel.textColor = UIColorWhite;
    self.exampleLabel.text = @"字体大小与其对应的默认行高";
    [self.view addSubview:self.exampleLabel];
    
    [self updateLabelsBaseOnSliderForce:YES];
}

- (void)handleSliderEvent:(UISlider *)slider {
    [self updateLabelsBaseOnSliderForce:NO];
}

- (void)updateLabelsBaseOnSliderForce:(BOOL)force {
    NSInteger fontPointSize = (NSInteger)self.fontPointSizeSlider.value;
    
    if (force || fontPointSize != self.oldFontPointSize) {
        
        self.exampleLabel.font = UIFontMake(fontPointSize);
        [self.exampleLabel sizeToFit];
        NSInteger lineHeight = (NSInteger)CGRectGetHeight(self.exampleLabel.frame);
        
        self.fontPointSizeLabel.text = [NSString stringWithFormat:@"字号：%@", @(fontPointSize)];
        self.lineHeightLabel.text = [NSString stringWithFormat:@"行高：%@", @(lineHeight)];
        
        self.oldFontPointSize = fontPointSize;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIEdgeInsets padding = UIEdgeInsetsMake(self.qmui_navigationBarMaxYInViewCoordinator + 24, 24, 24, 24);
    CGFloat contentWidth = CGRectGetWidth(self.view.bounds) - UIEdgeInsetsGetHorizontalValue(padding);
    self.fontPointSizeLabel.frame = CGRectFlatMake(padding.left, padding.top, contentWidth, CGRectGetHeight(self.fontPointSizeLabel.frame));
    self.lineHeightLabel.frame = CGRectFlatMake(padding.left, CGRectGetMaxY(self.fontPointSizeLabel.frame) + 16, contentWidth, CGRectGetHeight(self.lineHeightLabel.frame));
    self.fontPointSizeSlider.frame = CGRectFlatMake(padding.left, CGRectGetMaxY(self.lineHeightLabel.frame) + 16, contentWidth, CGRectGetHeight(self.fontPointSizeSlider.frame));
    
    CGSize exampleLabelSize = [self.exampleLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    self.exampleLabel.frame = CGRectFlatMake(padding.left, CGRectGetMaxY(self.fontPointSizeSlider.frame) + 40, contentWidth, exampleLabelSize.height);
}

@end
