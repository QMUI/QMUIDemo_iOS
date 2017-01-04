//
//  QDNavigationButtonViewController.m
//  qmuidemo
//
//  Created by zhoonchen on 2016/10/13.
//  Copyright © 2016年 QMUI Team. All rights reserved.
//

#import "QDNavigationButtonViewController.h"

@interface QDNavigationButtonViewController ()

@property(nonatomic, assign) BOOL forceEnableBackGesture;

@end

@implementation QDNavigationButtonViewController

- (void)initDataSource {
    self.dataSource = @[@"普通导航栏按钮",
                        @"加粗导航栏按钮",
                        @"图标导航栏按钮",
                        @"关闭导航栏按钮(支持手势返回)",
                        @"自定义返回按钮(支持手势返回)"];
}

- (void)didSelectCellWithTitle:(NSString *)title {
    if ([title isEqualToString:@"普通导航栏按钮"]) {
        self.navigationItem.rightBarButtonItem = [QMUINavigationButton barButtonItemWithType:QMUINavigationButtonTypeNormal title:@"取消" position:QMUINavigationButtonPositionRight target:self action:NULL];
    } else if ([title isEqualToString:@"加粗导航栏按钮"]) {
        self.navigationItem.rightBarButtonItem = [QMUINavigationButton barButtonItemWithType:QMUINavigationButtonTypeBold title:@"完成(5)" position:QMUINavigationButtonPositionRight target:self action:NULL];
    } else if ([title isEqualToString:@"图标导航栏按钮"]) {
        UIImage *image = [UIImage qmui_imageWithStrokeColor:UIColorWhite size:CGSizeMake(20, 20) lineWidth:3 cornerRadius:10];
        self.navigationItem.rightBarButtonItem = [QMUINavigationButton barButtonItemWithImage:image position:QMUINavigationButtonPositionRight target:self action:NULL];
    } else if ([title isEqualToString:@"关闭导航栏按钮(支持手势返回)"]) {
        self.forceEnableBackGesture = YES;
        self.navigationItem.leftBarButtonItem = [QMUINavigationButton closeBarButtonItemWithTarget:self action:@selector(handleCloseButtonEvent:)];
    } else if ([title isEqualToString:@"自定义返回按钮(支持手势返回)"]) {
        self.forceEnableBackGesture = YES;
        QMUINavigationButton *backButton = [[QMUINavigationButton alloc] initWithType:QMUINavigationButtonTypeBack title:@"返回"];
        self.navigationItem.leftBarButtonItem = [QMUINavigationButton barButtonItemWithNavigationButton:backButton position:QMUINavigationButtonPositionLeft target:self action:@selector(handleBackButtonEvent:)];
    }
    [self.tableView qmui_clearsSelection];
}

- (void)handleCloseButtonEvent:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleBackButtonEvent:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)forceEnableInteractivePopGestureRecognizer {
    return self.forceEnableBackGesture;
}

@end
