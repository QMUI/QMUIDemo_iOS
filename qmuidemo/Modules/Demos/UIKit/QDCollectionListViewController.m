//
//  QDCollectionListViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 15/9/24.
//  Copyright © 2015年 QMUI Team. All rights reserved.
//

#import "QDCollectionListViewController.h"
#import "QDCollectionDemoViewController.h"
#import "QDCollectionStackDemoViewController.h"

@interface QDCollectionListViewController ()

@end

@implementation QDCollectionListViewController

- (void)initDataSource {
    [super initDataSource];
    self.dataSource = @[@"默认",
                        @"缩放",
                        @"旋转"];
}

- (void)didSelectCellWithTitle:(NSString *)title {
    UIViewController *viewController = nil;
    if ([title isEqualToString:@"默认"]) {
        viewController = [[QDCollectionDemoViewController alloc] init];
        ((QDCollectionDemoViewController *)viewController).collectionViewLayout.minimumLineSpacing = 20;
    }
    if ([title isEqualToString:@"缩放"]) {
        viewController = [[QDCollectionDemoViewController alloc] initWithLayoutStyle:QMUICollectionViewPagingLayoutStyleScale];
        ((QDCollectionDemoViewController *)viewController).collectionViewLayout.minimumLineSpacing = 0;
    }
    else if ([title isEqualToString:@"旋转"]) {
        viewController = [[QDCollectionDemoViewController alloc] initWithLayoutStyle:QMUICollectionViewPagingLayoutStyleRotation];
        ((QDCollectionDemoViewController *)viewController).collectionViewLayout.minimumLineSpacing = 20;
    }
    // TODO
//    else if ([title isEqualToString:@"叠加"]) {
//        viewController = [[QDCollectionStackDemoViewController alloc] init];
//    }
    viewController.title = title;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
