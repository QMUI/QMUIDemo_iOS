//
//  QDNormalButtonViewController.m
//  qmuidemo
//
//  Created by MoLice on 16/10/12.
//  Copyright (c) 2016年 QMUI Team. All rights reserved.
//

#import "QDNormalButtonViewController.h"

@interface QDNormalButtonViewController ()

@property(nonatomic, strong) QMUIButton *normalButton;
@property(nonatomic, strong) QMUIButton *borderedButton;
@property(nonatomic, strong) QMUIButton *imagePositionButton1;
@property(nonatomic, strong) QMUIButton *imagePositionButton2;
@property(nonatomic, strong) CALayer *separatorLayer;
@property(nonatomic, strong) CAShapeLayer *imageButtonSeparatorLayer;

@end

@implementation QDNormalButtonViewController

- (void)initSubviews {
    [super initSubviews];
    
    // 普通按钮
    self.normalButton = [QDUIHelper generateDarkFilledButton];
    [self.normalButton setTitle:@"按钮，支持高亮背景色" forState:UIControlStateNormal];
    [self.view addSubview:self.normalButton];
    
    self.separatorLayer = [CALayer qmui_separatorLayer];
    [self.view.layer addSublayer:self.separatorLayer];
    
    // 边框按钮
    self.borderedButton = [QDUIHelper generateLightBorderedButton];
    [self.borderedButton setTitle:@"边框支持高亮的按钮" forState:UIControlStateNormal];
    [self.view addSubview:self.borderedButton];
    
    // 图片+文字按钮
    self.imagePositionButton1 = [[QMUIButton alloc] init];
    self.imagePositionButton1.tintColorAdjustsTitleAndImage = [QDThemeManager sharedInstance].currentTheme.themeTintColor;
    self.imagePositionButton1.imagePosition = QMUIButtonImagePositionTop;// 将图片位置改为在文字上方
    self.imagePositionButton1.spacingBetweenImageAndTitle = 8;
    [self.imagePositionButton1 setImage:UIImageMake(@"icon_emotion") forState:UIControlStateNormal];
    [self.imagePositionButton1 setTitle:@"图片在上方的按钮" forState:UIControlStateNormal];
    self.imagePositionButton1.titleLabel.font = UIFontMake(11);
    self.imagePositionButton1.qmui_borderPosition = QMUIBorderViewPositionTop | QMUIBorderViewPositionBottom;
    [self.view addSubview:self.imagePositionButton1];
    
    self.imagePositionButton2 = [[QMUIButton alloc] init];
    self.imagePositionButton2.tintColorAdjustsTitleAndImage = [QDThemeManager sharedInstance].currentTheme.themeTintColor;
    self.imagePositionButton2.imagePosition = QMUIButtonImagePositionBottom;// 将图片位置改为在文字下方
    self.imagePositionButton2.spacingBetweenImageAndTitle = 8;
    [self.imagePositionButton2 setImage:UIImageMake(@"icon_emotion") forState:UIControlStateNormal];
    [self.imagePositionButton2 setTitle:@"图片在下方的按钮" forState:UIControlStateNormal];
    self.imagePositionButton2.titleLabel.font = UIFontMake(11);
    self.imagePositionButton2.qmui_borderPosition = QMUIBorderViewPositionTop | QMUIBorderViewPositionBottom;
    [self.view addSubview:self.imagePositionButton2];
    
    self.imageButtonSeparatorLayer = [CAShapeLayer qmui_seperatorDashLayerWithLineLength:3 lineSpacing:2 lineWidth:PixelOne lineColor:UIColorSeparator.CGColor isHorizontal:NO];
    [self.view.layer addSublayer:self.imageButtonSeparatorLayer];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat contentMinY = self.qmui_navigationBarMaxYInViewCoordinator;
    CGFloat buttonSpacingHeight = QDButtonSpacingHeight;
    
    // 普通按钮
    self.normalButton.frame = CGRectSetXY(self.normalButton.frame, CGFloatGetCenter(CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.normalButton.frame)), contentMinY + CGFloatGetCenter(buttonSpacingHeight, CGRectGetHeight(self.normalButton.frame)));
    self.separatorLayer.frame = CGRectFlatMake(0, contentMinY + buttonSpacingHeight - PixelOne, CGRectGetWidth(self.view.bounds), PixelOne);
    
    // 边框按钮
    self.borderedButton.frame = CGRectSetY(self.normalButton.frame, CGRectGetMaxY(self.separatorLayer.frame) + CGFloatGetCenter(buttonSpacingHeight, CGRectGetHeight(self.normalButton.frame)));
    
    // 图片+文字按钮
    self.imagePositionButton1.frame = CGRectFlatMake(0, contentMinY + buttonSpacingHeight * 2, CGRectGetWidth(self.view.bounds) / 2.0, buttonSpacingHeight);
    self.imagePositionButton2.frame = CGRectSetX(self.imagePositionButton1.frame, CGRectGetMaxX(self.imagePositionButton1.frame));
    
    self.imageButtonSeparatorLayer.frame = CGRectFlatMake(CGRectGetMaxX(self.imagePositionButton1.frame), CGRectGetMinY(self.imagePositionButton1.frame), PixelOne, buttonSpacingHeight);
}

@end
