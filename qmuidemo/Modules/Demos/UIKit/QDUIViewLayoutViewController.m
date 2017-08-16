//
//  QDUIViewLayoutViewController.m
//  qmuidemo
//
//  Created by MoLice on 2017/8/9.
//  Copyright © 2017年 QMUI Team. All rights reserved.
//

#import "QDUIViewLayoutViewController.h"

@interface QDUIViewLayoutViewController ()

@property(nonatomic, strong) UIView *view1;
@property(nonatomic, strong) UIView *view2;
@property(nonatomic, strong) UIView *view3;
@end

@implementation QDUIViewLayoutViewController

- (void)initSubviews {
    [super initSubviews];
    self.view1 = [[UIView alloc] init];
    self.view1.backgroundColor = [QDCommonUI randomThemeColor];
    [self.view addSubview:self.view1];
    
    self.view2 = [[UIView alloc] init];
    self.view2.backgroundColor = [QDCommonUI randomThemeColor];
    [self.view addSubview:self.view2];
    
    self.view3 = [[UIView alloc] init];
    self.view3.backgroundColor = [QDCommonUI randomThemeColor];
    [self.view addSubview:self.view3];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIEdgeInsets padding = UIEdgeInsetsMake(24, 24, 24, 24);
    CGFloat contentWidth = CGRectGetWidth(self.view.bounds) - UIEdgeInsetsGetHorizontalValue(padding);
    
    // 所有布局都需要在同一个坐标系里才有效
    
    self.view1.qmui_left = padding.left;
    self.view1.qmui_top = self.qmui_navigationBarMaxYInViewCoordinator + padding.top;
    self.view1.qmui_width = contentWidth;
    self.view1.qmui_height = 40;
    
    self.view2.qmui_left = self.view1.qmui_left;
    self.view2.qmui_top = self.view1.qmui_bottom + 24;
    self.view2.qmui_width = self.view1.qmui_width / 2;
    self.view2.qmui_height = 40;
    
    self.view3.qmui_width = self.view1.qmui_width / 2;
    self.view3.qmui_height = 40;
    self.view3.qmui_top = self.view2.qmui_bottom + 24;
    self.view3.qmui_right = self.view1.qmui_right;
}

@end
