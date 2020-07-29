//
//  QDBadgeViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 2018/6/2.
//  Copyright © 2018年 QMUI Team. All rights reserved.
//

#import "QDBadgeViewController.h"

@interface QDBadgeViewController ()

@property(nonatomic, strong) UIToolbar *toolbar;
@property(nonatomic, strong) UITabBar *tabBar;
@end

@implementation QDBadgeViewController

- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem qmui_itemWithImage:UIImageMake(@"icon_nav_about") target:nil action:NULL];
}

- (void)initSubviews {
    [super initSubviews];
    
    self.toolbar = [[UIToolbar alloc] init];
    self.toolbar.tintColor = UIColor.qd_tintColor;
    self.toolbar.items = @[
        [UIBarButtonItem qmui_flexibleSpaceItem],
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:nil action:NULL],
        [UIBarButtonItem qmui_flexibleSpaceItem],
        [UIBarButtonItem qmui_itemWithImage:UIImageMake(@"icon_tabbar_uikit") target:nil action:NULL],
        [UIBarButtonItem qmui_flexibleSpaceItem],
        [UIBarButtonItem qmui_itemWithTitle:@"ToolbarItem" target:nil action:NULL],
        [UIBarButtonItem qmui_flexibleSpaceItem],
    ];
    [self.toolbar sizeToFit];
    self.toolbar.items[1].qmui_shouldShowUpdatesIndicator = YES;
    self.toolbar.items[3].qmui_badgeInteger = 8;
    self.toolbar.items[5].qmui_badgeString = @"99+";
    [self.view addSubview:self.toolbar];
    
    self.tabBar = [[UITabBar alloc] init];
    
    UITabBarItem *item1 = [QDUIHelper tabBarItemWithTitle:@"QMUIKit" image:[UIImageMake(@"icon_tabbar_uikit") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:UIImageMake(@"icon_tabbar_uikit_selected") tag:0];
    
    UITabBarItem *item2 = [QDUIHelper tabBarItemWithTitle:@"Components" image:[UIImageMake(@"icon_tabbar_component") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:UIImageMake(@"icon_tabbar_component_selected") tag:1];
    item2.qmui_badgeString = @"99+";// 支持字符串
    
    UITabBarItem *item3 = [QDUIHelper tabBarItemWithTitle:@"Lab" image:[UIImageMake(@"icon_tabbar_lab") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:UIImageMake(@"icon_tabbar_lab_selected") tag:2];
    
    self.tabBar.items = @[item1, item2, item3];
    self.tabBar.selectedItem = item1;
    [self.tabBar sizeToFit];
    [self.view addSubview:self.tabBar];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.textLabel.qmui_shouldShowUpdatesIndicator = YES;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat tabBarHeight = TabBarHeight;
    self.tabBar.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - tabBarHeight, CGRectGetWidth(self.view.bounds), tabBarHeight);
    self.toolbar.frame = CGRectMake(0, CGRectGetMinY(self.tabBar.frame) - CGRectGetHeight(self.toolbar.frame), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.toolbar.frame));
}

- (void)initDataSource {
    self.dataSource = [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                       @"UIView", [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                                   @"在 UIView 上显示红点", @"点击可切换红点的显隐",
                                   nil],
                       @"UIBarItem", [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                                      @"在 UIBarButtonItem 上显示红点", @"",
                                      @"在 UITabBarItem 上显示红点", @"",
                                      @"在 UITabBarItem 上显示未读数", @"",
                                      @"修改红点/未读数的样式（多点几次试试）", @"",
                                      @"隐藏所有红点、未读数", @"",
                                      nil],
                       nil];
}

- (void)didSelectCellWithTitle:(NSString *)title {
    if ([title isEqualToString:@"在 UIView 上显示红点"]) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.textLabel.qmui_shouldShowUpdatesIndicator = !cell.textLabel.qmui_shouldShowUpdatesIndicator;
    } else if ([title isEqualToString:@"在 UIBarButtonItem 上显示红点"]) {
        
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
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.textLabel.qmui_shouldShowUpdatesIndicator = NO;
        self.navigationItem.rightBarButtonItem.qmui_shouldShowUpdatesIndicator = NO;
        [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            item.qmui_shouldShowUpdatesIndicator = NO;
            item.qmui_badgeInteger = 0;
        }];
        
    }
    [self.tableView qmui_clearsSelection];
}

@end
