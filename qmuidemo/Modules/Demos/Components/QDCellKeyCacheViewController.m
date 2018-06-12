//
//  QDCellKeyCacheViewController.m
//  qmuidemo
//
//  Created by MoLice on 2018/3/18.
//  Copyright © 2018年 QMUI Team. All rights reserved.
//

#import "QDCellKeyCacheViewController.h"
#import "QDCellHeightKeyCacheViewController.h"
#import "QDCellSizeKeyCacheViewController.h"

@interface QDCellKeyCacheViewController ()

@end

@implementation QDCellKeyCacheViewController

- (void)initDataSource {
    self.dataSource = @[@"QMUICellHeightKeyCache",
                        @"QMUICellSizeKeyCache(暂不能使用)"];
}

- (void)didSelectCellWithTitle:(NSString *)title {
    UIViewController *viewController = nil;
    if ([title isEqualToString:@"QMUICellHeightKeyCache"]) {
        viewController = [[QDCellHeightKeyCacheViewController alloc] init];
    } else if ([title isEqualToString:@"QMUICellSizeKeyCache(暂不能使用)"]) {
        viewController = [[QDCellSizeKeyCacheViewController alloc] init];
    }
    viewController.title = title;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
