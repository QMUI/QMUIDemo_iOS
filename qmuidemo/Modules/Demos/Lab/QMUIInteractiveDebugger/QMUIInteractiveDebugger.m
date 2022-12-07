//
//  QMUIInteractiveDebugger.m
//  qmuidemo
//
//  Created by MoLice on 2020/5/19.
//  Copyright © 2020 QMUI Team. All rights reserved.
//

#import "QMUIInteractiveDebugger.h"

@implementation QMUIInteractiveDebugger

+ (void)presentTabBarDebuggerInViewController:(UIViewController *)presentingViewController {
    QMUIInteractiveDebugPanelViewController *viewController = [[QMUIInteractiveDebugPanelViewController alloc] init];
    viewController.title = @"UITabBar";
    [viewController addDebugItem:[QMUIInteractiveDebugPanelItem colorItemWithTitle:@"分隔线颜色" valueGetter:^(QMUITextField * _Nonnull actionView) {
        UIColor *shadowColor = presentingViewController.tabBarController.tabBar.standardAppearance.shadowColor;
        actionView.text = shadowColor.qmui_RGBAString;
    } valueSetter:^(QMUITextField * _Nonnull actionView) {
        UIColor *shadowColor = [UIColor qmui_colorWithRGBAString:actionView.text];
        presentingViewController.tabBarController.tabBar.standardAppearance.shadowColor = shadowColor;
    }]];
    [viewController addDebugItem:[QMUIInteractiveDebugPanelItem colorItemWithTitle:@"背景色" valueGetter:^(QMUITextField * _Nonnull actionView) {
        UIColor *barTintColor = presentingViewController.tabBarController.tabBar.standardAppearance.backgroundColor;
        actionView.text = barTintColor.qmui_RGBAString;
    } valueSetter:^(QMUITextField * _Nonnull actionView) {
        UIColor *barTintColor = [UIColor qmui_colorWithRGBAString:actionView.text];
        presentingViewController.tabBarController.tabBar.standardAppearance.backgroundColor = barTintColor;
    }]];
    [viewController addDebugItem:[QMUIInteractiveDebugPanelItem numbericItemWithTitle:@"标题垂直间距" valueGetter:^(QMUITextField * _Nonnull actionView) {
        CGFloat titleOffset = presentingViewController.tabBarController.tabBar.standardAppearance.stackedLayoutAppearance.normal.titlePositionAdjustment.vertical;
        actionView.text = [NSString stringWithFormat:@"%.1f", titleOffset];
    } valueSetter:^(QMUITextField * _Nonnull actionView) {
        CGFloat offset = actionView.text.floatValue;
        presentingViewController.tabBarController.tabBar.standardAppearance.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffsetMake(0, offset);
        [presentingViewController.tabBarController.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj.qmui_view setNeedsLayout];
        }];
    }]];
    [viewController presentInViewController:presentingViewController];
}

+ (void)presentNavigationBarDebuggerInViewController:(UIViewController *)presentingViewController {
    QMUIInteractiveDebugPanelViewController *viewController = [[QMUIInteractiveDebugPanelViewController alloc] init];
    viewController.title = @"UINavigationBar";
    [viewController addDebugItem:[QMUIInteractiveDebugPanelItem colorItemWithTitle:@"分隔线颜色" valueGetter:^(QMUITextField * _Nonnull actionView) {
        UIColor *shadowColor = presentingViewController.navigationController.navigationBar.standardAppearance.shadowColor;
        actionView.text = shadowColor.qmui_RGBAString;
    } valueSetter:^(QMUITextField * _Nonnull actionView) {
        UIColor *shadowColor = [UIColor qmui_colorWithRGBAString:actionView.text];
        presentingViewController.navigationController.navigationBar.standardAppearance.shadowColor = shadowColor;
    }]];
    [viewController addDebugItem:[QMUIInteractiveDebugPanelItem colorItemWithTitle:@"背景色" valueGetter:^(QMUITextField * _Nonnull actionView) {
        UIColor *barTintColor = presentingViewController.navigationController.navigationBar.standardAppearance.backgroundColor;
        actionView.text = barTintColor.qmui_RGBAString;
    } valueSetter:^(QMUITextField * _Nonnull actionView) {
        UIColor *barTintColor = [UIColor qmui_colorWithRGBAString:actionView.text];
        presentingViewController.navigationController.navigationBar.translucent = barTintColor.qmui_alpha < 1;
        presentingViewController.navigationController.navigationBar.standardAppearance.backgroundColor = barTintColor;
        presentingViewController.navigationController.navigationBar.standardAppearance.backgroundImage = nil;
    }]];
    [viewController presentInViewController:presentingViewController];
}

@end
