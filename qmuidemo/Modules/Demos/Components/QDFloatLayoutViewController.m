//
//  QDFloatLayoutViewController.m
//  qmuidemo
//
//  Created by MoLice on 2016/11/10.
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
    self.floatLayoutView.itemMargins = UIEdgeInsetsMake(0, 0, 10, 10);
    self.floatLayoutView.minimumItemSize = CGSizeMake(69, 29);// 以2个字的按钮作为最小宽度
    self.floatLayoutView.layer.borderWidth = PixelOne;
    self.floatLayoutView.layer.borderColor = UIColorSeparator.CGColor;
    [self.view addSubview:self.floatLayoutView];
    
    NSArray<NSString *> *suggestions = @[@"东野圭吾", @"三体", @"爱", @"红楼梦", @"理智与情感", @"读书热榜", @"免费榜"];
    for (NSInteger i = 0; i < suggestions.count; i++) {
        QMUIGhostButton *button = [[QMUIGhostButton alloc] init];
        button.ghostColor = [QDThemeManager sharedInstance].currentTheme.themeTintColor;
        [button setTitle:suggestions[i] forState:UIControlStateNormal];
        button.titleLabel.font = UIFontMake(14);
        button.contentEdgeInsets = UIEdgeInsetsMake(6, 20, 6, 20);
        [self.floatLayoutView addSubview:button];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIEdgeInsets padding = UIEdgeInsetsMake(self.qmui_navigationBarMaxYInViewCoordinator + 36, 24, 36, 24);
    CGFloat contentWidth = CGRectGetWidth(self.view.bounds) - UIEdgeInsetsGetHorizontalValue(padding);
    CGSize floatLayoutViewSize = [self.floatLayoutView sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
    self.floatLayoutView.frame = CGRectMake(padding.left, padding.top, contentWidth, floatLayoutViewSize.height);
}

@end
