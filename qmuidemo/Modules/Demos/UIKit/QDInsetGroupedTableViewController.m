//
//  QDInsetGroupedTableViewController.m
//  qmuidemo
//
//  Created by MoLice on 2020/6/1.
//  Copyright © 2020 QMUI Team. All rights reserved.
//

#import "QDInsetGroupedTableViewController.h"
#import "QDDynamicHeightTableViewCell.h"

@interface QDInsetGroupedTableViewController ()

@property(nonatomic, strong) NSArray<NSString *> *texts;
@end

@implementation QDInsetGroupedTableViewController

- (instancetype)init {
    // 只要传进去 style 即可使用，其他东西与普通列表用法一致
    return [self initWithStyle:QMUITableViewStyleInsetGrouped];
}

- (void)didInitializeWithStyle:(UITableViewStyle)style {
    [super didInitializeWithStyle:style];
    self.texts = @[
        @"全局 UI 配置：只需要修改一份配置表就可以调整 App 的全局样式，包括颜色、导航栏、输入框、列表等。一处修改，全局生效。",
        @"UIKit 拓展及版本兼容：拓展多个 UIKit 的组件，提供更加丰富的特性和功能，提高开发效率；解决不同 iOS 版本常见的兼容性问题。",
        @"全局 UI 配置：只需要修改一份配置表就可以调整 App 的全局样式，包括颜色、导航栏、输入框、列表等。一处修改，全局生效。\nUIKit 拓展及版本兼容：拓展多个 UIKit 的组件，提供更加丰富的特性和功能，提高开发效率；解决不同 iOS 版本常见的兼容性问题。\n高效的工具方法及宏：提供高效的工具方法，包括设备信息、动态字体、键盘管理、状态栏管理等，可以解决各种常见场景并大幅度提升开发效率。"
    ];
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem qmui_itemWithImage:UIImageMake(@"icon_nav_about") target:self action:@selector(handleDebugItemEvent)];
}

- (void)handleDebugItemEvent {
    __weak __typeof(self)weakSelf = self;
    QMUIPopupMenuView *menu = [[QMUIPopupMenuView alloc] init];
    menu.items = @[
        [QMUIPopupMenuButtonItem itemWithImage:nil title:@"标准间距" handler:^(QMUIPopupMenuButtonItem * _Nonnull aItem) {
            if ([aItem.title isEqualToString:@"标准间距"]) {
                aItem.title = @"紧凑间距";
                weakSelf.tableView.qmui_insetGroupedHorizontalInset = 10;
            } else {
                aItem.title = @"标准间距";
                weakSelf.tableView.qmui_insetGroupedHorizontalInset = TableViewInsetGroupedHorizontalInset;
            }
        }],
        [QMUIPopupMenuButtonItem itemWithImage:nil title:@"标准圆角" handler:^(QMUIPopupMenuButtonItem * _Nonnull aItem) {
            if ([aItem.title isEqualToString:@"标准圆角"]) {
                aItem.title = @"小圆角";
                weakSelf.tableView.qmui_insetGroupedCornerRadius = 3;
            } else {
                aItem.title = @"标准圆角";
                weakSelf.tableView.qmui_insetGroupedCornerRadius = TableViewInsetGroupedCornerRadius;
            }
        }],
        [QMUIPopupMenuButtonItem itemWithImage:nil title:@"进入编辑" handler:^(QMUIPopupMenuButtonItem * _Nonnull aItem) {
            if ([aItem.title isEqualToString:@"进入编辑"]) {
                aItem.title = @"退出编辑";
                weakSelf.tableView.editing = YES;
            } else {
                aItem.title = @"进入编辑";
                weakSelf.tableView.editing = NO;
            }
            [weakSelf.tableView reloadData];
            
        }],
    ];
    menu.automaticallyHidesWhenUserTap = YES;
    menu.maskViewBackgroundColor = nil;
    menu.sourceBarItem = self.navigationItem.rightBarButtonItem;
    [menu showWithAnimated:YES];
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    QDDynamicHeightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[QDDynamicHeightTableViewCell alloc] initForTableView:tableView withReuseIdentifier:identifier];
    }
    [cell renderWithNameText:[NSString stringWithFormat:@"%@ - %@", @(indexPath.section), @(indexPath.row)] contentText:self.texts[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Section Header %@", @(section)];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Section Footer %@", @(section)];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {

}

@end
