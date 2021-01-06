//
//  QDUIKitViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 15/6/2.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QDUIKitViewController.h"
#import "QDNavigationController.h"
#import "QDCommonListViewController.h"
#import "QDColorViewController.h"
#import "QDImageViewController.h"
#import "QDLabelViewController.h"
#import "QDTextViewController.h"
#import "QDTextFieldViewController.h"
#import "QDButtonViewController.h"
#import "QDAlertController.h"
#import "QDSearchViewController.h"
#import "QDNavigationListViewController.h"
#import "QDTabBarItemViewController.h"
#import "QDAboutViewController.h"
#import "QDObjectViewController.h"
#import "QDFontViewController.h"
#import "QDSliderViewController.h"
#import "QDOrientationViewController.h"
#import "QDCAAnimationViewController.h"
#import "QDImageViewViewController.h"
#import "QDTableViewHeaderFooterViewController.h"
#import "QDInsetGroupedTableViewController.h"
#import "QDUIViewBorderViewController.h"
#import "QDUIViewDebugViewController.h"
#import "QDUIViewLayoutViewController.h"
#import "QDSearchBarViewController.h"
#import "QDTableViewCellInsetsViewController.h"
#import "QDTableViewCellAccessoryTypeViewController.h"
#import "QDTableViewCellSeparatorInsetsViewController.h"
#import "QDControlViewController.h"

@implementation QDUIKitViewController

- (void)initDataSource {
    self.dataSource = [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                       @"QMUIButton", UIImageMake(@"icon_grid_button"),
                       @"QMUILabel", UIImageMake(@"icon_grid_label"),
                       @"QMUITextView", UIImageMake(@"icon_grid_textView"),
                       @"QMUITextField", UIImageMake(@"icon_grid_textField"),
                       @"QMUISlider", UIImageMake(@"icon_grid_slider"),
                       @"QMUIAlertController", UIImageMake(@"icon_grid_alert"),
                       @"QMUITableView", UIImageMake(@"icon_grid_cell"),
                       @"ViewController Orientation", UIImageMake(@"icon_grid_orientation"),
                       @"QMUINavigationController", UIImageMake(@"icon_grid_navigation"),
                       @"UISearchBar+QMUI", UIImageMake(@"icon_grid_search"),
                       @"UITabBarItem+QMUI", UIImageMake(@"icon_grid_tabBarItem"),
                       @"UIColor+QMUI", UIImageMake(@"icon_grid_color"),
                       @"UIImage+QMUI", UIImageMake(@"icon_grid_image"),
                       @"UIImageView+QMUI", UIImageMake(@"icon_grid_imageView"),
                       @"UIFont+QMUI", UIImageMake(@"icon_grid_font"),
                       @"UIControl+QMUI", UIImageMake(@"icon_grid_control"),
                       @"UIView+QMUI", UIImageMake(@"icon_grid_view"),
                       @"NSObject+QMUI", UIImageMake(@"icon_grid_nsobject"),
                       @"CAAnimation+QMUI", UIImageMake(@"icon_grid_caanimation"),
                       nil];
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.title = @"QMUIKit";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem qmui_itemWithImage:UIImageMake(@"icon_nav_about") target:self action:@selector(handleAboutItemEvent)];
    AddAccessibilityLabel(self.navigationItem.rightBarButtonItem, @"打开关于界面");
}

