//
//  QDChangeNavBarStyleViewController.m
//  qmuidemo
//
//  Created by zhoonchen on 16/9/5.
//  Copyright © 2016年 QMUI Team. All rights reserved.
//

#import "QDChangeNavBarStyleViewController.h"

@interface QDChangeNavBarStyleViewController ()

@property(nonatomic, assign) QDNavigationBarStyle barStyle;
@property(nonatomic, strong) QDChangeNavBarStyleViewController *viewController;

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
    self.dataSource = @[@"默认navBar样式",
                        @"暗色navBar样式",
                        @"浅色navBar样式"];
}

- (void)didSelectCellWithTitle:(NSString *)title {
    if ([title isEqualToString:@"默认navBar样式"]) {
        self.viewController = [[QDChangeNavBarStyleViewController alloc] initWithBarStyle:QDNavigationBarStyleOrigin];
    }
    else if ([title isEqualToString:@"暗色navBar样式"]) {
        self.viewController = [[QDChangeNavBarStyleViewController alloc] initWithBarStyle:QDNavigationBarStyleDark];
    }
    else if ([title isEqualToString:@"浅色navBar样式"]) {
        self.viewController = [[QDChangeNavBarStyleViewController alloc] initWithBarStyle:QDNavigationBarStyleLight];
    }
    if (self.customNavBarTransition) {
        self.viewController.previousBarStyle = self.barStyle;
        self.viewController.customNavBarTransition = YES;
    }
    self.viewController.title = title;
    [self.navigationController pushViewController:self.viewController animated:YES];
}

#pragma mark - QMUINavigationControllerDelegate

- (BOOL)shouldSetStatusBarStyleLight {
    if (self.barStyle == QDNavigationBarStyleOrigin || self.barStyle == QDNavigationBarStyleDark) {
        return YES;
    } else {
        return NO;
    }
}

- (UIImage *)navigationBarBackgroundImage {
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

- (UIImage *)navigationBarShadowImage {
    if (self.barStyle == QDNavigationBarStyleOrigin) {
        return NavBarShadowImage;
    } else if (self.barStyle == QDNavigationBarStyleLight) {
        return nil; // nil则用系统默认颜色
    } else if (self.barStyle == QDNavigationBarStyleDark) {
        return [UIImage qmui_imageWithColor:UIColorMake(99, 99, 99) size:CGSizeMake(10, PixelOne) cornerRadius:0];
    } else {
        return NavBarShadowImage;
    }
}

- (UIColor *)navigationBarTintColor {
    if (self.barStyle == QDNavigationBarStyleOrigin) {
        return NavBarTintColor;
    } else if (self.barStyle == QDNavigationBarStyleLight) {
        return UIColorBlue;
    } else if (self.barStyle == QDNavigationBarStyleDark) {
        return NavBarTintColor;
    } else {
        return NavBarTintColor;
    }
}

- (UIColor *)titleViewTintColor {
    if (self.barStyle == QDNavigationBarStyleOrigin) {
        return [QMUINavigationTitleView appearance].tintColor;
    } else if (self.barStyle == QDNavigationBarStyleLight) {
        return UIColorBlack;
    } else if (self.barStyle == QDNavigationBarStyleDark) {
        return [QMUINavigationTitleView appearance].tintColor;
    } else {
        return [QMUINavigationTitleView appearance].tintColor;
    }
}

#pragma mark - NavigationBarTransition

//- (BOOL)shouldCustomNavigationBarTransitionWhenPushAppearing {
//    return self.customNavBarTransition;
//}

- (BOOL)shouldCustomNavigationBarTransitionWhenPushDisappearing {
    return self.customNavBarTransition && (self.barStyle != self.viewController.barStyle);
}

//- (BOOL)shouldCustomNavigationBarTransitionWhenPopAppearing {
//    return self.customNavBarTransition;
//}

- (BOOL)shouldCustomNavigationBarTransitionWhenPopDisappearing {
    return self.customNavBarTransition && (self.barStyle != self.previousBarStyle);
}

@end
