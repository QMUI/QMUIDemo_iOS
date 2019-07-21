//
//  QDLabViewController.m
//  qmui
//
//  Created by QMUI Team on 14/11/5.
//  Copyright (c) 2014年 QMUI Team. All rights reserved.
//

#import "QDLabViewController.h"
#import "QDAnimationViewController.h"
#import "QDAllSystemFontsViewController.h"
#import "QDFontPointSizeAndLineHeightViewController.h"
#import "QDAboutViewController.h"

@interface QDLabViewController ()
@end

@implementation QDLabViewController

- (void)initDataSource {
    [super initDataSource];
    self.dataSource = @[@"All System Fonts",
                        @"Default Line Height",
                        @"Animation",
                        @"Log Manager"
                        ];
}

- (void)didSelectCellWithTitle:(NSString *)title {
    UIViewController *viewController = nil;
    if ([title isEqualToString:@"All System Fonts"]) {
        viewController = [[QDAllSystemFontsViewController alloc] init];
    } else if ([title isEqualToString:@"Default Line Height"]) {
        viewController = [[QDFontPointSizeAndLineHeightViewController alloc] init];
    } else if ([title isEqualToString:@"Animation"]) {
        viewController = [[QDAnimationViewController alloc] init];
    } else if ([title isEqualToString:@"Log Manager"]) {
        viewController = [[QMUILogManagerViewController alloc] init];
        ((QMUILogManagerViewController *)viewController).formatLogNameForSortingBlock = ^NSString *(NSString *logName) {
            NSString *projectPrefix = @"QMUI";
            if ([logName hasPrefix:projectPrefix]) {
                return [logName substringFromIndex:projectPrefix.length];
            }
            return logName;
        };
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
