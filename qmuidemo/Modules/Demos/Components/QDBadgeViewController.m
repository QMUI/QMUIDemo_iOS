//
//  QDBadgeViewController.m
//  qmuidemo
//
//  Created by molicechen(陈沛钞) on 2018/6/2.
//  Copyright © 2018年 QMUI Team. All rights reserved.
//

#import "QDBadgeViewController.h"

@interface QDBadgeViewController ()

@property(nonatomic, strong) UITabBar *tabBar;
@end

@implementation QDBadgeViewController

- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem qmui_itemWithImage:UIImageMake(@"icon_nav_about") target:nil action:NULL];
}

- (void)initSubviews {
    [super initSubviews];
    self.tabBar = [[UITabBar alloc] init];
    self.tabBar.tintColor = TabBarTintColor;
    
    UITabBarItem *item1 = [QDUIHelper tabBarItemWithTitle:@"QMUIKit" image:[UIImageMake(@"icon_tabbar_uikit") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:UIImageMake(@"icon_tabbar_uikit_selected") tag:0];
    
    UITabBarItem *item2 = [QDUIHelper tabBarItemWithTitle:@"Components" image:[UIImageMake(@"icon_tabbar_component") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:UIImageMake(@"icon_tabbar_component_selected") tag:1];
    item2.qmui_badgeString = @"99+";// 支持字符串
    
    UITabBarItem *item3 = [QDUIHelper tabBarItemWithTitle:@"Lab" image:[UIImageMake(@"icon_tabbar_lab") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:UIImageMake(@"icon_tabbar_lab_selected") tag:2];
    
    self.tabBar.items = @[item1, item2, item3];
    self.tabBar.selectedItem = item1;
    [self.tabBar sizeToFit];
    [self.view addSubview:self.tabBar];
    
    // 统一调整横屏模式下 UITabBarItem 的红点和未读数偏移位置（具体值视业务设计不同而不同）
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        item.qmui_badgeCenterOffsetLandscape = CGPointMake(9, -7);
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat tabBarHeight = TabBarHeight;
    self.tabBar.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - tabBarHeight, CGRectGetWidth(self.view.bounds), tabBarHeight);
}

- (void)initDataSource {
    self.dataSource = @[@"在 UIBarButtonItem 上显示红点",
                        @"在 UITabBarItem 上显示红点",
                        @"在 UITabBarItem 上显示未读数",
                        @"修改红点/未读数的样式（多点几次试试）",
                        @"隐藏所有红点、未读数"];
}

- (void)didSelectCellWithTitle:(NSString *)title {
    if ([title isEqualToString:@"在 UIBarButtonItem 上显示红点"]) {
        
        // 有使用配置表的时候，最简单的代码就只是控制显隐即可，没使用配置表的话，还需要设置其他的属性才能使红点样式正确，具体请看 UIBarButton+QMUIBadge.h 注释
        self.navigationItem.rightBarButtonItem.qmui_shouldShowUpdatesIndicator = YES;
        
    } else if ([title isEqualToString:@"在 UITabBarItem 上显示红点"]) {
        
        UITabBarItem *item = self.tabBar.items.firstObject;
        item.qmui_shouldShowUpdatesIndicator = YES;
        item.qmui_badgeInteger = 0;
        
    } else if ([title isEqualToString:@"在 UITabBarItem 上显示未读数"]) {
        
        UITabBarItem *item = self.tabBar.items.firstObject;
        item.qmui_shouldShowUpdatesIndicator = NO;
        item.qmui_badgeInteger = 12;
        
    } else if ([title isEqualToString:@"修改红点/未读数的样式（多点几次试试）"]) {
        
        UITabBarItem *item = self.tabBar.items[1];
        item.qmui_badgeString = @"99+";// 支持字符串
        item.qmui_badgeBackgroundColor = [QDCommonUI randomThemeColor];
        
    } else if ([title isEqualToString:@"隐藏所有红点、未读数"]) {
        
        self.navigationItem.rightBarButtonItem.qmui_shouldShowUpdatesIndicator = NO;
        [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            item.qmui_shouldShowUpdatesIndicator = NO;
            item.qmui_badgeInteger = 0;
        }];
        
    }
    [self.tableView qmui_clearsSelection];
}

@end
