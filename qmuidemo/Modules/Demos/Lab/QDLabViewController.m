//
//  QDLabViewController.m
//  qmui
//
//  Created by QMUI Team on 14/11/5.
//  Copyright (c) 2014年 QMUI Team. All rights reserved.
//

#import "QDLabViewController.h"
#import "QDCommonListViewController.h"
#import "QDAllSystemFontsViewController.h"
#import "QDFontPointSizeAndLineHeightViewController.h"
#import "QDAboutViewController.h"
#import "QDInteractiveDebugViewController.h"
#import "QDAllAnimationViewController.h"
#import "QDCAShapeLoadingViewController.h"
#import "QDReplicatorLayerViewController.h"
#import "QDRippleAnimationViewController.h"
#import "QDNavigationBarSmoothEffectViewController.h"
#import "QDNavigationBottomAccessoryViewController.h"
#import "QDBackBarButtonViewController.h"
#import "QDDropdownNotificationViewController.h"
#import "QDAnimationCurvesViewController.h"

@interface QDLabViewController ()
@end

@implementation QDLabViewController

- (void)initDataSource {
    [super initDataSource];
    self.dataSource = @[@"All System Fonts",
                        @"Default Line Height",
                        @"Animation",
                        @"Log Manager",
                        @"Interactive Debugger",
                        @"UINavigationBar Smooth Effect",
                        @"UINavigationBar Bottom Accessory",
                        @"Custom BackBarButtonItem",
                        @"Dropdown Notification",
                        ];
}

- (void)didSelectCellWithTitle:(NSString *)title {
    __weak __typeof(self)weakSelf = self;
    UIViewController *viewController = nil;
    if ([title isEqualToString:@"All System Fonts"]) {
        viewController = [[QDAllSystemFontsViewController alloc] init];
    } else if ([title isEqualToString:@"Default Line Height"]) {
        viewController = [[QDFontPointSizeAndLineHeightViewController alloc] init];
    } else if ([title isEqualToString:@"Animation"]) {
        viewController = ({
            QDCommonListViewController *vc = QDCommonListViewController.new;
            vc.dataSource = @[
                @"Animation Curves",
                @"Loading",
                @"Loading With CAShapeLayer",
                @"Animation For CAReplicatorLayer",
                @"水波纹"
            ];
            vc.didSelectTitleBlock = ^(NSString *title) {
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
                else if ([title isEqualToString:@"Animation Curves"]) {
                    viewController = [[QDAnimationCurvesViewController alloc] init];
                }
                viewController.title = title;
                [weakSelf.navigationController pushViewController:viewController animated:YES];
            };
            vc;
        });
    } else if ([title isEqualToString:@"Log Manager"]) {
        viewController = [[QMUILogManagerViewController alloc] init];
        ((QMUILogManagerViewController *)viewController).formatLogNameForSortingBlock = ^NSString *(NSString *logName) {
            NSString *projectPrefix = @"QMUI";
            if ([logName hasPrefix:projectPrefix]) {
                return [logName substringFromIndex:projectPrefix.length];
            }
            return logName;
        };
    } else if ([title isEqualToString:@"Interactive Debugger"]) {
        viewController = [[QDInteractiveDebugViewController alloc] init];
    } else if ([title isEqualToString:@"UINavigationBar Smooth Effect"]) {
        viewController = [[QDNavigationBarSmoothEffectViewController alloc] init];
    } else if ([title isEqualToString:@"UINavigationBar Bottom Accessory"]) {
        viewController = [[QDNavigationBottomAccessoryViewController alloc] init];
    } else if ([title isEqualToString:@"Custom BackBarButtonItem"]) {
        viewController = [[QDBackBarButtonViewController alloc] init];
    } else if ([title isEqualToString:@"Dropdown Notification"]) {
        viewController = [[QDDropdownNotificationViewController alloc] init];
    }
    viewController.title = title;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.title = @"Lab";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem qmui_itemWithImage:UIImageMake(@"icon_nav_about") target:self action:@selector(handleAboutItemEvent)];
    AddAccessibilityLabel(self.navigationItem.rightBarButtonItem, @"打开关于界面");
}

- (void)handleAboutItemEvent {
    QDAboutViewController *viewController = [[QDAboutViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
