//
//  QDLabelViewController.m
//  qmui
//
//  Created by MoLice on 14-7-13.
//  Copyright (c) 2014年 QMUI Team. All rights reserved.
//

#import "QDLabelViewController.h"

@interface QDLabelViewController ()

@property(nonatomic, strong) QMUILabel *label1;
@property(nonatomic, strong) QMUILabel *label2;
@property(nonatomic, strong) QMUILabel *label3;

@property(nonatomic, strong) CALayer *separatorLayer1;
@property(nonatomic, strong) CALayer *separatorLayer2;
@property(nonatomic, strong) CALayer *separatorLayer3;

@end

@implementation QDLabelViewController

#pragma mark - 生命周期函数

- (void)initSubviews {
    [super initSubviews];

    _label1 = [[QMUILabel alloc] init];
    self.label1.text = @"可长按复制";
    self.label1.font = UIFontMake(15);
    self.label1.textColor = UIColorGray5;
    self.label1.canPerformCopyAction = YES;
    [self.label1 sizeToFit];
    [self.view addSubview:self.label1];
    
    _label2 = [[QMUILabel alloc] init];
    self.label2.text = @"可设置 contentInsets";
    self.label2.font = UIFontMake(15);
    self.label2.textColor = UIColorWhite;
    self.label2.backgroundColor = UIColorGray8;
    self.label2.contentEdgeInsets = UIEdgeInsetsMake(8, 16, 8, 16);
    [self.label2 sizeToFit];
    [self.view addSubview:self.label2];
    
    _label3 = [[QMUILabel alloc] init];
    self.label3.text = @"复制上面第二个label的样式";
    [self.label3 qmui_setTheSameAppearanceAsLabel:self.label2];
    [self.label3 sizeToFit];
    [self.view addSubview:self.label3];
    
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
    
    self.label1.frame = CGRectSetXY(self.label1.frame, CGFloatGetCenter(CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.label1.bounds)), contentMinY + CGFloatGetCenter(buttonSpacingHeight, CGRectGetHeight(self.label1.bounds)));
    
    self.separatorLayer1.frame = CGRectMake(0, contentMinY + buttonSpacingHeight * 1, CGRectGetWidth(self.view.bounds), PixelOne);
    
    self.label2.frame = CGRectSetXY(self.label2.frame, CGFloatGetCenter(CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.label2.bounds)), CGRectGetMaxY(self.separatorLayer1.frame) + CGFloatGetCenter(buttonSpacingHeight, CGRectGetHeight(self.label2.bounds)));
    
    self.separatorLayer2.frame = CGRectMake(0, contentMinY + buttonSpacingHeight * 2, CGRectGetWidth(self.view.bounds), PixelOne);
    
    self.label3.frame = CGRectSetXY(self.label3.frame, CGFloatGetCenter(CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.label3.bounds)), CGRectGetMaxY(self.separatorLayer2.frame) + CGFloatGetCenter(buttonSpacingHeight, CGRectGetHeight(self.label3.bounds)));
    
    self.separatorLayer3.frame = CGRectMake(0, contentMinY + buttonSpacingHeight * 3, CGRectGetWidth(self.view.bounds), PixelOne);
}

@end
