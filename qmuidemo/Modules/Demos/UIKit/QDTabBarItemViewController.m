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
    self.dataSource = @[@"在屏幕底部的 UITabBarItem 上显示未读数",
                        @"去掉屏幕底部 UITabBarItem 上的未读数",
                        @"双击 UITabBarItem 可触发双击事件"];
}

- (void)didSelectCellWithTitle:(NSString *)title {
    
    // 利用 [UITabBarItem imageView] 方法获取到某个 UITabBarItem 内的图片容器
    UIImageView *imageViewInTabBarItem = self.tabBar.items.firstObject.qmui_imageView;
    
    if ([title isEqualToString:@"在屏幕底部的 UITabBarItem 上显示未读数"]) {
        
        QMUILabel *messageNumberLabel = [self generateMessageNumberLabelWithInteger:8 inView:imageViewInTabBarItem];
        messageNumberLabel.frame = CGRectSetXY(messageNumberLabel.frame, CGRectGetWidth(imageViewInTabBarItem.frame) - 8, -5);
        messageNumberLabel.hidden = NO;
        
    } else if ([title isEqualToString:@"去掉屏幕底部 UITabBarItem 上的未读数"]) {
        
        QMUILabel *messageNumberLabel = [self messageNumberLabelInView:imageViewInTabBarItem];
        messageNumberLabel.hidden = YES;
        
    }
    
    [self.tableView qmui_clearsSelection];
}

- (QMUILabel *)generateMessageNumberLabelWithInteger:(NSInteger)integer inView:(UIView *)view {
    NSInteger labelTag = 1024;
    QMUILabel *numberLabel = [view viewWithTag:labelTag];
    if (!numberLabel) {
        numberLabel = [[QMUILabel alloc] qmui_initWithFont:UIFontBoldMake(14) textColor:UIColorWhite];
        numberLabel.backgroundColor = UIColorRed;
        numberLabel.textAlignment = NSTextAlignmentCenter;
        numberLabel.contentEdgeInsets = UIEdgeInsetsMake(2, 5, 2, 5);
        numberLabel.clipsToBounds = YES;
        numberLabel.tag = labelTag;
        [view addSubview:numberLabel];
    }
    numberLabel.text = [NSString qmui_stringWithNSInteger:integer];
    [numberLabel sizeToFit];
    if (numberLabel.text.length == 1) {
        // 一位数字时，保证宽高相等（因为有些字符可能宽度比较窄）
        CGFloat diameter = fmax(CGRectGetWidth(numberLabel.bounds), CGRectGetHeight(numberLabel.bounds));
        numberLabel.frame = CGRectMake(CGRectGetMinX(numberLabel.frame), CGRectGetMinY(numberLabel.frame), diameter, diameter);
    }
    numberLabel.layer.cornerRadius = flat(CGRectGetHeight(numberLabel.bounds) / 2.0);
    return numberLabel;
}

- (QMUILabel *)messageNumberLabelInView:(UIView *)view {
    NSInteger labelTag = 1024;
    QMUILabel *numberLabel = [view viewWithTag:labelTag];
    return numberLabel;
}

@end
