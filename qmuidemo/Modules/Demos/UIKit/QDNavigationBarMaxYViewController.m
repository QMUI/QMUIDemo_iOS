//
//  QDNavigationBarMaxYViewController.m
//  qmuidemo
//
//  Created by MoLice on 2019/A/13.
//  Copyright © 2019 QMUI Team. All rights reserved.
//

#import "QDNavigationBarMaxYViewController.h"

@interface QDNavigationBarMaxYViewController ()

@property(nonatomic, strong) UIView *testView;
@end

@implementation QDNavigationBarMaxYViewController

- (void)initDataSource {
    [super initDataSource];
    self.dataSource = @[@"进入显示 navigationBar 的界面",
                        @"进入隐藏 navigationBar 的界面"];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"\n色块顶部的 y 值也即 self.qmui_navigationBarMaxYInViewCoordinator 的值，选择不同显隐状态进入下一个界面，观察 push/pop/手势返回过程中色块布局是否会跳动";
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    QMUITableViewHeaderFooterView *footerView = (QMUITableViewHeaderFooterView *)[super tableView:tableView viewForFooterInSection:section];
    footerView.backgroundView.backgroundColor = UIColorClear;
    footerView.contentEdgeInsets = UIEdgeInsetsSetTop(footerView.contentEdgeInsets, 0);
    footerView.titleLabel.font = UIFontMake(12);
    footerView.titleLabel.textColor = UIColor.qd_descriptionTextColor;
    footerView.titleLabel.qmui_borderPosition = QMUIViewBorderPositionTop;
    footerView.titleLabel.qmui_borderColor = TableViewSeparatorColor;
    return footerView;
}

- (void)didSelectCellWithTitle:(NSString *)title {
    QDNavigationBarMaxYViewController *viewController = [[QDNavigationBarMaxYViewController alloc] init];
    viewController.navigationBarHidden = [title isEqualToString:@"进入隐藏 navigationBar 的界面"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 主动在转场过程中触发布局的重新运算
    [self.view setNeedsLayout];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view setNeedsLayout];
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 主动在转场过程中触发布局的重新运算
    [self.view setNeedsLayout];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view setNeedsLayout];
    });
}

- (void)initSubviews {
    [super initSubviews];
    self.testView = [[UIView alloc] qmui_initWithSize:CGSizeMake(100, 100)];
    self.testView.userInteractionEnabled = NO;
    self.testView.backgroundColor = [[QDCommonUI randomThemeColor] colorWithAlphaComponent:.3];
    [self.view addSubview:self.testView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // y 紧贴着导航栏底部，以表示当前的 self.qmui_navigationBarMaxYInViewCoordinator 的值
    self.testView.frame = CGRectSetXY(self.testView.frame, CGFloatGetCenter(CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.testView.frame)), self.qmui_navigationBarMaxYInViewCoordinator);
}

- (BOOL)preferredNavigationBarHidden {
    return self.navigationBarHidden;
}

- (BOOL)forceEnableInteractivePopGestureRecognizer {
    return YES;
}

@end
