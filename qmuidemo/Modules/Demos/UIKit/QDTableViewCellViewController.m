//
//  QDTableViewCellViewController.m
//  qmui
//
//  Created by ZhoonChen on 14/11/5.
//  Copyright (c) 2014年 QMUI Team. All rights reserved.
//

#import "QDTableViewCellViewController.h"
#import "QDTableViewCellInsetsViewController.h"
#import "QDTableViewCellAccessoryTypeViewController.h"
#import "QDTableViewCellDynamicHeightViewController.h"

@interface QDTableViewCellViewController ()

@end

@implementation QDTableViewCellViewController

- (void)initDataSource {
    self.dataSourceWithDetailText = [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                                     @"通过 insets 系列属性调整间距", @"",
                                     @"通过配置表修改 accessoryType 的样式", @"",
                                     @"动态高度计算", @"",
                                     nil];
}

- (void)didSelectCellWithTitle:(NSString *)title {
    [self.tableView qmui_clearsSelection];
    UIViewController *viewController = nil;
    NSString *dataString = title;
    if ([dataString isEqualToString:@"通过 insets 系列属性调整间距"]) {
        viewController = [[QDTableViewCellInsetsViewController alloc] init];
    } else if ([dataString isEqualToString:@"通过配置表修改 accessoryType 的样式"]) {
        viewController = [[QDTableViewCellAccessoryTypeViewController alloc] init];
    } else if ([dataString isEqualToString:@"动态高度计算"]) {
        viewController = [[QDTableViewCellDynamicHeightViewController alloc] init];
    }
    viewController.title = title;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
