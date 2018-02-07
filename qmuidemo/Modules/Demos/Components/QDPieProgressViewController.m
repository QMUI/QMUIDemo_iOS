//
//  QDPieProgressViewController.m
//  qmuidemo
//
//  Created by MoLice on 15/9/8.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QDPieProgressViewController.h"

@interface QDPieProgressViewController ()

@property(nonatomic, strong) UIView *section1;
@property(nonatomic, strong) QMUIPieProgressView *progressView1;
@property(nonatomic, strong) QMUISlider *slider;
@property(nonatomic, strong) UILabel *titleLabel1;

@property(nonatomic, strong) UIView *section2;
@property(nonatomic, strong) UILabel *titleLabel2;
@property(nonatomic, strong) QMUIPieProgressView *progressView2;
@property(nonatomic, strong) QMUIPieProgressView *progressView3;
@property(nonatomic, strong) QMUIPieProgressView *progressView4;

@end

@implementation QDPieProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorWhite;
}

- (void)initSubviews {
    [super initSubviews];
    
    self.section1 = [[UIView alloc] init];
    self.section1.qmui_borderColor = UIColorSeparator;
    self.section1.qmui_borderPosition = QMUIBorderViewPositionBottom;
    self.section1.qmui_borderWidth = PixelOne;
    [self.view addSubview:self.section1];
    
    self.progressView1 = [[QMUIPieProgressView alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
    self.progressView1.tintColor = [QDThemeManager sharedInstance].currentTheme.themeTintColor;
    [self.progressView1 addTarget:self action:@selector(handleProgressViewValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.section1 addSubview:self.progressView1];
    
    self.titleLabel1 = [[UILabel alloc] qmui_initWithFont:UIFontMake(13) textColor:self.progressView1.tintColor];
    [self.titleLabel1 qmui_calculateHeightAfterSetAppearance];
    self.titleLabel1.textAlignment = NSTextAlignmentCenter;
    [self.section1 addSubview:self.titleLabel1];
    
    self.slider = [[QMUISlider alloc] init];
    self.slider.tintColor = self.progressView1.tintColor;
    self.slider.thumbSize = CGSizeMake(16, 16);
    self.slider.thumbColor = self.slider.tintColor;
    self.slider.thumbShadowColor = [self.slider.tintColor colorWithAlphaComponent:.3];
    self.slider.thumbShadowOffset = CGSizeMake(0, 2);
    self.slider.thumbShadowRadius = 3;
    [self.slider sizeToFit];
    [self.slider addTarget:self action:@selector(handleSliderTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.section1 addSubview:self.slider];
    
    self.section2 = [[UIView alloc] init];
    self.section2.qmui_borderColor = UIColorSeparator;
    self.section2.qmui_borderPosition = QMUIBorderViewPositionBottom;
    self.section2.qmui_borderWidth = PixelOne;
    [self.view addSubview:self.section2];
    
    self.progressView2 = [[QMUIPieProgressView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
    self.progressView2.tintColor = UIColorTheme3;
    [self.progressView2 setProgress:.68];
    [self.section2 addSubview:self.progressView2];
    
    self.progressView3 = [[QMUIPieProgressView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    self.progressView3.tintColor = UIColorTheme5;
    [self.progressView3 setProgress:.1];
    [self.section2 addSubview:self.progressView3];
    
    self.progressView4 = [[QMUIPieProgressView alloc] initWithFrame:CGRectMake(0, 0, 38, 38)];
    self.progressView4.tintColor = UIColorTheme4;
    self.progressView4.backgroundColor = [self.progressView4.tintColor qmui_colorWithAlphaAddedToWhite:.2];
    [self.progressView4 setProgress:.28];
    [self.section2 addSubview:self.progressView4];

    self.titleLabel2 = [[UILabel alloc] qmui_initWithFont:UIFontMake(11) textColor:self.titleLabel1.textColor];
    self.titleLabel2.numberOfLines = 0;
    self.titleLabel2.text = @"通过 backgroundColor 或 tintColor 修改颜色";
    [self.titleLabel2 sizeToFit];
    [self.section2 addSubview:self.titleLabel2];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.progressView1 setProgress:.3 animated:YES];
    [self.slider setValue:self.progressView1.progress animated:YES];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat horizontalInset = 25;
    CGFloat sectionHeight = 145;
    CGFloat progressView1MarginRight = 30;
    
    self.section1.frame = CGRectMake(0, self.qmui_navigationBarMaxYInViewCoordinator, CGRectGetWidth(self.view.bounds), sectionHeight);
    self.progressView1.frame = CGRectSetXY(self.progressView1.frame, horizontalInset, CGRectGetMinYVerticallyCenterInParentRect(self.section1.frame, self.progressView1.frame) - 6);    // 因为下面有个label，因此这里向上偏一点以让视觉上更平衡
    self.titleLabel1.frame = CGRectMake(CGRectGetMinX(self.progressView1.frame), CGRectGetMaxY(self.progressView1.frame) + 9, CGRectGetWidth(self.progressView1.bounds), CGRectGetHeight(self.titleLabel1.bounds));
    self.slider.frame = CGRectMake(CGRectGetMaxX(self.progressView1.frame) + progressView1MarginRight, CGRectGetMidY(self.progressView1.frame) - CGRectGetMidY(self.slider.bounds), CGRectGetWidth(self.view.bounds) - CGRectGetMaxX(self.progressView1.frame) - progressView1MarginRight - horizontalInset, CGRectGetHeight(self.slider.bounds));
    
    self.section2.frame = CGRectMake(0, CGRectGetMaxY(self.section1.frame), CGRectGetWidth(self.view.bounds), sectionHeight);
    CGPoint referenceCenter = self.progressView1.center;
    self.progressView2.center = CGPointMake(referenceCenter.x - 20, referenceCenter.y - 15);
    self.progressView3.center = CGPointMake(referenceCenter.x + 20, referenceCenter.y - 15);
    self.progressView4.center = CGPointMake(referenceCenter.x + 10, referenceCenter.y + 22);
    [self.titleLabel2 sizeToFit];
    self.titleLabel2.frame = CGRectSetXY(self.titleLabel2.frame, CGRectGetMinX(self.slider.frame), CGRectGetMinYVerticallyCenterInParentRect(self.section2.frame, self.titleLabel2.frame));
}

- (void)handleProgressViewValueChanged:(QMUIPieProgressView *)progressView {
    self.titleLabel1.text = [NSString stringWithFormat:@"%.0f%%", progressView.progress * 100];
}

- (void)handleSliderTouchUpInside:(UISlider *)slider {
    [self.progressView1 setProgress:slider.value animated:YES];
}

@end
