//
//  QDUIKitViewController.m
//  qmuidemo
//
//  Created by ZhoonChen on 15/6/2.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QDUIKitViewController.h"
#import "QDColorViewController.h"
#import "QDImageViewController.h"
#import "QDLabelViewController.h"
#import "QDTextViewController.h"
#import "QDTextFieldViewController.h"
#import "QDTableViewController.h"
#import "QDButtonViewController.h"
#import "QDAlertController.h"
#import "QDSearchViewController.h"
#import "QDNavigationListViewController.h"
#import "QDTabBarItemViewController.h"
#import "QDUIViewQMUIViewController.h"
#import "QDCollectionListViewController.h"
#import "QDAboutViewController.h"
#import "QDObjectViewController.h"
#import "QDFontViewController.h"
#import "QDSliderViewController.h"
#import "QDOrientationViewController.h"

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
                       @"QMUICollectionViewLayout", UIImageMake(@"icon_grid_collection"),
                       @"QMUISearchController", UIImageMake(@"icon_grid_search"),
                       @"ViewController Orientation", UIImageMake(@"icon_grid_orientation"),
                       @"QMUINavigationController", UIImageMake(@"icon_grid_navigation"),
                       @"UITabBarItem+QMUI", UIImageMake(@"icon_grid_tabBarItem"),
                       @"UIColor+QMUI", UIImageMake(@"icon_grid_color"),
                       @"UIImage+QMUI", UIImageMake(@"icon_grid_image"),
                       @"UIFont+QMUI", UIImageMake(@"icon_grid_font"),
                       @"UIView+QMUI", UIImageMake(@"icon_grid_view"),
                       @"NSObject+QMUI", UIImageMake(@"icon_grid_nsobject"),
                       nil];
}

- (void)setNavigationItemsIsInEditMode:(BOOL)isInEditMode animated:(BOOL)animated {
    [super setNavigationItemsIsInEditMode:isInEditMode animated:animated];
    self.title = @"QMUIKit";
    self.navigationItem.rightBarButtonItem = [QMUINavigationButton barButtonItemWithImage:UIImageMake(@"icon_nav_about") position:QMUINavigationButtonPositionRight target:self action:@selector(handleAboutItemEvent)];
}

- (void)didSelectCellWithTitle:(NSString *)title {
    UIViewController *viewController = nil;
    if ([title isEqualToString:@"UIColor+QMUI"]) {
        viewController = [[QDColorViewController alloc] init];
    }
    else if ([title isEqualToString:@"UIImage+QMUI"]) {
        viewController = [[QDImageViewController alloc] init];
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
        viewController = [[QDTableViewController alloc] init];
    }
    else if ([title isEqualToString:@"QMUICollectionViewLayout"]) {
        viewController = [[QDCollectionListViewController alloc] init];
    }
    else if ([title isEqualToString:@"QMUIButton"]) {
        viewController = [[QDButtonViewController alloc] init];
    }
    else if ([title isEqualToString:@"QMUISearchController"]) {
        viewController = [[QDSearchViewController alloc] init];
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
    else if ([title isEqualToString:@"UIView+QMUI"]) {
        viewController = [[QDUIViewQMUIViewController alloc] init];
    }
    else if ([title isEqualToString:@"NSObject+QMUI"]) {
        viewController = [[QDObjectViewController alloc] init];
    }
    viewController.title = title;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)handleAboutItemEvent {
    QDAboutViewController *viewController = [[QDAboutViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
