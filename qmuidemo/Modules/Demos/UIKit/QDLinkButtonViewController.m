//
//  QDLinkButtonViewController.m
//  qmuidemo
//
//  Created by MoLice on 16/10/12.
//  Copyright (c) 2016年 QMUI Team. All rights reserved.
//

#import "QDLinkButtonViewController.h"
#import "QDCommonUI.h"

@interface QDLinkButtonViewController ()

@property(nonatomic, strong) QMUILinkButton *linkButton1;
@property(nonatomic, strong) CALayer *separatorLayer1;
@property(nonatomic, strong) QMUILinkButton *linkButton2;
@property(nonatomic, strong) CALayer *separatorLayer2;
@property(nonatomic, strong) QMUILinkButton *linkButton3;
@property(nonatomic, strong) CALayer *separatorLayer3;
@end

@implementation QDLinkButtonViewController

- (void)initSubviews {
    [super initSubviews];
    
    self.linkButton1 = [[QMUILinkButton alloc] init];
    self.linkButton1.titleLabel.font = UIFontMake(15);
    [self.linkButton1 setTitle:@"带下划线的按钮" forState:UIControlStateNormal];
    [self.linkButton1 sizeToFit];
    [self.view addSubview:self.linkButton1];
    
    self.separatorLayer1 = [QDCommonUI generateSeparatorLayer];
    [self.view.layer addSublayer:self.separatorLayer1];
    
    self.linkButton2 = [[QMUILinkButton alloc] init];
    self.linkButton2.titleLabel.font = UIFontMake(15);
    [self.linkButton2 setTitle:@"修改下划线颜色" forState:UIControlStateNormal];
    self.linkButton2.underlineColor = UIColorTheme4;
    [self.linkButton2 sizeToFit];
    [self.view addSubview:self.linkButton2];
    
    self.separatorLayer2 = [QDCommonUI generateSeparatorLayer];
    [self.view.layer addSublayer:self.separatorLayer2];
    
    self.linkButton3 = [[QMUILinkButton alloc] init];
    self.linkButton3.titleLabel.font = UIFontMake(15);
    [self.linkButton3 setTitle:@"修改下划线的位置" forState:UIControlStateNormal];
    self.linkButton3.underlineInsets = UIEdgeInsetsMake(0, 32, 0, 46);
    [self.linkButton3 sizeToFit];
    [self.view addSubview:self.linkButton3];
    
    self.separatorLayer3 = [QDCommonUI generateSeparatorLayer];
    [self.view.layer addSublayer:self.separatorLayer3];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat contentMinY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    CGFloat buttonSpacingHeight = 64;
    
    self.separatorLayer1.frame = CGRectMake(0, contentMinY + buttonSpacingHeight - PixelOne, CGRectGetWidth(self.view.bounds), PixelOne);
    self.separatorLayer2.frame = CGRectSetY(self.separatorLayer1.frame, contentMinY + buttonSpacingHeight * 2 - PixelOne);
    self.separatorLayer3.frame = CGRectSetY(self.separatorLayer1.frame, contentMinY + buttonSpacingHeight * 3 - PixelOne);
    
    self.linkButton1.frame = CGRectSetXY(self.linkButton1.frame, CGRectGetMinXHorizontallyCenterInParentRect(self.view.bounds, self.linkButton1.frame), contentMinY + CGFloatGetCenter(buttonSpacingHeight, CGRectGetHeight(self.linkButton1.frame)));
    self.linkButton2.frame = CGRectSetXY(self.linkButton2.frame, CGRectGetMinXHorizontallyCenterInParentRect(self.view.bounds, self.linkButton2.frame), contentMinY + buttonSpacingHeight + CGFloatGetCenter(buttonSpacingHeight, CGRectGetHeight(self.linkButton2.frame)));
    self.linkButton3.frame = CGRectSetXY(self.linkButton3.frame, CGRectGetMinXHorizontallyCenterInParentRect(self.view.bounds, self.linkButton3.frame), contentMinY + buttonSpacingHeight * 2 + CGFloatGetCenter(buttonSpacingHeight, CGRectGetHeight(self.linkButton3.frame)));
}

@end
