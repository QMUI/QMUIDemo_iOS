//
//  QDNavigationBarScrollingAnimatorViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 2018/O/29.
//  Copyright © 2018 QMUI Team. All rights reserved.
//

#import "QDNavigationBarScrollingAnimatorViewController.h"

@interface QDNavigationBarScrollingAnimatorViewController ()

@property(nonatomic, strong) QMUINavigationBarScrollingAnimator *navigationAnimator;
@end

@implementation QDNavigationBarScrollingAnimatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationAnimator = [[QMUINavigationBarScrollingAnimator alloc] init];
    self.navigationAnimator.scrollView = self.tableView;// 指定要关联的 scrollView
    self.navigationAnimator.offsetYToStartAnimation = 30;// 设置滚动的起点，值即表示在默认停靠的位置往下滚动多少距离后即触发动画，默认是 0
    self.navigationAnimator.distanceToStopAnimation = 64;// 设置从起点开始滚动多长的距离达到终点
    
    // 有两种方式更改 navigationBar 的样式，一种是利用 animator 为每个属性提供的单独 block，直接返回这个属性在特定 progress 下的样式即可，另一种是直接用 animationBlock，Demo 这里使用第一种。
    // 若使用第二种，则第一种会失效。
    // 若希望同时使用两种，则请在 animationBlock 里手动获取各个属性对应的 block 的返回值并设置到 navigationBar 上。
    self.navigationAnimator.backgroundImageBlock = ^UIImage * _Nonnull(QMUINavigationBarScrollingAnimator * _Nonnull animator, float progress) {
        return [NavBarBackgroundImage qmui_imageWithAlpha:progress];
    };
    self.navigationAnimator.shadowImageBlock = ^UIImage * _Nonnull(QMUINavigationBarScrollingAnimator * _Nonnull animator, float progress) {
        return [NavBarShadowImage qmui_imageWithAlpha:progress];
    };
    self.navigationAnimator.tintColorBlock = ^UIColor * _Nonnull(QMUINavigationBarScrollingAnimator * _Nonnull animator, float progress) {
        return [UIColor qmui_colorFromColor:UIColorBlack toColor:NavBarTintColor progress:progress];
    };
    self.navigationAnimator.titleViewTintColorBlock = self.navigationAnimator.tintColorBlock;
    self.navigationAnimator.statusbarStyleBlock = ^UIStatusBarStyle(QMUINavigationBarScrollingAnimator * _Nonnull animator, float progress) {
        return progress < .25 ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
    };
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    // 需要手动调用 navigationAnimator.statusbarStyleBlock 来告诉系统状态栏的变化
    if (self.navigationAnimator) {
        return self.navigationAnimator.statusbarStyleBlock(self.navigationAnimator, self.navigationAnimator.progress);
    }
    return [super preferredStatusBarStyle];
}

// 建议配合 QMUINavigationControllerAppearanceDelegate 控制不同界面切换时的 navigationBar 样式，否则需自己在 viewWillAppear:、viewWillDisappear: 里控制

#pragma mark - <QMUINavigationControllerAppearanceDelegate>

- (UIImage *)navigationBarBackgroundImage {
    return self.navigationAnimator.backgroundImageBlock(self.navigationAnimator, self.navigationAnimator.progress);
}

- (UIImage *)navigationBarShadowImage {
    return self.navigationAnimator.shadowImageBlock(self.navigationAnimator, self.navigationAnimator.progress);
}

- (UIColor *)navigationBarTintColor {
    return self.navigationAnimator.tintColorBlock(self.navigationAnimator, self.navigationAnimator.progress);
}

- (UIColor *)titleViewTintColor {
    return [self navigationBarTintColor];
}

#pragma mark - <QMUICustomNavigationBarTransitionDelegate>

// 为了展示接口的使用，QMUI Demo 没有打开配置表的 AutomaticCustomNavigationBarTransitionStyle，因此当 navigationBar 样式与默认样式不同时，需要手动在 customNavigationBarTransitionKey 里返回一个与其他界面不相同的值，这样才能使用自定义的 navigationBar 转场样式
- (NSString *)customNavigationBarTransitionKey {
    return self.navigationAnimator.progress >= 1 ? nil : @"progress";
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
