//
//  QDChangeNavBarStyleViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 16/9/5.
//  Copyright © 2016年 QMUI Team. All rights reserved.
//

#import "QDChangeNavBarStyleViewController.h"

@interface QDChangeNavBarStyleViewController ()

@property(nonatomic, assign) QDNavigationBarStyle barStyle;

@end

@implementation QDChangeNavBarStyleViewController

- (instancetype)initWithBarStyle:(QDNavigationBarStyle)barStyle {
    if (self = [super init]) {
        self.barStyle = barStyle;
    }
    return self;
}

- (void)initDataSource {
    [super initDataSource];
    self.dataSource = @[@"默认",
                        @"深色",
                        @"浅色（磨砂）"];
}

- (void)didSelectCellWithTitle:(NSString *)title {
    UIViewController *viewController = nil;
    if ([title isEqualToString:@"默认"]) {
        viewController = [[QDChangeNavBarStyleViewController alloc] initWithBarStyle:QDNavigationBarStyleOrigin];
    }
    else if ([title isEqualToString:@"深色"]) {
        viewController = [[QDChangeNavBarStyleViewController alloc] initWithBarStyle:QDNavigationBarStyleDark];
    }
    else if ([title isEqualToString:@"浅色（磨砂）"]) {
        viewController = [[QDChangeNavBarStyleViewController alloc] initWithBarStyle:QDNavigationBarStyleLight];
    }
    viewController.title = title;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.barStyle == QDNavigationBarStyleOrigin || self.barStyle == QDNavigationBarStyleDark) {
        return UIStatusBarStyleLightContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}

#pragma mark - QMUINavigationControllerDelegate

- (UIImage *)qmui_navigationBarBackgroundImage {
    if (self.barStyle == QDNavigationBarStyleOrigin) {
        return NavBarBackgroundImage;
    } else if (self.barStyle == QDNavigationBarStyleLight) {
        return nil; // nil则用系统默认颜色（带磨砂）
    } else if (self.barStyle == QDNavigationBarStyleDark) {
        return [UIImage qmui_imageWithColor:UIColorMake(66, 66, 66)];
    } else {
        return NavBarBackgroundImage;
    }
}

- (UIImage *)qmui_navigationBarShadowImage {
    if (self.barStyle == QDNavigationBarStyleLight) {
        return nil; // nil则用系统默认颜色
    }
    return NavBarShadowImage;
}

- (UIColor *)qmui_navigationBarTintColor {
    if (self.barStyle == QDNavigationBarStyleOrigin) {
        return NavBarTintColor;
    } else if (self.barStyle == QDNavigationBarStyleLight) {
        return UIColorBlack;
    } else if (self.barStyle == QDNavigationBarStyleDark) {
        return UIColorWhite;
    } else {
        return NavBarTintColor;
    }
}

- (UIColor *)qmui_titleViewTintColor {
    return [self qmui_navigationBarTintColor];
}

#pragma mark - <QMUICustomNavigationBarTransitionDelegate>

- (NSString *)customNavigationBarTransitionKey {
    // 不同的 barStyle 返回不同的 key，这样在不同 barStyle 的界面之间切换时就能使用自定义的 navigationBar 样式，会带来更好的视觉体验
    // 返回 nil 则表示当前界面没有修改过导航栏样式
    // 注意，如果你使用配置表，建议打开 AutomaticCustomNavigationBarTransitionStyle，由 QMUI 自动帮你判断是否需要使用自定义样式，这样就无需再实现 customNavigationBarTransitionKey 方法。QMUI Demo 里为了展示接口的使用，没有打开这个开关。
    return self.barStyle == QDNavigationBarStyleOrigin ? nil : [NSString qmui_stringWithNSInteger:self.barStyle];
}

@end
