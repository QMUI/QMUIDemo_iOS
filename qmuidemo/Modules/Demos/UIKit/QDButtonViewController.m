//
//  QDButtonViewController.m
//  qmui
//
//  Created by ZhoonChen on 14/11/6.
//  Copyright (c) 2014年 QMUI Team. All rights reserved.
//

#import "QDButtonViewController.h"
#import "QDNormalButtonViewController.h"
#import "QDLinkButtonViewController.h"
#import "QDGhostButtonViewController.h"
#import "QDFillButtonViewController.h"
#import "QDNavigationButtonViewController.h"
#import "QDToolBarButtonViewController.h"

@implementation QDButtonViewController

- (void)initDataSource {
    self.dataSource = @[@"QMUIButton",
                        @"QMUILinkButton",
                        @"QMUIGhostButton",
                        @"QMUIFillButton",
                        @"QMUINavigationButton",
                        @"QMUIToolbarButton"];
}

- (void)didSelectCellWithTitle:(NSString *)title {
    UIViewController *viewController = nil;
    if ([title isEqualToString:@"QMUIButton"]) {
        viewController = [[QDNormalButtonViewController alloc] init];
    } else if ([title isEqualToString:@"QMUILinkButton"]) {
        viewController = [[QDLinkButtonViewController alloc] init];
    } else if ([title isEqualToString:@"QMUIGhostButton"]) {
        viewController = [[QDGhostButtonViewController alloc] init];
    } else if ([title isEqualToString:@"QMUIFillButton"]) {
        viewController = [[QDFillButtonViewController alloc] init];
    } else if ([title isEqualToString:@"QMUINavigationButton"]) {
        viewController = [[QDNavigationButtonViewController alloc] init];
    } else if ([title isEqualToString:@"QMUIToolbarButton"]) {
        viewController = [[QDToolBarButtonViewController alloc] init];
    }
    viewController.title = title;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
