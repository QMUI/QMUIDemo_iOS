//
//  QDImagePreviewExampleViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 2016/12/6.
//  Copyright © 2016年 QMUI Team. All rights reserved.
//

#import "QDImagePreviewExampleViewController.h"
#import "QDImagePreviewViewController1.h"
#import "QDImagePreviewViewController2.h"

@implementation QDImagePreviewExampleViewController

- (void)initDataSource {
    self.dataSource = @[NSStringFromClass([QMUIImagePreviewView class]),
                        NSStringFromClass([QMUIImagePreviewViewController class])];
}

- (void)didSelectCellWithTitle:(NSString *)title {
    UIViewController *viewController = nil;
    if ([title isEqualToString:NSStringFromClass([QMUIImagePreviewView class])]) {
        viewController = [[QDImagePreviewViewController1 alloc] init];
    } else if ([title isEqualToString:NSStringFromClass([QMUIImagePreviewViewController class])]) {
        viewController = [[QDImagePreviewViewController2 alloc] init];
        viewController.title = title;
    }
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
