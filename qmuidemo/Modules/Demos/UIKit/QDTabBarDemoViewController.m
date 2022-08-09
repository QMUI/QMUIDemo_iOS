//
//  QDTabBarDemoViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 2016/10/9.
//  Copyright © 2016年 QMUI Team. All rights reserved.
//

#import "QDTabBarDemoViewController.h"

@interface QDTabBarDemoViewController ()

@property(nonatomic, strong) UITabBar *tabBar;
@property(nonatomic, strong) UIView *blurTestView;
@property(nonatomic, strong) UIView *blurTestView2;
@end

@implementation QDTabBarDemoViewController

- (void)initSubviews {
    [super initSubviews];
    
    // 双击 tabBarItem 的回调
    __weak __typeof(self)weakSelf = self;
    void (^tabBarItemDoubleTapBlock)(UITabBarItem *tabBarItem, NSInteger index) = ^(UITabBarItem *tabBarItem, NSInteger index) {
        [QMUITips showInfo:[NSString stringWithFormat:@"双击了第 %@ 个 tab", @(index + 1)] inView:weakSelf.view hideAfterDelay:1.2];
    };
    
    self.tabBar = [[UITabBar alloc] init];
    
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
    if (self.blurTestView) {
        CGRect rect = [self.tableView convertRect:self.tabBar.frame fromView:self.view];
        self.blurTestView.frame = CGRectMake(100, CGRectGetMinY(rect) - 25, CGRectGetWidth(self.tableView.bounds) - 100 * 2, 25 * 2);
    }
    if (self.blurTestView2) {
        self.blurTestView2.frame = CGRectMake(100, - 25, CGRectGetWidth(self.tableView.bounds) - 100 * 2, 25 * 2);
    }
}

- (void)initDataSource {
    self.dataSourceWithDetailText = [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                                     @"双击 UITabBarItem 可触发双击事件", @"",
                                     @"可获取 UITabBarItem 上的 imageView", @"例如这里拿到 imageView 后会做动画",
                                     @"可精准指定 UITabBar 的磨砂和前景色", @"兼容所有 iOS 版本。而系统仅在 iOS 13 及以后才提供 backgroundEffect 的修改方式，且系统的 UIVisualEffectView 在展示一些 UIBlurEffectStyle 时会强制加一个前景色，导致业务再叠加的前景色效果不可控，因此 QMUI 提供接口可以屏蔽系统的前景色，只显示业务的，从而达到精准控制设计效果的作用。",
                                     nil];
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
    } else if ([title isEqualToString:@"可精准指定 UITabBar 的磨砂和前景色"]) {
        
        // backgroundImage 优先级比 backgroundEffect 高，所以这里主动把 backgroundImage 清理掉
        self.tabBar.backgroundImage = nil;
        self.tabBar.barTintColor = nil;
        
        NSArray<NSNumber *> *effectStyles = @[
            @(UIBlurEffectStyleExtraLight),
            @(UIBlurEffectStyleLight),
            @(UIBlurEffectStyleDark),
            @(UIBlurEffectStyleProminent),
        ];
        if (@available(iOS 13.0, *)) {
            effectStyles = [effectStyles arrayByAddingObjectsFromArray:@[
                @(UIBlurEffectStyleSystemUltraThinMaterialLight),
                @(UIBlurEffectStyleSystemMaterialLight),
                @(UIBlurEffectStyleSystemChromeMaterialLight),
                @(UIBlurEffectStyleSystemUltraThinMaterialDark),
                @(UIBlurEffectStyleSystemMaterialDark),
                @(UIBlurEffectStyleSystemChromeMaterialDark),
            ]];
        }

        UIBlurEffectStyle style = effectStyles[arc4random() % effectStyles.count].integerValue;
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:style];
        self.tabBar.qmui_effect = effect;
        self.tabBar.qmui_effectForegroundColor = [UIColor.qd_tintColor colorWithAlphaComponent:.3];
        
        // 为了展示磨砂效果，tabBar 背后垫一个 view 来查看透过磨砂的样子
        if (!self.blurTestView) {
            self.blurTestView = UIView.new;
            self.blurTestView.backgroundColor = UIColor.qd_tintColor;
            [self.tableView addSubview:self.blurTestView];
            [self.view setNeedsLayout];
        }
        
        UINavigationBar *navigationBar = self.navigationController.navigationBar;
        [navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        navigationBar.barTintColor = nil;
        [navigationBar setNeedsLayout];
        [navigationBar layoutIfNeeded];
        navigationBar.qmui_effect = effect;
        navigationBar.qmui_effectForegroundColor = [UIColor.qd_tintColor colorWithAlphaComponent:.3];
        
        // 为了展示磨砂效果，tabBar 背后垫一个 view 来查看透过磨砂的样子
        if (!self.blurTestView2) {
            self.blurTestView2 = UIView.new;
            self.blurTestView2.backgroundColor = UIColor.qd_tintColor;
            [self.tableView addSubview:self.blurTestView2];
            [self.view setNeedsLayout];
        }
    }
    
    [self.tableView qmui_clearsSelection];
}

@end
