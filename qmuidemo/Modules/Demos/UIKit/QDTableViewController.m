//
//  QDTableViewController.m
//  qmuidemo
//
//  Created by MoLice on 2017/11/7.
//  Copyright © 2017年 QMUI Team. All rights reserved.
//

#import "QDTableViewController.h"
#import "QDTableViewCellViewController.h"
#import "QDTableViewIndexViewController.h"

@interface QDTableViewController ()

@end

@implementation QDTableViewController

- (void)initDataSource {
    self.dataSource = @[@"QMUITableViewCell",
                        @"获取某个 view 所处的 sectionHeader 的 index"];
}

- (void)didSelectCellWithTitle:(NSString *)title {
    [self.tableView qmui_clearsSelection];
    UIViewController *viewController = nil;
    if ([title isEqualToString:@"QMUITableViewCell"]) {
        viewController = [[QDTableViewCellViewController alloc] init];
    } else if ([title isEqualToString:@"获取某个 view 所处的 sectionHeader 的 index"]) {
        viewController = [[QDTableViewIndexViewController alloc] init];
    }
    viewController.title = title;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
