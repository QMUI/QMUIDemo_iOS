//
//  QDFontPointSizeAndLineHeightViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 2016/10/30.
//  Copyright © 2016年 QMUI Team. All rights reserved.
//

#import "QDFontPointSizeAndLineHeightViewController.h"

@interface QDFontPointSizeAndLineHeightViewController ()

@property(nonatomic, strong) UILabel *fontPointSizeLabel;
@property(nonatomic, strong) UILabel *lineHeightLabel;
@property(nonatomic, strong) UISlider *fontPointSizeSlider;

@property(nonatomic, strong) UILabel *exampleLabel;
@property(nonatomic, strong) UILabel *exampleLabel2;

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
    self.fontPointSizeLabel = [[UILabel alloc] qmui_initWithFont:UIFontMake(12) textColor:UIColor.qd_mainTextColor];
    [self.fontPointSizeLabel qmui_calculateHeightAfterSetAppearance];
    [self.view addSubview:self.fontPointSizeLabel];
    
    self.lineHeightLabel = [[UILabel alloc] init];
    [self.lineHeightLabel qmui_setTheSameAppearanceAsLabel:self.fontPointSizeLabel];
    [self.lineHeightLabel qmui_calculateHeightAfterSetAppearance];
    [self.view addSubview:self.lineHeightLabel];
    
    self.fontPointSizeSlider = [[UISlider alloc] init];
    self.fontPointSizeSlider.tintColor = UIColor.qd_tintColor;
    self.fontPointSizeSlider.qmui_thumbSize = CGSizeMake(16, 16);
    self.fontPointSizeSlider.qmui_thumbColor = self.fontPointSizeSlider.tintColor;
    self.fontPointSizeSlider.qmui_thumbShadowColor = [self.fontPointSizeSlider.tintColor colorWithAlphaComponent:.3];
    self.fontPointSizeSlider.qmui_thumbShadowOffset = CGSizeMake(0, 2);
    self.fontPointSizeSlider.qmui_thumbShadowRadius = 3;
    self.fontPointSizeSlider.minimumValue = 8;
    self.fontPointSizeSlider.maximumValue = 50;
    self.fontPointSizeSlider.value = self.oldFontPointSize;
    [self.fontPointSizeSlider sizeToFit];
    [self.fontPointSizeSlider addTarget:self action:@selector(handleSliderEvent:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.fontPointSizeSlider];
    
    self.exampleLabel = [[UILabel alloc] init];
    self.exampleLabel.backgroundColor = UIColor.qd_tintColor;
    self.exampleLabel.textColor = UIColorWhite;
    self.exampleLabel.text = @"Expel";// 中英文不影响，这里为了便于观察，挑选了几个横跨多条线的字母
    self.exampleLabel.qmui_showPrincipalLines = YES;
    [self.view addSubview:self.exampleLabel];
    
    self.exampleLabel2 = [[UILabel alloc] init];
    self.exampleLabel2.backgroundColor = UIColor.qd_tintColor;
    self.exampleLabel2.qmui_showPrincipalLines = YES;
    [self.view addSubview:self.exampleLabel2];
    
    [self updateLabelsBaseOnSliderForce:YES];
}

- (void)handleSliderEvent:(UISlider *)slider {
    [self updateLabelsBaseOnSliderForce:NO];
}

- (void)updateLabelsBaseOnSliderForce:(BOOL)force {
    NSInteger fontPointSize = (NSInteger)self.fontPointSizeSlider.value;
    
    if (force || fontPointSize != self.oldFontPointSize) {
        
        UIFont *font = UIFontMake(fontPointSize);
        self.exampleLabel.font = font;
        [self.exampleLabel sizeToFit];
        CGFloat lineHeight = round(font.pointSize * 1.4);
        CGFloat baseline = (lineHeight - font.lineHeight) / 4;// 实际测量得知，baseline + 1，文字会往上移动 2pt，所以这里为了垂直居中，需要 / 4。
        
        self.exampleLabel2.attributedText = [[NSAttributedString alloc] initWithString:self.exampleLabel.text attributes:@{
            NSFontAttributeName: font,
            NSBackgroundColorAttributeName: [UIColor.qd_tintColor colorWithAlphaComponent:.3],
            NSForegroundColorAttributeName: UIColorWhite,
            NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:lineHeight],
            NSBaselineOffsetAttributeName: @(baseline),
        }];
        [self.exampleLabel2 sizeToFit];
        
        self.fontPointSizeLabel.text = [NSString stringWithFormat:@"font:%@, descender:%.1f, xHeight:%.1f, capHeight:%.1f", @(fontPointSize), font.descender, font.xHeight, font.capHeight];
        self.lineHeightLabel.text = [NSString stringWithFormat:@"font.lineHeight:%.1f, actually lineHeight:%.1f, baseline:%.1f", font.lineHeight, lineHeight, baseline];
        
        self.oldFontPointSize = fontPointSize;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIEdgeInsets padding = UIEdgeInsetsMake(24 + self.qmui_navigationBarMaxYInViewCoordinator, 24 + self.view.safeAreaInsets.left, 24 + self.view.safeAreaInsets.bottom, 24 + self.view.safeAreaInsets.right);
    CGFloat contentWidth = CGRectGetWidth(self.view.bounds) - UIEdgeInsetsGetHorizontalValue(padding);
    self.fontPointSizeLabel.frame = CGRectFlatMake(padding.left, padding.top, contentWidth, CGRectGetHeight(self.fontPointSizeLabel.frame));
    self.lineHeightLabel.frame = CGRectFlatMake(padding.left, CGRectGetMaxY(self.fontPointSizeLabel.frame) + 16, contentWidth, CGRectGetHeight(self.lineHeightLabel.frame));
    self.fontPointSizeSlider.frame = CGRectFlatMake(padding.left, CGRectGetMaxY(self.lineHeightLabel.frame) + 16, contentWidth, CGRectGetHeight(self.fontPointSizeSlider.frame));
    
    self.exampleLabel.frame = CGRectSetXY(self.exampleLabel.frame, padding.left, CGRectGetMaxY(self.fontPointSizeSlider.frame) + 40);
    self.exampleLabel2.frame = CGRectSetXY(self.exampleLabel2.frame, CGRectGetMaxX(self.exampleLabel.frame) + 8, CGRectGetMaxY(self.exampleLabel.frame) - CGRectGetHeight(self.exampleLabel2.frame));
}

@end
