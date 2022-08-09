//
//  QDCommonViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 15/4/13.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QDCommonViewController.h"

@implementation QDCommonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IsUITest) {
        self.view.accessibilityLabel = [NSString stringWithFormat:@"viewController-%@", self.title];
    }
}

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    if (IsUITest && self.isViewLoaded) {
        self.view.accessibilityLabel = [NSString stringWithFormat:@"viewController-%@", self.title];
    }
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    if (self.qmui_isPresented) {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem qmui_closeItemWithTarget:self action:@selector(handleCloseItem)];
    }
}

- (void)handleCloseItem {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)shouldCustomizeNavigationBarTransitionIfHideable {
    return YES;
}

@end
