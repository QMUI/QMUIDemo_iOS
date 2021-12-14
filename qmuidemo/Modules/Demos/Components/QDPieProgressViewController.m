//
//  QDPieProgressViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 15/9/8.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QDPieProgressViewController.h"

@interface QDPieProgressViewController ()

@property(nonatomic, strong) UIScrollView *scrollView;

@property(nonatomic, strong) UIView *section1;
@property(nonatomic, strong) QMUIPieProgressView *progressView1;
@property(nonatomic, strong) UISlider *slider;
@property(nonatomic, strong) UILabel *titleLabel1;

@property(nonatomic, strong) UIView *section2;
@property(nonatomic, strong) UILabel *titleLabel2;
@property(nonatomic, strong) QMUIPieProgressView *progressView2;

@property(nonatomic, strong) UIView *section3;
@property(nonatomic, strong) UILabel *titleLabel3;
@property(nonatomic, strong) QMUIPieProgressView *progressView31;
@property(nonatomic, strong) QMUIPieProgressView *progressView32;
@property(nonatomic, strong) QMUIPieProgressView *progressView33;

@end

@implementation QDPieProgressViewController

- (void)initSubviews {
    [super initSubviews];
    
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    
    self.section1 = [[UIView alloc] init];
    self.section1.qmui_borderColor = UIColorSeparator;
    self.section1.qmui_borderPosition = QMUIViewBorderPositionBottom;
    self.section1.qmui_borderWidth = PixelOne;
    [self.scrollView addSubview:self.section1];
    
    self.progressView1 = [[QMUIPieProgressView alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
    self.progressView1.tintColor = UIColor.qd_tintColor;
    self.progressView1.progressAnimationDuration = .2;
    [self.progressView1 addTarget:self action:@selector(handleProgressViewValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.section1 addSubview:self.progressView1];
    
    self.titleLabel1 = [[UILabel alloc] qmui_initWithFont:UIFontMake(13) textColor:self.progressView1.tintColor];
    [self.titleLabel1 qmui_calculateHeightAfterSetAppearance];
    self.titleLabel1.textAlignment = NSTextAlignmentCenter;
    [self.section1 addSubview:self.titleLabel1];
    
    self.slider = [[UISlider alloc] init];
    self.slider.tintColor = self.progressView1.tintColor;
    self.slider.qmui_thumbSize = CGSizeMake(16, 16);
    self.slider.qmui_thumbColor = self.slider.tintColor;
    self.slider.qmui_thumbShadowColor = [self.slider.tintColor colorWithAlphaComponent:.3];
    self.slider.qmui_thumbShadowOffset = CGSizeMake(0, 2);
    self.slider.qmui_thumbShadowRadius = 3;
    [self.slider sizeToFit];
    [self.slider addTarget:self action:@selector(handleSliderTouchUpInside:) forControlEvents:UIControlEventValueChanged];
    [self.section1 addSubview:self.slider];
    
    self.section2 = [[UIView alloc] init];
    self.section2.qmui_borderColor = UIColorSeparator;
    self.section2.qmui_borderPosition = QMUIViewBorderPositionBottom;
    self.section2.qmui_borderWidth = PixelOne;
    [self.scrollView addSubview:self.section2];
    
    self.progressView2 = [[QMUIPieProgressView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    self.progressView2.tintColor = UIColor.qd_tintColor;
    self.progressView2.borderWidth = 2;
    self.progressView2.borderInset = 3;
    [self.progressView2 setProgress:.3];
    [self.section2 addSubview:self.progressView2];
    
    self.titleLabel2 = [[UILabel alloc] qmui_initWithFont:UIFontMake(11) textColor:UIColor.qd_descriptionTextColor];
    self.titleLabel2.numberOfLines = 0;
    self.titleLabel2.text = @"通过 borderWidth、borderInset 修改样式";
    [self.titleLabel2 sizeToFit];
    [self.section2 addSubview:self.titleLabel2];
    
    self.section3 = [[UIView alloc] init];
    self.section3.qmui_borderColor = UIColorSeparator;
    self.section3.qmui_borderPosition = QMUIViewBorderPositionBottom;
    self.section3.qmui_borderWidth = PixelOne;
    [self.scrollView addSubview:self.section3];
    
    self.progressView31 = [[QMUIPieProgressView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
    self.progressView31.tintColor = UIColorTheme3;
    [self.progressView31 setProgress:.68];
    [self.section3 addSubview:self.progressView31];
    
    self.progressView32 = [[QMUIPieProgressView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    self.progressView32.tintColor = UIColorTheme5;
    [self.progressView32 setProgress:.1];
    [self.section3 addSubview:self.progressView32];
    
    self.progressView33 = [[QMUIPieProgressView alloc] initWithFrame:CGRectMake(0, 0, 38, 38)];
    self.progressView33.tintColor = UIColorTheme4;
    self.progressView33.backgroundColor = [self.progressView33.tintColor qmui_colorWithAlphaAddedToWhite:.2];
    [self.progressView33 setProgress:.28];
    [self.section3 addSubview:self.progressView33];
    
    self.titleLabel3 = [[UILabel alloc] qmui_initWithFont:UIFontMake(11) textColor:UIColor.qd_descriptionTextColor];
    self.titleLabel3.numberOfLines = 0;
    self.titleLabel3.text = @"通过 backgroundColor 或 tintColor 修改颜色";
    [self.titleLabel3 sizeToFit];
    [self.section3 addSubview:self.titleLabel3];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.progressView1 setProgress:.3 animated:YES];
    [self.slider setValue:self.progressView1.progress animated:YES];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.scrollView.frame = self.view.bounds;
    
    CGFloat horizontalInset = 25 + self.scrollView.safeAreaInsets.left;
    CGFloat sectionHeight = 145;
    CGFloat progressView1MarginRight = 30;
    
    self.section1.frame = CGRectMake(0, 0, CGRectGetWidth(self.scrollView.bounds), sectionHeight);
    self.progressView1.frame = CGRectSetXY(self.progressView1.frame, horizontalInset, CGRectGetMinYVerticallyCenterInParentRect(self.section1.bounds, self.progressView1.frame) - 6);    // 因为下面有个label，因此这里向上偏一点以让视觉上更平衡
    self.titleLabel1.frame = CGRectMake(CGRectGetMinX(self.progressView1.frame), CGRectGetMaxY(self.progressView1.frame) + 9, CGRectGetWidth(self.progressView1.bounds), CGRectGetHeight(self.titleLabel1.bounds));
    self.slider.frame = CGRectMake(CGRectGetMaxX(self.progressView1.frame) + progressView1MarginRight, CGRectGetMidY(self.progressView1.frame) - CGRectGetMidY(self.slider.bounds), CGRectGetWidth(self.scrollView.bounds) - CGRectGetMaxX(self.progressView1.frame) - progressView1MarginRight - horizontalInset, CGRectGetHeight(self.slider.bounds));
    
    self.section2.frame = CGRectMake(0, CGRectGetMaxY(self.section1.frame), CGRectGetWidth(self.scrollView.bounds), sectionHeight);
    self.progressView2.frame = CGRectSetXY(self.progressView2.frame, horizontalInset + 5, CGRectGetMinYVerticallyCenterInParentRect(self.section2.bounds, self.progressView2.frame));
    [self.titleLabel2 sizeToFit];
    self.titleLabel2.frame = CGRectSetXY(self.titleLabel2.frame, CGRectGetMinX(self.slider.frame), CGRectGetMinYVerticallyCenterInParentRect(self.section2.bounds, self.titleLabel2.frame));
    
    self.section3.frame = CGRectMake(0, CGRectGetMaxY(self.section2.frame), CGRectGetWidth(self.scrollView.bounds), sectionHeight);
    CGPoint referenceCenter = self.progressView1.center;
    self.progressView31.center = CGPointMake(referenceCenter.x - 20, referenceCenter.y - 15);
    self.progressView32.center = CGPointMake(referenceCenter.x + 20, referenceCenter.y - 15);
    self.progressView33.center = CGPointMake(referenceCenter.x + 10, referenceCenter.y + 22);
    [self.titleLabel3 sizeToFit];
    self.titleLabel3.frame = CGRectSetXY(self.titleLabel3.frame, CGRectGetMinX(self.slider.frame), CGRectGetMinYVerticallyCenterInParentRect(self.section3.bounds, self.titleLabel3.frame));
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.bounds), CGRectGetMaxY(self.section3.frame));
}

- (void)handleProgressViewValueChanged:(QMUIPieProgressView *)progressView {
    self.titleLabel1.text = [NSString stringWithFormat:@"%.0f%%", progressView.progress * 100];
}

- (void)handleSliderTouchUpInside:(UISlider *)slider {
    [self.progressView1 setProgress:slider.value animated:YES];
}

@end
