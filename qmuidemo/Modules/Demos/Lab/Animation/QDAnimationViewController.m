//
//  QDAnimationViewController.m
//  qmui
//
//  Created by QMUI Team on 14-9-23.
//  Copyright (c) 2014年 QMUI Team. All rights reserved.
//

#import "QDAnimationViewController.h"
#import "QDAllAnimationViewController.h"
#import "QDCAShapeLoadingViewController.h"
#import "QDReplicatorLayerViewController.h"
#import "QDRippleAnimationViewController.h"

@implementation QDAnimationViewController

- (void)initDataSource {
    [super initDataSource];
    self.dataSource = @[@"Loading",
                        @"Loading With CAShapeLayer",
                        @"Animation For CAReplicatorLayer",
                        @"水波纹"];
}

- (void)didSelectCellWithTitle:(NSString *)title {
    UIViewController *viewController = nil;
    if ([title isEqualToString:@"Loading"]) {
        viewController = [[QDAllAnimationViewController alloc] init];
    }
    else if ([title isEqualToString:@"Loading With CAShapeLayer"]) {
        viewController = [[QDCAShapeLoadingViewController alloc] init];
    }
    else if ([title isEqualToString:@"Animation For CAReplicatorLayer"]) {
        viewController = [[QDReplicatorLayerViewController alloc] init];
    }
    else if ([title isEqualToString:@"水波纹"]) {
        viewController = [[QDRippleAnimationViewController alloc] init];
    }
    viewController.title = title;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
