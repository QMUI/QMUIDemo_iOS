//
//  QDGhostButtonViewController.m
//  qmuidemo
//
//  Created by ZhoonChen on 15/5/23.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QDGhostButtonViewController.h"
#import "QDCommonUI.h"

@interface QDGhostButtonViewController ()

@property(nonatomic, strong) QMUIGhostButton *ghostButton1;
@property(nonatomic, strong) QMUIGhostButton *ghostButton2;
@property(nonatomic, strong) QMUIGhostButton *ghostButton3;
@property(nonatomic, strong) CALayer *separatorLayer1;
@property(nonatomic, strong) CALayer *separatorLayer2;
@property(nonatomic, strong) CALayer *separatorLayer3;
@end

@implementation QDGhostButtonViewController

- (void)initSubviews {
    [super initSubviews];
    self.ghostButton1 = [[QMUIGhostButton alloc] initWithGhostType:QMUIGhostButtonColorBlue];
    self.ghostButton1.titleLabel.font = UIFontMake(14);
    [self.ghostButton1 setTitle:@"QMUIGhostButtonColorBlue" forState:UIControlStateNormal];
    [self.view addSubview:self.ghostButton1];
    
    self.ghostButton2 = [[QMUIGhostButton alloc] initWithGhostType:QMUIGhostButtonColorRed];
    self.ghostButton2.titleLabel.font = UIFontMake(14);
    [self.ghostButton2 setTitle:@"QMUIGhostButtonColorRed" forState:UIControlStateNormal];
    [self.view addSubview:self.ghostButton2];
    
    self.ghostButton3 = [[QMUIGhostButton alloc] initWithGhostType:QMUIGhostButtonColorGreen];
    self.ghostButton3.titleLabel.font = UIFontMake(14);
    [self.ghostButton3 setTitle:@"点击修改ghostColor" forState:UIControlStateNormal];
    [self.ghostButton3 setImage:UIImageMake(@"icon_emotion") forState:UIControlStateNormal];
    self.ghostButton3.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 6);
    self.ghostButton3.adjustsImageWithGhostColor = YES;
    [self.ghostButton3 addTarget:self action:@selector(handleGhostButtonColorEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.ghostButton3];
    
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
    
    self.ghostButton1.frame = CGRectFlatMake(buttonMinX, contentMinY + buttonOffsetY, buttonSize.width, buttonSize.height);
    self.ghostButton2.frame = CGRectFlatMake(buttonMinX, contentMinY + buttonSpacingHeight + buttonOffsetY, buttonSize.width, buttonSize.height);
    self.ghostButton3.frame = CGRectFlatMake(buttonMinX, contentMinY + buttonSpacingHeight * 2 + buttonOffsetY, buttonSize.width, buttonSize.height);
    
    self.separatorLayer1.frame = CGRectMake(0, contentMinY + buttonSpacingHeight - PixelOne, CGRectGetWidth(self.view.bounds), PixelOne);
    self.separatorLayer2.frame = CGRectSetY(self.separatorLayer1.frame, contentMinY + buttonSpacingHeight * 2 - PixelOne);
    self.separatorLayer3.frame = CGRectSetY(self.separatorLayer1.frame, contentMinY + buttonSpacingHeight * 3 - PixelOne);
}

- (void)handleGhostButtonColorEvent {
    UIColor *color = [QDCommonUI randomThemeColor];
    self.ghostButton3.ghostColor = color;
}

@end
