//
//  QDNavigationBarScrollingSnapAnimatorViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 2018/O/29.
//  Copyright © 2018 QMUI Team. All rights reserved.
//

#import "QDNavigationBarScrollingSnapAnimatorViewController.h"

@interface QDNavigationBarScrollingSnapAnimatorViewController ()

@property(nonatomic, strong) QMUINavigationBarScrollingSnapAnimator *navigationAnimator;
@end

@implementation QDNavigationBarScrollingSnapAnimatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationAnimator = [[QMUINavigationBarScrollingSnapAnimator alloc] init];
    self.navigationAnimator.scrollView = self.tableView;
    self.navigationAnimator.offsetYToStartAnimation = 44;// 设置滚动的起点，默认是 0，也即 scrollView 在默认位置稍微往下滚则开始做动画，44 则表示在默认位置再往下滚动44之后才触发动画
    __weak __typeof(self)weakSelf = self;
    self.navigationAnimator.animationBlock = ^(QMUINavigationBarScrollingSnapAnimator * _Nonnull animator, BOOL offsetYReached) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSLog(@"导航栏%@, inset.top = %.2f, offset.y = %.2f", offsetYReached ? @"被隐藏了" : @"显示出来了", strongSelf.tableView.contentInset.top, strongSelf.tableView.contentOffset.y);
        [strongSelf.navigationController setNavigationBarHidden:offsetYReached animated:YES];
    };
    
    // 为了避免更改 navigationBar 显隐影响 scrollView 的滚动，这里屏蔽掉自动适应 contentInset
    if (@available(iOS 11, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.contentInset = UIEdgeInsetsMake(self.qmui_navigationBarMaxYInViewCoordinator, 0, self.view.qmui_safeAreaInsets.bottom, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    [self.tableView qmui_scrollToTopUponContentInsetTopChange];
}

// 建议配合 QMUINavigationControllerDelegate 控制不同界面切换时的 navigationBar 样式/显隐，否则需自己在 viewWillAppear:、viewWillDisappear: 里控制

#pragma mark - <QMUINavigationControllerDelegate>

- (BOOL)preferredNavigationBarHidden {
    return self.navigationAnimator.offsetYReached;
}

- (BOOL)forceEnableInteractivePopGestureRecognizer {
    return self.navigationAnimator.offsetYReached;
}

#pragma mark - <QMUITableViewDataSource, QMUITableViewDelegate>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    QMUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[QMUITableViewCell alloc] initForTableView:tableView withReuseIdentifier:identifier];
    }
    cell.textLabel.text = [NSString qmui_stringWithNSInteger:indexPath.row];
    [cell updateCellAppearanceWithIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
