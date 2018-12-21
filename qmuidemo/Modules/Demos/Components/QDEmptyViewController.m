//
//  QDEmptyViewController.m
//  qmui
//
//  Created by QMUI Team on 14-7-3.
//  Copyright (c) 2014年 QMUI Team. All rights reserved.
//

#import "QDEmptyViewController.h"

@interface QDEmptyViewController ()

@property(nonatomic, assign) UIStatusBarStyle statusBarStyle;
@end

@implementation QDEmptyViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        self.shouldShowSearchBar = YES;
        self.statusBarStyle = [super preferredStatusBarStyle];
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.statusBarStyle;
}

#pragma mark - 工具方法

- (void)reload:(id)sender {
    [self hideEmptyView];
    [self.tableView reloadData];
}

#pragma mark - <QMUITableViewDataSource, QMUITableViewDelegate>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.emptyViewShowing ? 0 : 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    QMUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[QMUITableViewCell alloc] initForTableView:tableView withReuseIdentifier:identifier];
    }
    [cell updateCellAppearanceWithIndexPath:indexPath];
    NSInteger row = indexPath.row;
    if (row == 0) {
        cell.textLabel.text = @"显示loading";
    } else if (row == 1) {
        cell.textLabel.text = @"显示提示语";
    } else if (row == 2) {
        cell.textLabel.text = @"显示提示语及操作按钮";
    } else if (row == 3) {
        cell.textLabel.text = @"显示占位图及文字";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row == 0) {
        [self showEmptyViewWithLoading];
    } else if (row == 1) {
        [self showEmptyViewWithText:@"联系人为空" detailText:@"请到设置-隐私查看你的联系人权限设置" buttonTitle:nil buttonAction:NULL];
    } else if (row == 2) {
        [self showEmptyViewWithText:@"请求失败" detailText:@"请检查网络连接" buttonTitle:@"重试" buttonAction:@selector(reload:)];
    } else if (row == 3) {
        [self showEmptyViewWithImage:UIImageMake(@"icon_grid_emptyView") text:nil detailText:@"图片间距可通过imageInsets来调整" buttonTitle:nil buttonAction:NULL];
    }
    [self.tableView reloadData];
}

#pragma mark - <QMUISearchControllerDelegate>

- (void)willPresentSearchController:(QMUISearchController *)searchController {
    self.statusBarStyle = UIStatusBarStyleDefault;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)willDismissSearchController:(QMUISearchController *)searchController {
    self.statusBarStyle = [super preferredStatusBarStyle];
    [self setNeedsStatusBarAppearanceUpdate];
}

@end
