//
//  QDFillButtonViewController.m
//  qmuidemo
//
//  Created by ZhoonChen on 15/5/23.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QDFillButtonViewController.h"

@interface QDFillButtonViewController ()

@property(nonatomic, strong) QMUIFillButton *fillButton1;
@property(nonatomic, strong) QMUIFillButton *fillButton2;
@property(nonatomic, strong) QMUIFillButton *fillButton3;

@property(nonatomic, strong) CALayer *separatorLayer1;
@property(nonatomic, strong) CALayer *separatorLayer2;
@property(nonatomic, strong) CALayer *separatorLayer3;

@end

@implementation QDFillButtonViewController

- (void)initSubviews {
    [super initSubviews];
    
    _fillButton1 = [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorBlue];
    self.fillButton1.titleLabel.font = UIFontMake(14);
    [self.fillButton1 setTitle:@"QMUIFillButtonColorBlue" forState:UIControlStateNormal];
    [self.view addSubview:self.fillButton1];
    
    _fillButton2 = [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorRed];
    self.fillButton2.titleLabel.font = UIFontMake(14);
    // 默认点击态是半透明处理，如果需要点击态是其他颜色，修改下面两个属性
    // self.fillButton2.adjustsButtonWhenHighlighted = NO;
    // self.fillButton2.highlightedBackgroundColor = UIColorMake(70, 160, 242);
    [self.fillButton2 setTitle:@"QMUIFillButtonColorRed" forState:UIControlStateNormal];
    [self.view addSubview:self.fillButton2];
    
    _fillButton3 = [[QMUIFillButton alloc] initWithFillType:QMUIFillButtonColorGreen];
    self.fillButton3.titleLabel.font = UIFontMake(14);
    [self.fillButton3 setTitle:@"点击修改按钮fillColor" forState:UIControlStateNormal];
    [self.fillButton3 setImage:UIImageMake(@"icon_emotion") forState:UIControlStateNormal];
    self.fillButton3.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 6);
    self.fillButton3.adjustsImageWithTitleTextColor = YES;
    [self.fillButton3 addTarget:self action:@selector(handleFillButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.fillButton3];
    
    self.separatorLayer1 = [QDCommonUI generateSeparatorLayer];
    [self.view.layer addSublayer:self.separatorLayer1];
    
    self.separatorLayer2 = [QDCommonUI generateSeparatorLayer];
    [self.view.layer addSublayer:self.separatorLayer2];
    
    self.separatorLayer3 = [QDCommonUI generateSeparatorLayer];
    [self.view.layer addSublayer:self.separatorLayer3];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat contentMinY = self.qmui_navigationBarMaxYInViewCoordinator;
    CGFloat buttonSpacingHeight = QDButtonSpacingHeight;
    CGSize buttonSize = CGSizeMake(260, 40);
    CGFloat buttonMinX = CGFloatGetCenter(CGRectGetWidth(self.view.bounds), buttonSize.width);
    CGFloat buttonOffsetY = CGFloatGetCenter(buttonSpacingHeight, buttonSize.height);
    
    self.fillButton1.frame = CGRectFlatMake(buttonMinX, contentMinY + buttonOffsetY, buttonSize.width, buttonSize.height);
    self.fillButton2.frame = CGRectFlatMake(buttonMinX, contentMinY + buttonSpacingHeight + buttonOffsetY, buttonSize.width, buttonSize.height);
    self.fillButton3.frame = CGRectFlatMake(buttonMinX, contentMinY + buttonSpacingHeight * 2 + buttonOffsetY, buttonSize.width, buttonSize.height);
    
    self.separatorLayer1.frame = CGRectMake(0, contentMinY + buttonSpacingHeight - PixelOne, CGRectGetWidth(self.view.bounds), PixelOne);
    self.separatorLayer2.frame = CGRectSetY(self.separatorLayer1.frame, contentMinY + buttonSpacingHeight * 2 - PixelOne);
    self.separatorLayer3.frame = CGRectSetY(self.separatorLayer1.frame, contentMinY + buttonSpacingHeight * 3 - PixelOne);
}

- (void)handleFillButtonEvent:(id)sender {
    UIColor *color = [QDCommonUI randomThemeColor];
    self.fillButton3.fillColor = color;
    self.fillButton3.titleTextColor = UIColorWhite;
}

@end