- (void)didSelectCellWithTitle:(NSString *)title {
    UIViewController *viewController = nil;
    if ([title isEqualToString:@"UIColor+QMUI"]) {
        viewController = [[QDColorViewController alloc] init];
    }
    else if ([title isEqualToString:@"UIImage+QMUI"]) {
        viewController = [[QDImageViewController alloc] init];
    }
    else if ([title isEqualToString:@"UIImageView+QMUI"]) {
        viewController = [[QDImageViewViewController alloc] init];
    }
    else if ([title isEqualToString:@"QMUILabel"]) {
        viewController = [[QDLabelViewController alloc] init];
    }
    else if ([title isEqualToString:@"QMUITextView"]) {
        viewController = [[QDTextViewController alloc] init];
    }
    else if ([title isEqualToString:@"QMUITextField"]) {
        viewController = [[QDTextFieldViewController alloc] init];
    }
    else if ([title isEqualToString:@"QMUISlider"]) {
        viewController = [[QDSliderViewController alloc] init];
    }
    else if ([title isEqualToString:@"QMUITableView"]) {
        viewController = ({
            QDCommonListViewController *vc = [[QDCommonListViewController alloc] init];
            vc.dataSource = @[
                @"(QM)UITableViewCell",
                @"QMUITableViewHeaderFooterView",
                @"QMUITableViewStyleInsetGrouped"];
            __weak __typeof(vc)weakVc1 = vc;
            vc.didSelectTitleBlock = ^(NSString *title) {
                UIViewController *viewController = nil;
                if ([title isEqualToString:@"(QM)UITableViewCell"]) {
                    viewController = ({
                        QDCommonListViewController *vc = [[QDCommonListViewController alloc] init];
                        vc.dataSource = @[
                            @"通过 insets 系列属性调整间距",
                            @"通过 block 调整分隔线位置",
                            @"通过配置表修改 accessoryType 的样式"
                        ];
                        __weak __typeof(vc)weakVc2 = vc;
                        vc.didSelectTitleBlock = ^(NSString *title) {
                            [weakVc2.tableView qmui_clearsSelection];
                            UIViewController *viewController = nil;
                            if ([title isEqualToString:@"通过 insets 系列属性调整间距"]) {
                                viewController = [[QDTableViewCellInsetsViewController alloc] init];
                            } else if ([title isEqualToString:@"通过 block 调整分隔线位置"]) {
                                viewController = [[QDTableViewCellSeparatorInsetsViewController alloc] init];
                            } else if ([title isEqualToString:@"通过配置表修改 accessoryType 的样式"]) {
                                viewController = [[QDTableViewCellAccessoryTypeViewController alloc] init];
                            }
                            viewController.title = title;
                            [weakVc2.navigationController pushViewController:viewController animated:YES];
                        };
                        vc;
                    });
                } else if ([title isEqualToString:@"QMUITableViewHeaderFooterView"]) {
                    viewController = QDTableViewHeaderFooterViewController.new;
                } else if ([title isEqualToString:@"QMUITableViewStyleInsetGrouped"]) {
                    viewController = QDInsetGroupedTableViewController.new;
                }
                viewController.title = title;
                [weakVc1.navigationController pushViewController:viewController animated:YES];
            };
            vc;
        });
    }
    else if ([title isEqualToString:@"QMUIButton"]) {
        viewController = [[QDButtonViewController alloc] init];
    }
    else if ([title isEqualToString:@"UISearchBar+QMUI"]) {
        viewController = ({
            QDCommonListViewController *vc = QDCommonListViewController.new;
            vc.dataSource = @[
                @"UISearchBar(QMUI)",
                @"QMUISearchController",
            ];
            __weak __typeof(vc)weakVc = vc;
            vc.didSelectTitleBlock = ^(NSString *title) {
                UIViewController *viewController = nil;
                if ([title isEqualToString:@"UISearchBar(QMUI)"]) {
                    viewController = QDSearchBarViewController.new;
                } else if ([title isEqualToString:@"QMUISearchController"]) {
                    viewController = QDSearchViewController.new;
                }
                viewController.title = title;
                [weakVc.navigationController pushViewController:viewController animated:YES];
            };
            vc;
        });
    }
    else if ([title isEqualToString:@"QMUIAlertController"]) {
        viewController = [[QDAlertController alloc] init];
    }
    else if ([title isEqualToString:@"ViewController Orientation"]) {
        viewController = [[QDOrientationViewController alloc] init];
    }
    else if ([title isEqualToString:@"QMUINavigationController"]) {
        viewController = [[QDNavigationListViewController alloc] init];
    }
    else if ([title isEqualToString:@"UITabBarItem+QMUI"]) {
        viewController = [[QDTabBarItemViewController alloc] init];
    }
    else if ([title isEqualToString:@"UIFont+QMUI"]) {
        viewController = [[QDFontViewController alloc] init];
    }
    else if ([title isEqualToString:@"UIControl+QMUI"]) {
        viewController = [[QDControlViewController alloc] init];
    }
    else if ([title isEqualToString:@"UIView+QMUI"]) {
        viewController = ({
            QDCommonListViewController *vc = [[QDCommonListViewController alloc] init];
            vc.dataSource = @[
                @"UIView (QMUI_Border)",
                @"UIView (QMUI_Debug)",
                @"UIView (QMUI_Layout)"];
            __weak __typeof(vc)weakVc = vc;
            vc.didSelectTitleBlock = ^(NSString *title) {
                UIViewController *viewController = nil;
                if ([title isEqualToString:@"UIView (QMUI_Border)"]) {
                    viewController = [[QDUIViewBorderViewController alloc] init];
                } else if ([title isEqualToString:@"UIView (QMUI_Debug)"]) {
                    viewController = [[QDUIViewDebugViewController alloc] init];
                } else if ([title isEqualToString:@"UIView (QMUI_Layout)"]) {
                    viewController = [[QDUIViewLayoutViewController alloc] init];
                }
                viewController.title = title;
                [weakVc.navigationController pushViewController:viewController animated:YES];
            };
            vc;
        });
    }
    else if ([title isEqualToString:@"NSObject+QMUI"]) {
        viewController = [[QDObjectViewController alloc] init];
    }
    else if ([title isEqualToString:@"CAAnimation+QMUI"]) {
        viewController = [[QDCAAnimationViewController alloc] init];
    }
    viewController.title = title;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)handleAboutItemEvent {
    QDAboutViewController *viewController = [[QDAboutViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
