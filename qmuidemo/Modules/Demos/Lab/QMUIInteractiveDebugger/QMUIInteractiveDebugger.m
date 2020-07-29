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
        UIColor *shadowColor = nil;
        if (@available(iOS 13.0, *)) {
            shadowColor = presentingViewController.tabBarController.tabBar.standardAppearance.shadowColor;
        } else {
            shadowColor = TabBarShadowImageColor;
        }
        actionView.text = shadowColor.qmui_RGBAString;
    } valueSetter:^(QMUITextField * _Nonnull actionView) {
        UIColor *shadowColor = [UIColor qmui_colorWithRGBAString:actionView.text];
        if (@available(iOS 13.0, *)) {
            presentingViewController.tabBarController.tabBar.standardAppearance.shadowColor = shadowColor;
        } else {
            presentingViewController.tabBarController.tabBar.shadowImage = [UIImage qmui_imageWithColor:shadowColor size:CGSizeMake(4, PixelOne) cornerRadius:0];
        }
    }]];
    [viewController addDebugItem:[QMUIInteractiveDebugPanelItem colorItemWithTitle:@"背景色" valueGetter:^(QMUITextField * _Nonnull actionView) {
        UIColor *barTintColor = nil;
        if (@available(iOS 13.0, *)) {
            barTintColor = presentingViewController.tabBarController.tabBar.standardAppearance.backgroundColor;
        } else {
            barTintColor = TabBarBarTintColor;
        }
        actionView.text = barTintColor.qmui_RGBAString;
    } valueSetter:^(QMUITextField * _Nonnull actionView) {
        UIColor *barTintColor = [UIColor qmui_colorWithRGBAString:actionView.text];
        if (@available(iOS 13.0, *)) {
            presentingViewController.tabBarController.tabBar.standardAppearance.backgroundColor = barTintColor;
        } else {
            presentingViewController.tabBarController.tabBar.barTintColor = barTintColor;
        }
    }]];
    [viewController addDebugItem:[QMUIInteractiveDebugPanelItem numbericItemWithTitle:@"标题垂直间距" valueGetter:^(QMUITextField * _Nonnull actionView) {
        CGFloat titleOffset = 0;
        if (@available(iOS 13.0, *)) {
            titleOffset = presentingViewController.tabBarController.tabBar.standardAppearance.stackedLayoutAppearance.normal.titlePositionAdjustment.vertical;
        } else {
            titleOffset = presentingViewController.tabBarController.tabBar.items.firstObject.titlePositionAdjustment.vertical;
        }
        actionView.text = [NSString stringWithFormat:@"%.1f", titleOffset];
    } valueSetter:^(QMUITextField * _Nonnull actionView) {
        CGFloat offset = actionView.text.floatValue;
        if (@available(iOS 13.0, *)) {
            presentingViewController.tabBarController.tabBar.standardAppearance.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffsetMake(0, offset);
        } else {
            [presentingViewController.tabBarController.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.titlePositionAdjustment = UIOffsetMake(0, offset);
            }];
        }
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
        UIColor *shadowColor = nil;
        if (@available(iOS 13.0, *)) {
            shadowColor = presentingViewController.navigationController.navigationBar.standardAppearance.shadowColor;
        } else {
            shadowColor = NavBarShadowImageColor;
        }
        actionView.text = shadowColor.qmui_RGBAString;
    } valueSetter:^(QMUITextField * _Nonnull actionView) {
        UIColor *shadowColor = [UIColor qmui_colorWithRGBAString:actionView.text];
        if (@available(iOS 13.0, *)) {
            presentingViewController.navigationController.navigationBar.standardAppearance.shadowColor = shadowColor;
        } else {
            presentingViewController.navigationController.navigationBar.shadowImage = [UIImage qmui_imageWithColor:shadowColor size:CGSizeMake(4, PixelOne) cornerRadius:0];
        }
    }]];
    [viewController addDebugItem:[QMUIInteractiveDebugPanelItem colorItemWithTitle:@"背景色" valueGetter:^(QMUITextField * _Nonnull actionView) {
        UIColor *barTintColor = nil;
        if (@available(iOS 13.0, *)) {
            barTintColor = presentingViewController.navigationController.navigationBar.standardAppearance.backgroundColor;
        } else {
            barTintColor = NavBarBarTintColor;
        }
        actionView.text = barTintColor.qmui_RGBAString;
    } valueSetter:^(QMUITextField * _Nonnull actionView) {
        UIColor *barTintColor = [UIColor qmui_colorWithRGBAString:actionView.text];
        presentingViewController.navigationController.navigationBar.translucent = barTintColor.qmui_alpha < 1;
        if (@available(iOS 13.0, *)) {
            presentingViewController.navigationController.navigationBar.standardAppearance.backgroundColor = barTintColor;
            presentingViewController.navigationController.navigationBar.standardAppearance.backgroundImage = nil;
        } else {
            presentingViewController.navigationController.navigationBar.barTintColor = barTintColor;
            [presentingViewController.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        }
    }]];
    [viewController presentInViewController:presentingViewController];
}

@end
