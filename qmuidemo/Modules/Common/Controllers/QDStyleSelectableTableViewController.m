//
//  QDStyleSelectableTableViewController.m
//  qmuidemo
//
//  Created by MoLice on 2020/7/8.
//  Copyright © 2020 QMUI Team. All rights reserved.
//

#import "QDStyleSelectableTableViewController.h"

@implementation QDStyleSelectableTableViewController

- (void)setupNavigationItems {
    [super setupNavigationItems];
    if (!self.segmentedTitleView) {
        self.segmentedTitleView = [[UISegmentedControl alloc] initWithItems:@[
            @"Plain",
            @"Grouped",
            @"InsetGrouped"
        ]];
        [self.segmentedTitleView addTarget:self action:@selector(handleTableViewStyleChanged:) forControlEvents:UIControlEventValueChanged];
        
        UIColor *tintColor = self.navigationController.navigationBar.tintColor;
        if (@available(iOS 13.0, *)) {
            self.segmentedTitleView.selectedSegmentTintColor = tintColor;
        } else {
            self.segmentedTitleView.tintColor = tintColor;
        }
        [self.segmentedTitleView setTitleTextAttributes:@{NSForegroundColorAttributeName: tintColor} forState:UIControlStateNormal];
        [self.segmentedTitleView setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColor.qd_tintColor} forState:UIControlStateSelected];
    }
    self.segmentedTitleView.selectedSegmentIndex = self.tableView.qmui_style;
    self.navigationItem.titleView = self.segmentedTitleView;
}

- (void)handleTableViewStyleChanged:(UISegmentedControl *)segmentedControl {
    self.tableView = [[QMUITableView alloc] initWithFrame:self.view.bounds style:segmentedControl.selectedSegmentIndex];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view sendSubviewToBack:self.tableView];
}

@end
