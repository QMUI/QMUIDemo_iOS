//
//  QDTableViewCellViewController.m
//  qmui
//
//  Created by QMUI Team on 14/11/5.
//  Copyright (c) 2014年 QMUI Team. All rights reserved.
//

#import "QDTableViewCellViewController.h"
#import "QDTableViewCellInsetsViewController.h"
#import "QDTableViewCellAccessoryTypeViewController.h"

@implementation QDTableViewCellViewController

- (void)initDataSource {
    self.dataSource = @[@"通过 insets 系列属性调整间距",
                        @"通过配置表修改 accessoryType 的样式"];
}

- (void)didSelectCellWithTitle:(NSString *)title {
    [self.tableView qmui_clearsSelection];
    UIViewController *viewController = nil;
    if ([title isEqualToString:@"通过 insets 系列属性调整间距"]) {
        viewController = [[QDTableViewCellInsetsViewController alloc] init];
    } else if ([title isEqualToString:@"通过配置表修改 accessoryType 的样式"]) {
        viewController = [[QDTableViewCellAccessoryTypeViewController alloc] init];
    }
    viewController.title = title;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
