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
@end

@implementation QDSearchBarViewController

- (void)didInitializeWithStyle:(UITableViewStyle)style {
    [super didInitializeWithStyle:style];
    self.shouldShowSearchBar = YES;
    self.animated = YES;
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
    self.tableView.qmui_staticCellDataSource = [[QMUIStaticTableViewCellDataSource alloc] initWithCellDataSections:@[
        @[
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
        ],
        @[
            ({
                QMUIStaticTableViewCellData *data = [[QMUIStaticTableViewCellData alloc] init];
                data.identifier = 6;
                data.text = @"调整默认状态输入框布局";
                data.didSelectBlock = ^(UITableView * _Nonnull tableView, QMUIStaticTableViewCellData * _Nonnull cellData) {
                    [tableView qmui_clearsSelection];
                    weakSelf.searchBar.qmui_textFieldMarginsBlock = ^UIEdgeInsets(__kindof UISearchBar * _Nonnull searchBar, BOOL active) {
                        if (active) {
                            return UIEdgeInsetsZero;
                        } else {
                            return UIEdgeInsetsMake(0, 32, 0, 32);
                        }
                    };
                };
                data;
            }),
            ({
                QMUIStaticTableViewCellData *data = [[QMUIStaticTableViewCellData alloc] init];
                data.identifier = 7;
                data.text = @"调整搜索状态取消按钮布局";
                data.didSelectBlock = ^(UITableView * _Nonnull tableView, QMUIStaticTableViewCellData * _Nonnull cellData) {
                    [tableView qmui_clearsSelection];
                    weakSelf.searchBar.qmui_cancelButtonMarginsBlock = ^UIEdgeInsets(__kindof UISearchBar * _Nonnull searchBar, BOOL active) {
                        if (active) {
                            return UIEdgeInsetsMake(0, -16, 0, 0);
                        }
                        return UIEdgeInsetsZero;
                    };
                    if (!weakSelf.searchController.active) {
                        weakSelf.searchController.active = YES;
                    }
                };
                data;
            })
        ],
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
        ]]];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @[
        @"Placeholder",
        @"Layout",
        @"AccessoryView",
    ][section];
}

@end
