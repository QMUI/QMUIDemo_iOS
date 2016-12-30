//
//  QDTableViewCellViewController.m
//  qmui
//
//  Created by ZhoonChen on 14/11/5.
//  Copyright (c) 2014年 QMUI Team. All rights reserved.
//

#import "QDTableViewCellViewController.h"
#import "QDInsetsTableviewCellViewController.h"
#import "QDDynamicTableViewCellViewController.h"

@interface QDTableViewCellViewController ()

@end

@implementation QDTableViewCellViewController

- (void)initDataSource {
    self.dataSourceWithDetailText = [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                                     @"设置insets", @"",
                                     @"动态高度计算", @"",
                                     nil];
}

- (void)didSelectCellWithTitle:(NSString *)title {
    [self.tableView qmui_clearsSelection];
    UIViewController *viewController = nil;
    NSString *dataString = title;
    if ([dataString isEqualToString:@"设置insets"]) {
        viewController = [[QDInsetsTableviewCellViewController alloc] init];
    } else if ([dataString isEqualToString:@"动态高度计算"]) {
        viewController = [[QDDynamicTableViewCellViewController alloc] init];
    }
    viewController.title = title;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
