//
//  QDFloatLayoutViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 2016/11/10.
//  Copyright © 2016年 QMUI Team. All rights reserved.
//

#import "QDFloatLayoutViewController.h"

@interface QDFloatLayoutViewController ()

@property(nonatomic, strong) QMUIFloatLayoutView *floatLayoutView;
@end

@implementation QDFloatLayoutViewController

- (void)initSubviews {
    [super initSubviews];
    self.floatLayoutView = [[QMUIFloatLayoutView alloc] init];
    self.floatLayoutView.padding = UIEdgeInsetsMake(12, 12, 12, 12);
    self.floatLayoutView.itemMargins = UIEdgeInsetsMake(10, 10, 10, 10);
    self.floatLayoutView.minimumItemSize = CGSizeMake(69, 29);// 以2个字的按钮作为最小宽度
    self.floatLayoutView.layer.borderWidth = PixelOne;
    self.floatLayoutView.layer.borderColor = UIColorSeparator.CGColor;
    [self.view addSubview:self.floatLayoutView];
    
    NSArray<NSString *> *suggestions = @[@"东野圭吾", @"三体", @"爱", @"红楼梦", @"理智与情感", @"读书热榜", @"免费榜"];
    for (NSInteger i = 0; i < suggestions.count; i++) {
        QMUIButton *button = [QDUIHelper generateGhostButtonWithColor:UIColor.qd_tintColor];
        [button setTitle:suggestions[i] forState:UIControlStateNormal];
        button.titleLabel.font = UIFontMake(14);
        button.contentEdgeInsets = UIEdgeInsetsMake(6, 20, 6, 20);
        [self.floatLayoutView addSubview:button];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIEdgeInsets padding = UIEdgeInsetsMake(self.qmui_navigationBarMaxYInViewCoordinator + 36, 24 + self.view.safeAreaInsets.left, 36, 24 + self.view.safeAreaInsets.right);
    self.floatLayoutView.frame = CGRectMake(padding.left, padding.top, CGRectGetWidth(self.view.bounds) - UIEdgeInsetsGetHorizontalValue(padding), QMUIViewSelfSizingHeight);
}

@end
