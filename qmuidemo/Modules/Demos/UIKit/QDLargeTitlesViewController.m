//
//  QDLargeTitlesViewController.m
//  qmuidemo
//
//  Created by ziezheng on 2019/7/11.
//  Copyright © 2019 QMUI Team. All rights reserved.
//

#import "QDLargeTitlesViewController.h"

@interface QDLargeTitlesViewController ()

@end

@implementation QDLargeTitlesViewController

- (void)initSubviews {
    [super initSubviews];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, APPLICATION_HEIGHT)];
}

- (void)initDataSource {
    [super initDataSource];
    self.dataSourceWithDetailText = [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                                     @"push 一个不显示大标题的 vc", @"LargeTitleDisplayModeNever",
                                     @"push 一个显示大标题的 vc", @"LargeTitleDisplayModeAlways",
                                     @"push 一个跟随上页设置的 vc", @"LargeTitleDisplayModeAutomatic",
                                     @"滚动试试", @"这是一个可以滚动的页面",
                                     nil];
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.title = @"LargeTitle";
    self.navigationController.navigationBar.prefersLargeTitles = YES;
}

- (void)didSelectCellWithTitle:(NSString *)title {
    if ([title isEqualToString:@"滚动试试"]) {
        CGPoint contentOffsetWhenLargeTitleDisplaying = CGPointMake(0, -(NavigationContentTop + 52));
        if (CGPointEqualToPoint(self.tableView.contentOffset, contentOffsetWhenLargeTitleDisplaying)) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        } else {
            [self.tableView setContentOffset:contentOffsetWhenLargeTitleDisplaying animated:YES];
        }
        [self.tableView qmui_clearsSelection];
    } else {
        QDLargeTitlesViewController *largeTitlesViewController = [[QDLargeTitlesViewController alloc] init];
        
        UINavigationItemLargeTitleDisplayMode displayMode;
        if ([title isEqualToString:@"push 一个不显示大标题的 vc"]) {
            displayMode = UINavigationItemLargeTitleDisplayModeNever;
        } else if ([title isEqualToString:@"push 一个显示大标题的 vc"]) {
            displayMode = UINavigationItemLargeTitleDisplayModeAlways;
        } else {
            displayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
        }
        
        largeTitlesViewController.navigationItem.largeTitleDisplayMode = displayMode;
        [self.navigationController pushViewController:largeTitlesViewController animated:YES];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    // 上个界面如果不是 QDLargeTitlesViewController 就还原 prefersLargeTitles，以免影响其他界面
    UIViewController *currentViewController = UIApplication.sharedApplication.keyWindow.rootViewController.qmui_visibleViewControllerIfExist;
    if ([currentViewController class] != [QDLargeTitlesViewController class]) {
        currentViewController.navigationController.navigationBar.prefersLargeTitles = NO;
    }
}

@end
