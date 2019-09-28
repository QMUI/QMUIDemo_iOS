//
//  QDNavigationListViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 16/9/5.
//  Copyright © 2016年 QMUI Team. All rights reserved.
//

#import "QDNavigationListViewController.h"
#import "QDInterceptBackButtonEventViewController.h"
#import "QDChangeNavBarStyleViewController.h"
#import "QDNavigationTransitionViewController.h"
#import "QDNavigationBarMaxYViewController.h"
#import "QDLargeTitlesViewController.h"

@implementation QDNavigationListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isMovingToParentViewController) {
         QMUICMI.needsBackBarButtonItemTitle = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isMovingFromParentViewController) {
         QMUICMI.needsBackBarButtonItemTitle = NO;
    }
}


- (void)initDataSource {
    [super initDataSource];
    if ([UINavigationBar instancesRespondToSelector:@selector(prefersLargeTitles)]) {
        self.dataSourceWithDetailText = [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                                         @"拦截系统navBar返回按钮事件", @"例如询问已输入的内容要不要保存",
                                         @"感知系统的手势返回", @"可感知到是否成功手势返回或者中断了",
                                         @"方便控制界面导航栏样式", @"方便控制前后两个界面的导航栏和状态栏样式",
                                         @"优化导航栏在转场时的样式", @"优化系统navController只有一个navBar带来的问题",
                                         @"获取导航栏的正确布局位置", @"特别是前后两个界面导航栏显隐状态不一致时容易出现布局跳动",
                                         @"兼容 LargeTitle", @"感知 LargeTitle 显示与隐藏",
                                         nil];
    } else {
        self.dataSourceWithDetailText = [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                                         @"拦截系统navBar返回按钮事件", @"例如询问已输入的内容要不要保存",
                                         @"感知系统的手势返回", @"可感知到是否成功手势返回或者中断了",
                                         @"方便控制界面导航栏样式", @"方便控制前后两个界面的导航栏和状态栏样式",
                                         @"优化导航栏在转场时的样式", @"优化系统navController只有一个navBar带来的问题",
                                         @"获取导航栏的正确布局位置", @"特别是前后两个界面导航栏显隐状态不一致时容易出现布局跳动",
                                         nil];
    }
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
    else if ([title isEqualToString:@"获取导航栏的正确布局位置"]) {
        viewController = [[QDNavigationBarMaxYViewController alloc] init];
        ((QDNavigationBarMaxYViewController *)viewController).navigationBarHidden = YES;
    }
    else if ([title isEqualToString:@"兼容 LargeTitle"]) {
        viewController = [[QDLargeTitlesViewController alloc] init];
    }
    viewController.title = title;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
