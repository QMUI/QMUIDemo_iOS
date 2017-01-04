//
//  QDNavigationTitleViewController.m
//  qmui
//
//  Created by MoLice on 14-7-2.
//  Copyright (c) 2014年 QMUI Team. All rights reserved.
//

#import "QDNavigationTitleViewController.h"

@interface QDNavigationTitleViewController ()<QMUINavigationTitleViewDelegate>

@property(nonatomic, strong) QMUIPopupContainerView *popupContainerView;
@end

@implementation QDNavigationTitleViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        self.titleView.needsLoadingView = YES;
    }
    return self;
}

- (void)dealloc {
    self.titleView.delegate = nil;
}

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    self.title = @"主标题";
}

- (void)initPopupContainerViewIfNeeded {
    if (!self.popupContainerView) {
        self.popupContainerView = [[QMUIPopupContainerView alloc] init];
        self.popupContainerView.preferLayoutDirection = QMUIPopupContainerViewLayoutDirectionBelow;
        self.popupContainerView.textLabel.attributedText = [[NSAttributedString alloc] initWithString:@"分类1\n分类2\n分类3\n真实情况请搭配 UITableView" attributes:@{NSFontAttributeName: UIFontMake(16), NSForegroundColorAttributeName: UIColorGray2, NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:40 lineBreakMode:NSLineBreakByWordWrapping textAlignment:NSTextAlignmentCenter], NSBaselineOffsetAttributeName: @5}];
        self.popupContainerView.hidden = YES;
        [self.navigationController.view addSubview:self.popupContainerView];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.popupContainerView.isShowing) {
        [self.popupContainerView layoutWithReferenceItemRectInSuperview:[self.popupContainerView.superview convertRect:self.titleView.frame fromView:self.titleView.superview]];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.titleView.active = NO;
}

- (void)initDataSource {
    self.dataSource = @[@"显示左边的 loading",
                        @"显示右边的 accessoryView",
                        @"显示副标题",
                        @"切换为上下两行显示",
                        @"模拟标题的 loading 状态切换",
                        @"标题搭配浮层使用的示例"];
}

#pragma mark - <QMUITableViewDataSource, QMUITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 如果出现浮层的情况下，要先让浮层消失
    // 注意让浮层消失的方式是更改titleView.active状态，而非直接调用浮层的hide方法
    if (self.titleView.active) {
        self.titleView.active = NO;
        return;
    }
    
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
        case 5:
            // 标题搭配浮层的使用示例
        {
            self.titleView.userInteractionEnabled = YES;// 要titleView支持点击，需要打开它的 userInteractionEnabled，这个属性默认是 NO
            self.titleView.title = @"点我展开分类";
            self.titleView.accessoryType = QMUINavigationTitleViewAccessoryTypeDisclosureIndicator;
            self.titleView.delegate = self;// 要监听 titleView 的点击事件以及状态切换，需要通过 delegate 的形式
            [self initPopupContainerViewIfNeeded];
        }
            break;
    }
    
    [tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QMUITableViewCell *cell = (QMUITableViewCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
    }
    return cell;
}

#pragma mark - <QMUINavigationTitleViewDelegate>

- (void)didChangedActive:(BOOL)active forTitleView:(QMUINavigationTitleView *)titleView {
    if (active) {
        [self.popupContainerView layoutWithReferenceItemRectInSuperview:[self.popupContainerView.superview convertRect:self.titleView.frame fromView:self.titleView.superview]];
        [self.popupContainerView showWithAnimated:YES];
    } else {
        [self.popupContainerView hideWithAnimated:YES];
    }
}

@end
