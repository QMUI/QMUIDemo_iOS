//
//  QDTableViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 2017/11/7.
//  Copyright © 2017年 QMUI Team. All rights reserved.
//

#import "QDTableViewController.h"
#import "QDTableViewCellViewController.h"
#import "QDTableViewHeaderFooterViewController.h"

@interface QDTableViewController ()

@end

@implementation QDTableViewController

- (void)initDataSource {
    self.dataSource = @[@"QMUITableViewCell",
                        @"QMUITableViewHeaderFooterView"];
}

- (void)didSelectCellWithTitle:(NSString *)title {
    UIViewController *viewController = nil;
    if ([title isEqualToString:@"QMUITableViewCell"]) {
        viewController = [[QDTableViewCellViewController alloc] init];
    } else if ([title isEqualToString:@"QMUITableViewHeaderFooterView"]) {
        viewController = [[QDTableViewHeaderFooterViewController alloc] init];
    }
    viewController.title = title;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
