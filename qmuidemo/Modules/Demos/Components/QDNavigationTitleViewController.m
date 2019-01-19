//
//  QDNavigationTitleViewController.m
//  qmui
//
//  Created by QMUI Team on 14-7-2.
//  Copyright (c) 2014年 QMUI Team. All rights reserved.
//

#import "QDNavigationTitleViewController.h"

@interface QDNavigationTitleViewController ()<QMUINavigationTitleViewDelegate>

@property(nonatomic, strong) QMUIPopupMenuView *popupMenuView;
@property(nonatomic, assign) UIControlContentHorizontalAlignment horizontalAlignment;
@end

@implementation QDNavigationTitleViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        self.titleView.needsLoadingView = YES;
        self.titleView.qmui_needsDifferentDebugColor = YES;
        self.horizontalAlignment = self.titleView.contentHorizontalAlignment;
    }
    return self;
}

- (void)dealloc {
    self.titleView.delegate = nil;
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.title = @"主标题";
}

- (void)initPopupContainerViewIfNeeded {
    if (!self.popupMenuView) {
        self.popupMenuView = [[QMUIPopupMenuView alloc] init];
        self.popupMenuView.automaticallyHidesWhenUserTap = YES;// 点击空白地方自动消失
        self.popupMenuView.preferLayoutDirection = QMUIPopupContainerViewLayoutDirectionBelow;
        self.popupMenuView.maximumWidth = 220;
        self.popupMenuView.items = @[[QMUIPopupMenuButtonItem itemWithImage:UIImageMake(@"icon_emotion") title:@"分类 1" handler:nil],
                                     [QMUIPopupMenuButtonItem itemWithImage:UIImageMake(@"icon_emotion") title:@"分类 2" handler:nil],
                                     [QMUIPopupMenuButtonItem itemWithImage:UIImageMake(@"icon_emotion") title:@"分类 3" handler:nil]];
        self.popupMenuView.sourceView = self.titleView;
        __weak __typeof(self)weakSelf = self;
        self.popupMenuView.didHideBlock = ^(BOOL hidesByUserTap) {
            weakSelf.titleView.active = NO;
        };
    }
}

- (void)initDataSource {
    self.dataSource = @[@"显示左边的 loading",
                        @"显示右边的 accessoryView",
                        @"显示副标题",
                        @"切换为上下两行显示",
                        @"水平方向的对齐方式",
                        @"模拟标题的 loading 状态切换",
                        @"标题搭配浮层使用的示例",
                        @"显示 Debug 背景色"];
}

#pragma mark - <QMUITableViewDataSource, QMUITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 因为有第 6 行的存在，所以每次都要重置一下这几个属性，避免影响其他 Demo 的展示
    self.titleView.userInteractionEnabled = NO;
    self.titleView.delegate = nil;
    
    switch (indexPath.row) {
        case 0:
            // 切换 loading 的显示/隐藏
            self.titleView.loadingViewHidden = !self.titleView.loadingViewHidden;
            break;
        case 1:
            // 切换右边的 accessoryType 类型，可支持自定义的 accessoryView
            self.titleView.accessoryType = self.titleView.accessoryType == QMUINavigationTitleViewAccessoryTypeNone ? QMUINavigationTitleViewAccessoryTypeDisclosureIndicator : QMUINavigationTitleViewAccessoryTypeNone;
            break;
        case 2:
            // 切换副标题的显示/隐藏
            self.titleView.subtitle = self.titleView.subtitle ? nil : @"(副标题)";
            break;
        case 3:
            // 切换主副标题的水平/垂直布局
            self.titleView.style = self.titleView.style == QMUINavigationTitleViewStyleDefault ? QMUINavigationTitleViewStyleSubTitleVertical : QMUINavigationTitleViewStyleDefault;
            self.titleView.subtitle = self.titleView.style == QMUINavigationTitleViewStyleSubTitleVertical ? @"(副标题)" : self.titleView.subtitle;
            break;
        case 4:
            // 水平对齐方式
        {
            QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"水平对齐方式" message:nil preferredStyle:QMUIAlertControllerStyleActionSheet];
            [alertController addAction:[QMUIAlertAction actionWithTitle:@"左对齐" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
                self.titleView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                self.horizontalAlignment = self.titleView.contentHorizontalAlignment;
                [self.tableView reloadData];
            }]];
            [alertController addAction:[QMUIAlertAction actionWithTitle:@"居中对齐" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
                self.titleView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                self.horizontalAlignment = self.titleView.contentHorizontalAlignment;
                [self.tableView reloadData];
            }]];
            [alertController addAction:[QMUIAlertAction actionWithTitle:@"右对齐" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
                self.titleView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                self.horizontalAlignment = self.titleView.contentHorizontalAlignment;
                [self.tableView reloadData];
            }]];
            [alertController addAction:[QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:nil]];
            [alertController showWithAnimated:YES];
        }
            break;
        case 5:
            // 模拟不同状态之间的切换
        {
            self.titleView.loadingViewHidden = NO;
            self.titleView.needsLoadingPlaceholderSpace = NO;
            self.titleView.title = @"加载中...";
            self.titleView.subtitle = nil;
            self.titleView.style = QMUINavigationTitleViewStyleDefault;
            self.titleView.accessoryType = QMUINavigationTitleViewAccessoryTypeNone;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.titleView.needsLoadingPlaceholderSpace = YES;
                self.titleView.loadingViewHidden = YES;
                self.titleView.title = @"主标题";
            });
        }
            break;
        case 6:
            // 标题搭配浮层的使用示例
        {
            self.titleView.userInteractionEnabled = YES;// 要titleView支持点击，需要打开它的 userInteractionEnabled，这个属性默认是 NO
            self.titleView.title = @"点我展开分类";
            self.titleView.accessoryType = QMUINavigationTitleViewAccessoryTypeDisclosureIndicator;
            self.titleView.delegate = self;// 要监听 titleView 的点击事件以及状态切换，需要通过 delegate 的形式
            [self initPopupContainerViewIfNeeded];
        }
            break;
        case 7:
            // Debug 背景色
            self.titleView.qmui_shouldShowDebugColor = YES;
            break;
    }
    
    [tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QMUITableViewCell *cell = (QMUITableViewCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.detailTextLabel.text = nil;
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = self.titleView.loadingViewHidden ? @"显示左边的 loading" : @"隐藏左边的 loading";
            break;
        case 1:
            cell.textLabel.text = self.titleView.accessoryType == QMUINavigationTitleViewAccessoryTypeNone ? @"显示右边的 accessoryView" : @"去掉右边的 accessoryView";
            break;
        case 2:
            cell.textLabel.text = self.titleView.subtitle ? @"去掉副标题" : @"显示副标题";
            break;
        case 3:
            cell.textLabel.text = self.titleView.style == QMUINavigationTitleViewStyleDefault ? @"切换为上下两行显示" : @"切换为水平一行显示";
            break;
        case 4:
            cell.detailTextLabel.text = (self.horizontalAlignment == UIControlContentHorizontalAlignmentLeft ? @"左对齐" : (self.horizontalAlignment == UIControlContentHorizontalAlignmentRight ? @"右对齐" : @"居中对齐"));
            break;
    }
    return cell;
}

#pragma mark - <QMUINavigationTitleViewDelegate>

- (void)didChangedActive:(BOOL)active forTitleView:(QMUINavigationTitleView *)titleView {
    if (active) {
        [self.popupMenuView showWithAnimated:YES];
    }
}

@end
