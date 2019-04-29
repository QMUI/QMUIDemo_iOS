//
//  QDScrollAnimatorViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 2018/O/8.
//  Copyright © 2018 QMUI Team. All rights reserved.
//

#import "QDScrollAnimatorViewController.h"
#import "QDNavigationBarScrollingAnimatorViewController.h"
#import "QDNavigationBarScrollingSnapAnimatorViewController.h"

@implementation QDScrollAnimatorViewController

- (void)initDataSource {
    self.dataSource = @[NSStringFromClass([QMUINavigationBarScrollingAnimator class]),
                        NSStringFromClass([QMUINavigationBarScrollingSnapAnimator class])];
}

- (void)didSelectCellWithTitle:(NSString *)title {
    UIViewController *viewController = nil;
    if ([title isEqualToString:NSStringFromClass([QMUINavigationBarScrollingAnimator class])]) {
        viewController = [[QDNavigationBarScrollingAnimatorViewController alloc] init];
    } else if ([title isEqualToString:NSStringFromClass([QMUINavigationBarScrollingSnapAnimator class])]) {
        viewController = [[QDNavigationBarScrollingSnapAnimatorViewController alloc] init];
    }
    viewController.title = title;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
