//
//  QDSearchBarViewController.m
//  qmuidemo
//
//  Created by MoLice on 2020/7/7.
//  Copyright © 2020 QMUI Team. All rights reserved.
//

#import "QDSearchBarViewController.h"

@interface QDSearchBarViewController ()<QMUISearchControllerDelegate>

@property(nonatomic, assign) BOOL animated;
@property(nonatomic, assign) UIStatusBarStyle statusBarStyle;
@end

@implementation QDSearchBarViewController

- (void)didInitializeWithStyle:(UITableViewStyle)style {
    [super didInitializeWithStyle:style];
    self.shouldShowSearchBar = YES;
    self.animated = YES;
    self.statusBarStyle = [super preferredStatusBarStyle];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.statusBarStyle;
}

- (void)initSearchController {
    [super initSearchController];
    self.searchBar.qmui_leftAccessoryView = [[UIImageView alloc] initWithImage:[UIImage qmui_imageWithStrokeColor:[QDCommonUI randomThemeColor] size:CGSizeMake(30, 30) lineWidth:3 cornerRadius:6]];
    self.searchBar.qmui_rightAccessoryView = [[UIImageView alloc] initWithImage:[UIImage qmui_imageWithStrokeColor:[QDCommonUI randomThemeColor] size:CGSizeMake(30, 30) lineWidth:3 cornerRadius:6]];
    self.searchBar.qmui_leftAccessoryViewMargins = UIEdgeInsetsMake(0, 8, 0, 0);
    self.searchBar.qmui_rightAccessoryViewMargins = UIEdgeInsetsMake(0, 0, 0, 8);
    
    // 为了 Demo 效果，先隐藏再让用户手动显示
    self.searchBar.qmui_showsLeftAccessoryView = NO;
    self.searchBar.qmui_showsRightAccessoryView = NO;
}

