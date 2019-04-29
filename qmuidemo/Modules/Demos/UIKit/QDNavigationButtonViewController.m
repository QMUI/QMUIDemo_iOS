//
//  QDNavigationButtonViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 2018/04/17.
//  Copyright © 2018年 QMUI Team. All rights reserved.
//

#import "QDNavigationButtonViewController.h"

NSString *const kSectionTitleForNormalButton = @"文本按钮";
NSString *const kSectionTitleForBoldButton = @"加粗文本按钮";
NSString *const kSectionTitleForImageButton = @"图片按钮";
NSString *const kSectionTitleForBackButton = @"返回按钮";
NSString *const kSectionTitleForCloseButton = @"关闭按钮";

@interface QDNavigationButtonViewController ()

@property(nonatomic, assign) BOOL forceEnableBackGesture;
@end

@implementation QDNavigationButtonViewController

- (void)initDataSource {
    self.dataSource = [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                       kSectionTitleForNormalButton, [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                                                      @"[系统]文本按钮", @"",
                                                      @"[QMUI]文本按钮", @"",
                                                      nil],
                       kSectionTitleForBoldButton, [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                                                    @"[系统]加粗文本按钮", @"",
                                                    @"[QMUI]加粗文本按钮", @"",
                                                    nil],
                       kSectionTitleForImageButton, [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                                                     @"[系统]图片按钮", @"",
                                                     @"[QMUI]图片按钮", @"",
                                                     nil],
                       kSectionTitleForBackButton, [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                                                    @"[系统]返回按钮", @"",
                                                    @"[QMUI]返回按钮", @"",
                                                    nil],
                       kSectionTitleForCloseButton, [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                                                     @"[QMUI]关闭按钮", @"在 present 的场景经常使用这种关闭按钮",
                                                     nil],
                       nil];
}

// 可通过切换“系统”和“QMUI”，看 QMUI 的自定义按钮布局是否与系统的不一致，产生跳动
// 能用系统的尽量用系统的，QMUINavigationButton 只在必要的时候才使用
- (void)didSelectCellWithTitle:(NSString *)title {
    if ([title isEqualToString:@"[系统]文本按钮"]) {
        UIBarButtonItem *item = [UIBarButtonItem qmui_itemWithTitle:@"文字" target:nil action:NULL];
        self.navigationItem.rightBarButtonItems = @[item];
    } else if ([title isEqualToString:@"[QMUI]文本按钮"]) {
        UIBarButtonItem *item = [UIBarButtonItem qmui_itemWithButton:[[QMUINavigationButton alloc] initWithType:QMUINavigationButtonTypeNormal title:@"文字"] target:nil action:NULL];
        self.navigationItem.rightBarButtonItems = @[item];
    } else if ([title isEqualToString:@"[系统]加粗文本按钮"]) {
        UIBarButtonItem *item = [UIBarButtonItem qmui_itemWithBoldTitle:@"加粗" target:nil action:NULL];
        self.navigationItem.rightBarButtonItems = @[item];
    } else if ([title isEqualToString:@"[QMUI]加粗文本按钮"]) {
        UIBarButtonItem *item = [UIBarButtonItem qmui_itemWithButton:[[QMUINavigationButton alloc] initWithType:QMUINavigationButtonTypeBold title:@"加粗"] target:nil action:NULL];
        self.navigationItem.rightBarButtonItems = @[item];
    } else if ([title isEqualToString:@"[系统]图片按钮"]) {
        self.navigationItem.rightBarButtonItems = @[[UIBarButtonItem qmui_itemWithImage:UIImageMake(@"icon_nav_about") target:nil action:NULL],
                                                    [UIBarButtonItem qmui_itemWithImage:UIImageMake(@"icon_nav_about") target:nil action:NULL]];
    } else if ([title isEqualToString:@"[QMUI]图片按钮"]) {
        self.navigationItem.rightBarButtonItems = @[[UIBarButtonItem qmui_itemWithButton:[[QMUINavigationButton alloc] initWithImage:UIImageMake(@"icon_nav_about")] target:nil action:NULL],
                                                    [UIBarButtonItem qmui_itemWithButton:[[QMUINavigationButton alloc] initWithImage:UIImageMake(@"icon_nav_about")] target:nil action:NULL]];
    } else if ([title isEqualToString:@"[系统]返回按钮"]) {
        self.navigationItem.leftBarButtonItem = nil;// 只要不设置 leftBarButtonItem，就会显示系统的返回按钮
        self.navigationItem.rightBarButtonItems = nil;
    } else if ([title isEqualToString:@"[QMUI]返回按钮"]) {
        UIBarButtonItem *item = [UIBarButtonItem qmui_backItemWithTarget:self action:@selector(handleBackButtonEvent:)];// 自定义返回按钮要自己写代码去 pop 界面
        self.navigationItem.leftBarButtonItem = item;
        self.forceEnableBackGesture = YES;// 当系统的返回按钮被屏蔽的时候，系统的手势返回也会跟着失效，所以这里要手动强制打开手势返回
        self.navigationItem.rightBarButtonItems = nil;
    } else if ([title isEqualToString:@"[QMUI]关闭按钮"]) {
        UIBarButtonItem *item = [UIBarButtonItem qmui_closeItemWithTarget:self action:@selector(handleCloseButtonEvent:)];
        self.navigationItem.leftBarButtonItem = item;
        self.forceEnableBackGesture = YES;
        self.navigationItem.rightBarButtonItems = nil;
    }
    [self.tableView qmui_clearsSelection];
}

- (void)handleCloseButtonEvent:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleBackButtonEvent:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)forceEnableInteractivePopGestureRecognizer {
    return self.forceEnableBackGesture;
}

@end
