//
//  QDNavigationListViewController.m
//  qmuidemo
//
//  Created by zhoonchen on 16/9/5.
//  Copyright © 2016年 QMUI Team. All rights reserved.
//

#import "QDNavigationListViewController.h"
#import "QDInterceptBackButtonEventViewController.h"
#import "QDChangeNavBarStyleViewController.h"
#import "QDNavigationTransitionViewController.h"

@implementation QDNavigationListViewController

- (void)initDataSource {
    [super initDataSource];
    self.dataSourceWithDetailText = [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                                     @"拦截系统navBar返回按钮事件", @"例如询问已输入的内容要不要保存",
                                     @"感知系统的手势返回", @"可感知到是否成功手势返回或者中断了",
                                     @"方便控制界面导航栏样式", @"方便控制前后两个界面的导航栏和状态栏样式",
                                     @"优化导航栏在转场时的样式", @"优化系统navController只有一个navBar带来的问题",
                                     nil];
}

- (void)didSelectCellWithTitle:(NSString *)title {
    UIViewController *viewController = nil;
    if ([title isEqualToString:@"拦截系统navBar返回按钮事件"]) {
        viewController = [[QDInterceptBackButtonEventViewController alloc] init];
    }
    else if ([title isEqualToString:@"感知系统的手势返回"]) {
        viewController = [[QDNavigationTransitionViewController alloc] init];
    }
    else if ([title isEqualToString:@"方便控制界面导航栏样式"]) {
        viewController = [[QDChangeNavBarStyleViewController alloc] init];
    }
    else if ([title isEqualToString:@"优化导航栏在转场时的样式"]) {
        viewController = [[QDChangeNavBarStyleViewController alloc] init];
        ((QDChangeNavBarStyleViewController *)viewController).customNavBarTransition = YES;
    }
    viewController.title = title;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