- (void)initTableView {
    [super initTableView];
    __weak __typeof(self)weakSelf = self;
    NSMutableArray *sections = @[
        @[
            ({
                QMUIStaticTableViewCellData *data = [[QMUIStaticTableViewCellData alloc] init];
                data.identifier = 0;
                data.text = @"以动画形式展示";
                data.accessoryType = QMUIStaticTableViewCellAccessoryTypeSwitch;
                data.accessoryValueObject = @(weakSelf.animated);
                data.accessorySwitchBlock = ^(UITableView * _Nonnull tableView, QMUIStaticTableViewCellData * _Nonnull cellData, UISwitch * _Nonnull switcher) {
                    weakSelf.animated = switcher.on;
                };
                data.cellForRowBlock = ^(UITableView * _Nonnull tableView, __kindof QMUITableViewCell * _Nonnull cell, QMUIStaticTableViewCellData * _Nonnull cellData) {
                    ((UISwitch *)cell.accessoryView).on = weakSelf.animated;
                };
                data;
            }),
            ({
                QMUIStaticTableViewCellData *data = [[QMUIStaticTableViewCellData alloc] init];
                data.identifier = 1;
                data.text = @"显示 cancelButton";
                data.cellForRowBlock = ^(UITableView * _Nonnull tableView, __kindof QMUITableViewCell * _Nonnull cell, QMUIStaticTableViewCellData * _Nonnull cellData) {
                    cell.textLabel.text = [NSString stringWithFormat:@"%@ cancelButton", weakSelf.searchBar.showsCancelButton ? @"隐藏" : @"显示"];
                };
                data.didSelectBlock = ^(UITableView * _Nonnull tableView, QMUIStaticTableViewCellData * _Nonnull cellData) {
                    [weakSelf.searchBar setShowsCancelButton:!weakSelf.searchBar.showsCancelButton animated:weakSelf.animated];
                    [tableView reloadRowsAtIndexPaths:@[cellData.indexPath] withRowAnimation:UITableViewRowAnimationFade];
                };
                data;
            }),
            ({
                QMUIStaticTableViewCellData *data = [[QMUIStaticTableViewCellData alloc] init];
                data.identifier = 2;
                data.text = @"显示 leftAccessoryView";
                data.cellForRowBlock = ^(UITableView * _Nonnull tableView, __kindof QMUITableViewCell * _Nonnull cell, QMUIStaticTableViewCellData * _Nonnull cellData) {
                    cell.textLabel.text = [NSString stringWithFormat:@"%@ leftAccessoryView", weakSelf.searchBar.qmui_showsLeftAccessoryView ? @"隐藏" : @"显示"];
                };
                data.didSelectBlock = ^(UITableView * _Nonnull tableView, QMUIStaticTableViewCellData * _Nonnull cellData) {
                    // 显示/隐藏 leftAccessoryView
                    [weakSelf.searchBar qmui_setShowsLeftAccessoryView:!weakSelf.searchBar.qmui_showsLeftAccessoryView animated:weakSelf.animated];
                    [tableView reloadRowsAtIndexPaths:@[cellData.indexPath] withRowAnimation:UITableViewRowAnimationFade];
                };
                data;
            }),
            ({
                QMUIStaticTableViewCellData *data = [[QMUIStaticTableViewCellData alloc] init];
                data.identifier = 3;
                data.text = @"显示 rightAccessoryView";
                data.cellForRowBlock = ^(UITableView * _Nonnull tableView, __kindof QMUITableViewCell * _Nonnull cell, QMUIStaticTableViewCellData * _Nonnull cellData) {
                    cell.textLabel.text = [NSString stringWithFormat:@"%@ rightAccessoryView", weakSelf.searchBar.qmui_showsRightAccessoryView ? @"隐藏" : @"显示"];
                };
                data.didSelectBlock = ^(UITableView * _Nonnull tableView, QMUIStaticTableViewCellData * _Nonnull cellData) {
                    [weakSelf.searchBar qmui_setShowsRightAccessoryView:!weakSelf.searchBar.qmui_showsRightAccessoryView animated:weakSelf.animated];
                    [tableView reloadRowsAtIndexPaths:@[cellData.indexPath] withRowAnimation:UITableViewRowAnimationFade];
                };
                data;
            }),
        ]].mutableCopy;
    
    if (@available(iOS 11.0, *)) {
        [sections insertObject:@[
            ({
            QMUIStaticTableViewCellData *data = [[QMUIStaticTableViewCellData alloc] init];
            data.identifier = 4;
            data.text = @"placeholder 居中";
            data.accessoryType = QMUIStaticTableViewCellAccessoryTypeSwitch;
            data.accessoryValueObject = @(weakSelf.searchBar.qmui_centerPlaceholder);
            data.accessorySwitchBlock = ^(UITableView * _Nonnull tableView, QMUIStaticTableViewCellData * _Nonnull cellData, UISwitch * _Nonnull switcher) {
                weakSelf.searchBar.qmui_centerPlaceholder = switcher.on;
            };
            data.cellForRowBlock = ^(UITableView * _Nonnull tableView, __kindof QMUITableViewCell * _Nonnull cell, QMUIStaticTableViewCellData * _Nonnull cellData) {
                ((UISwitch *)cell.accessoryView).on = weakSelf.searchBar.qmui_centerPlaceholder;
            };
            data;
        }),
            ({
            QMUIStaticTableViewCellData *data = [[QMUIStaticTableViewCellData alloc] init];
            data.identifier = 5;
            data.text = @"更换 placeholder 文字";
            data.didSelectBlock = ^(UITableView * _Nonnull tableView, QMUIStaticTableViewCellData * _Nonnull cellData) {
                weakSelf.searchBar.placeholder = @"很长很长很长的 placeholder";
                [tableView qmui_clearsSelection];
            };
            data;
        })
        ] atIndex:0];
    }
    
    self.tableView.qmui_staticCellDataSource = [[QMUIStaticTableViewCellDataSource alloc] initWithCellDataSections:sections];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (@available(iOS 11.0, *)) {
        if (section == 0) return @"Placeholder";
    }
    return @"AccessoryView";
    
}

#pragma mark - <QMUISearchControllerDelegate>

- (void)willPresentSearchController:(QMUISearchController *)searchController {
    if ([QMUIThemeManagerCenter.defaultThemeManager.currentThemeIdentifier isEqual:QDThemeIdentifierDark]) {
        self.statusBarStyle = UIStatusBarStyleLightContent;
    } else {
        self.statusBarStyle = UIStatusBarStyleDefault;
    }
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)willDismissSearchController:(QMUISearchController *)searchController {
    self.statusBarStyle = [super preferredStatusBarStyle];
    [self setNeedsStatusBarAppearanceUpdate];
}

@end
