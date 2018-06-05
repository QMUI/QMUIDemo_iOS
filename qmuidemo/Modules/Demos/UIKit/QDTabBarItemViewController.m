//
//  QDTabBarItemViewController.m
//  qmuidemo
//
//  Created by MoLice on 2016/10/9.
//  Copyright © 2016年 QMUI Team. All rights reserved.
//

#import "QDTabBarItemViewController.h"

@interface QDTabBarItemViewController ()

@property(nonatomic, strong) UITabBar *tabBar;
@end

@implementation QDTabBarItemViewController

- (void)initSubviews {
    [super initSubviews];
    
    // 双击 tabBarItem 的回调
    __weak __typeof(self)weakSelf = self;
    void (^tabBarItemDoubleTapBlock)(UITabBarItem *tabBarItem, NSInteger index) = ^(UITabBarItem *tabBarItem, NSInteger index) {
        [QMUITips showInfo:[NSString stringWithFormat:@"双击了第 %@ 个 tab", @(index + 1)] inView:weakSelf.view hideAfterDelay:1.2];
    };
    
    self.tabBar = [[UITabBar alloc] init];
    self.tabBar.tintColor = TabBarTintColor;
    
    UITabBarItem *item1 = [QDUIHelper tabBarItemWithTitle:@"QMUIKit" image:[UIImageMake(@"icon_tabbar_uikit") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:UIImageMake(@"icon_tabbar_uikit_selected") tag:0];
    item1.qmui_doubleTapBlock = tabBarItemDoubleTapBlock;
    
    UITabBarItem *item2 = [QDUIHelper tabBarItemWithTitle:@"Components" image:[UIImageMake(@"icon_tabbar_component") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:UIImageMake(@"icon_tabbar_component_selected") tag:1];
    item2.qmui_doubleTapBlock = tabBarItemDoubleTapBlock;
    
    UITabBarItem *item3 = [QDUIHelper tabBarItemWithTitle:@"Lab" image:[UIImageMake(@"icon_tabbar_lab") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:UIImageMake(@"icon_tabbar_lab_selected") tag:2];
    item3.qmui_doubleTapBlock = tabBarItemDoubleTapBlock;
    
    self.tabBar.items = @[item1, item2, item3];
    self.tabBar.selectedItem = item1;
    [self.tabBar sizeToFit];
    [self.view addSubview:self.tabBar];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat tabBarHeight = TabBarHeight;
    self.tabBar.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - tabBarHeight, CGRectGetWidth(self.view.bounds), tabBarHeight);
}

- (void)initDataSource {
    self.dataSource = @[@"双击 UITabBarItem 可触发双击事件",
                        @"可获取 UITabBarItem 上的 imageView"];
}

- (void)didSelectCellWithTitle:(NSString *)title {
    
    if ([title isEqualToString:@"可获取 UITabBarItem 上的 imageView"]) {
        // 注意只有在 UITabBar 可见的时候才能获取到这个 view，如果一初始化 UITabBarItem 就立马获取，是获取不到的。
        UIImageView *imageViewInTabBarItem = self.tabBar.items.firstObject.qmui_imageView;
        if (imageViewInTabBarItem) {
            [UIView animateWithDuration:.25 delay:0 usingSpringWithDamping:.1 initialSpringVelocity:5 options:QMUIViewAnimationOptionsCurveOut animations:^{
                imageViewInTabBarItem.transform = CGAffineTransformMakeScale(1.4, 1.4);
            } completion:^(BOOL finished) {
                imageViewInTabBarItem.transform = CGAffineTransformIdentity;
            }];
        }
    }
    
    [self.tableView qmui_clearsSelection];
}

@end
